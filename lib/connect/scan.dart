// import 'dart:developer';
import 'dart:io';
import 'package:process_run/shell_run.dart';
import 'package:neptun_m/lib/modbus/lib/modbus.dart' as modbus;
import 'package:neptun_m/db/db.dart';

var controller = ShellLinesController();
var shell = Shell(stdout: controller.sink, verbose: false, throwOnError: false);
const doradura = Duration(seconds: 2);

/// #### Scan local network and return valid Neptun devices
/// - get all devices in local network
/// - validate all devices and save only Neptuns
class Scan {
  String ip;
  String mac;
  num id;
  Scan(this.ip, this.mac, this.id);

  /// #### Scan local network, return IP and mac
  /// - mac-address only standart is IEEE 802
  /// - net-tools must be installed for Linux
  ///
  /// If passed not empty [ex], it will return new ips for only existing devices
  /// - ex = List of alredy added mac-addresses/devices
  static getAllAddresses(List ex) async {
    // var result = await Process.run('arp', ['-a']);
    dynamic result = await shell.run('arp -a');

    // result = result.toString();
    // List output = result.stdout.split('\n');
    // List output = result.split('\n');
    String out = result[0].stdout.toString();
    List output = out.split('\n');

    List allIPs = [];
    List allMACs = [];
    List allD = [];

    if (Platform.isWindows) {
      output.removeRange(0, 2);
    }

    if (output.isNotEmpty) {
      for (int i = 0; i < output.length; i++) {
        var ips = output[i].splitMapJoin(RegExp(r'(?:\d{1,3}\.)+(?:\d{1,3})'),
            // MOST EXACT, but not necessary
            // RegExp(r'^((25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])(\.(?!$)|$)){4}$')
            onMatch: (m) => '${m[0]}',
            onNonMatch: (n) => '');
        var macs = output[i].splitMapJoin(
            // TODO - add support for one digit mac-addresses (MacOS issue)
            RegExp(r'(?:[0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})'),
            onMatch: (m) => '${m[0]}',
            onNonMatch: (n) => '');
        allIPs.add(ips);
        allMACs.add(macs);
      }

      // Remove empty or unsupported items, remove dublicates if persist
      for (int i = 0; i < allIPs.length; i++) {
        if (allIPs[i] == '' || allMACs[i] == '') {
          allIPs.removeAt(i);
          allMACs.removeAt(i);
          i--;
        }
        int j = i < allIPs.length - 1 ? i + 1 : i; // TODO Windows/EMPTY -1 BUG?
        if (j != i && allIPs.isNotEmpty && allMACs.isNotEmpty) {
          if (allIPs[i] == allIPs[j] || allMACs[i] == allMACs[j]) {
            allIPs.removeAt(i);
            allMACs.removeAt(i);
            i--;
          }
        }
      }

      if (ex.isNotEmpty) {
        for (int i = 0; i < ex.length; i++) {
          for (int j = 0; j < allIPs.length; j++) {
            if (allMACs[j] == ex[i].mac) {
              allD.add(Scan(allIPs[j], ex[i].mac, ex[i].id));
            }
          }
        }
      } else {
        for (int i = 0; i < allIPs.length; i++) {
          allD.add(Scan(allIPs[i], allMACs[i], 240));
        }
      }
      // inspect(all);
      return allD;
    }
  }

  /// #### Request all found devices via modbus for validation
  /// If passed not empty [ex], it will return new ips for only existing devices
  /// - ex = List of alredy added mac-addresses/devices
  /// - correct device response by 0x05 register = 61443
  static getAllDevices(List ex, setCount) async {
    List toProceed = await getAllAddresses(ex);
    List allD = [];

    if (toProceed.isNotEmpty) {
      for (int i = 0; i < toProceed.length; i++) {
        var client = modbus.createTcpClient(toProceed[i].ip,
            port: 503,
            mode: modbus.ModbusMode.rtu,
            timeout: doradura, // Timeout set for correct streaming
            unitId: toProceed[i].id); // Default for Neptun
        try {
          await client.connect();
          var response = await client.readHoldingRegisters(0x05, 1);

          if (response.isNotEmpty &&
              response[0] == 61443 &&
              toProceed[i].id == 240) {
            allD.add(Scan(toProceed[i].ip, toProceed[i].mac, 240));
          } else if (response.isNotEmpty) {
            allD.add(Scan(toProceed[i].ip, toProceed[i].mac, toProceed[i].id));
          }
        } catch (e) {
          await client.close();
          // String v = e.toString();
          // v = v.substring(0, 35);
          // print(v);

          // // *******************************************************************
          // // Scan devices at only IP by UnitID
          // // if (v == 'SocketException: Connection timed o') {
          // for (int k = 0; k < 247; k++) {
          //   var iclient = modbus.createTcpClient(toProceed[i].ip,
          //       port: 503,
          //       mode: modbus.ModbusMode.rtu,
          //       timeout: doradura, // Timeout set for correct streaming
          //       unitId: k);
          //   try {
          //     await iclient.connect();
          //     var iresponse = await iclient.readHoldingRegisters(0x05, 1);
          //     if (iresponse.isNotEmpty) {
          //       String sid = iresponse[0].toRadixString(2);
          //       if (sid.length < 32) {
          //         num fixed = 32 - sid.length;
          //         for (int j = 0; j < fixed; j++) {
          //           sid = '0$sid';
          //         }
          //       }
          //       sid = sid.substring(16, 16 + 8);
          //       int iid = int.parse(sid, radix: 2);
          //       print(iid);
          //       all.add(Scan(toProceed[i].ip, toProceed[i].mac, iid));
          //     }
          //   } catch (e) {
          //     await iclient.close();
          //   } finally {
          //     await iclient.close();
          //   }
          // }
          // // } // *****************************************************************
        } finally {
          await client.close();
          if (ex.isEmpty) {
            DataBase.addNew(allD);
          } else {
            DataBase.updateIP(allD);
          }
          if (setCount != null) {
            await setCount();
          }
        }
      }
    }
    // inspect(all);
    return allD;
  }
}
