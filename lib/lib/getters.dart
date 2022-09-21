import 'dart:developer';
import 'dart:async';
import 'package:neptun_m/lib/modbus/lib/modbus.dart' as modbus;
import 'package:neptun_m/db/db.dart';
import 'package:neptun_m/connect/scan.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'models.dart';

Timer? _timer;
// int _timerHash = 0;
bool running = false;

const doradura = Duration(seconds: 1);
String noll = '0';

num registers = 106 + 1; // Max 0x130; this MVP 0x106
List registersStates = [];
List sensorsNames = [];
List devicesStates = [];
List devicesStatesNew = [];
List deviceParams = [];
List deviceParamsNew = [];

int lostCounter = 0;
List lost = [];

/// Stops request periodic timer
void stopTimer() {
  _timer?.cancel();
  devicesStates = [];
  devicesStatesNew = [];
  // timer = null;
  running = false;
}

/// Get and parce specified register to string representation of 32-bit bin
read(client, num register) async {
  var response = await client.readHoldingRegisters(register, 1);
  if (response.isNotEmpty) {
    var state = response[0].toRadixString(2);
    if (state.length < 32) {
      num fixed = 32 - state.length;
      for (int j = 0; j < fixed; j++) {
        state = noll + state;
      }
    }
    if (register == 6) {
      print('Register: $register');
      print('State: $state');
      return response[0];
    } else {
      print('Register: $register');
      print('State: $state');
      return state;
    }
  } else {
    inspect(response);
  }
}

/// #### Requests all devices states and update states via Provider
class StatesModel extends Cubit<List> {
  StatesModel() : super([]);

  var all = allDevicesDb();
  var set = allSettingsDb();
  var jou = allEventsDb();

  /// Requests all devices at set interval (can be changed in app settings)
  /// - default interval is 3 seconds
  zaloop() {
    int duration; // Default value
    // Additional reinsurance
    set.isNotEmpty ? duration = settings.get('interval') : duration = 3;
    print(duration);
    var dura = Duration(seconds: duration);

    worker() async {
      await getState();
      if (devicesStates.isNotEmpty && devicesStates.length == all.length) {
        devicesStatesNew = devicesStates;
        try {
          emit(devicesStatesNew);
        } catch (e) {
          print(e.toString());
          stopTimer();
        }
        devicesStates = [];
      }
      return devicesStatesNew;
    }

    // _timer?.hashCode != _timerHash ? _timer?.cancel() : null;
    // if (_timer != null) {
    //   _timerHash = _timer.hashCode;
    // }
    _timer?.cancel();
    _timer = Timer.periodic(dura, (timer) async {
      await worker();
      // return timer.cancel();
    });
  }

  /// Requests all devices once
  /// - for debugging purposes
  zaloopOnce() async {
    await getState();
  }

  /// Automatic recconnect lost devices
  recconect() async {
    bool mode = false; // Default value
    set.isNotEmpty ? mode = await settings.get('autoScan') : null;
    if (lost.isNotEmpty && mode) {
      lostCounter++;
      if (lostCounter % 10 == 0 && lostCounter < 110) {
        stopTimer();
        await Scan.getAllDevices(lost, null);
        lost = [];
        zaloop();
      }
    }
  }

  getState() async {
    all = allDevicesDb();
    if (all.isNotEmpty) {
      if (devicesStatesNew.length == all.length) {
        devicesStatesNew = [];
      }
      for (int i = 0; i < all.length; i++) {
        int id = all[i].id;
        var client = modbus.createTcpClient(all[i].ip,
            port: 503,
            mode: modbus.ModbusMode.rtu,
            timeout: doradura,
            unitId: id);
        try {
          await client.connect();
          for (num j = 0; j < registers; j++) {
            if (j == 6) {
              var sensorsAmount = await read(client, j);
              j = j + 50; // Skip sensors params
              // Sensors states
              for (int k = 0; k < sensorsAmount; k++) {
                dynamic value = await read(client, j);
                registersStates.add(RegisterState(j, value));
                if (all[i].sensors.isEmpty) {
                  sensorsNames.add(Sensor(''));
                }
                if (all[i].sensors.length != sensorsAmount) {
                  sensorsNames = all[i].sensors;
                  sensorsNames.add(Sensor(''));
                }
                j++;
              }
              if (sensorsNames.isNotEmpty) {
                await DataBase.updateDevice(Device(
                    all[i].ip,
                    all[i].mac,
                    all[i].id,
                    all[i].mac,
                    all[i].lines,
                    sensorsNames,
                    all[i].zones));
                sensorsNames = [];
              }
              j = j + (50 - sensorsAmount); // Skip empty sensors
            } else {
              dynamic value = await read(client, j);
              registersStates.add(RegisterState(j, value));
            }
            if (j == 106) {
              devicesStates.add(DeviceState(true, all[i].name, all[i].lines,
                  all[i].sensors, all[i].zones, registersStates));
              registersStates = [];
            }
          }
        } catch (e) {
          inspect(e);
          await client.close();
          devicesStates.add(DeviceState(false, all[i].name, all[i].lines,
              all[i].sensors, all[i].zones, registersStates));
          registersStates = [];
          lost.add(Scan(all[i].ip, all[i].mac, all[i].id));
          await recconect();
        } finally {
          await client.close();
        }
      }
    }
  }
}

/// #### Requests (one) device params and update states via Provider
class ParamsModel extends Cubit<List> {
  ParamsModel() : super([]);

  var all = allDevicesDb();
  var set = allSettingsDb();
  var jou = allEventsDb();

  void getParam(item) async {
    all = allDevicesDb();
    deviceParamsNew = [];
    if (all.isNotEmpty) {
      int id = item.id;
      var client = modbus.createTcpClient(item.ip,
          port: 503,
          mode: modbus.ModbusMode.rtu,
          timeout: doradura,
          unitId: id);
      try {
        await client.connect();
        for (num j = 6; j < registers; j++) {
          if (j == 6) {
            var sensorsAmount = await read(client, j);
            // Sensors params
            for (int k = 0; k < sensorsAmount; k++) {
              dynamic value = await read(client, j);
              deviceParams.add(RegisterState(j, value));
              j++;
            }
            j = j + (50 - sensorsAmount);
          } else {
            dynamic value = await read(client, j);
            deviceParams.add(RegisterState(j, value));
          }
        }
      } catch (e) {
        inspect(e);
        // lost.add(Scan(item.ip, item.mac, item.id));
        await client.close();
      } finally {
        await client.close();
      }
      if (deviceParams.isNotEmpty) {
        deviceParamsNew = deviceParams;
        emit(deviceParamsNew);
        deviceParams = [];
      }
    }
  }
}
