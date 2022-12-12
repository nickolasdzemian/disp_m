import 'dart:async';
import 'package:neptun_m/lib/modbus/modbus.dart' as modbus;
import 'package:neptun_m/lib/models.dart';

String noll = '0';

/// Write value or whole register
/// - [initialRegisterState] - initial register state
/// - [vInd] - start index to replace - 1
/// - [vVal] - value to write
/// - [vLen] - length to write
/// - [addr] - register num (address)
/// - [itemDb] - device data from database
Future<List> sendOneRegister(
    initialRegisterState, vInd, vVal, vLen, addr, itemDb) async {
  bool sendResult = false;
  // ignore: prefer_typing_uninitialized_variables
  var oneRegState;

  // ############################### PARCE #####################################
  String newRegisterState =
      initialRegisterState.replaceRange(vInd, (vInd + vLen), vVal);
  final numNewRegisterState = int.parse(newRegisterState, radix: 2);
  // ###########################################################################

  var clientSender = modbus.createTcpClient(itemDb.ip,
      port: 503,
      mode: modbus.ModbusMode.rtu,
      timeout: const Duration(seconds: 3),
      unitId: itemDb.id);
  try {
    await clientSender.connect();

    // +++++++++++++++++++++++++++++ WRITE +++++++++++++++++++++++++++++++++++++
    var newResp =
        await clientSender.writeSingleRegister(addr, numNewRegisterState);
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    // ----------------------------- READ --------------------------------------
    // var newResp = await clientSender.readHoldingRegisters(addr, 1);
    oneRegState = newResp.toRadixString(2);
    if (oneRegState.length < 32) {
      num fixed = 32 - oneRegState.length;
      for (int k = 0; k < fixed; k++) {
        oneRegState = noll + oneRegState;
      }
    }
    // -------------------------------------------------------------------------

    if (numNewRegisterState == newResp) {
      sendResult = true; // Successefull write
    }
    // print('$sendResult $oneRegState');
    return [sendResult, RegisterState(addr, oneRegState)];
  } catch (err) {
    clientSender.close();
    return [false, RegisterState(addr, oneRegState)];
  } finally {
    clientSender.close();
  }
}

List<int> convertPizda(int v) {
  int lsb = v & 65535;
  int msb = v >> 16;
  return [msb, lsb];
}

Future<List> sendCounterValue(v, addr, itemDb) async {
  bool sendResult = false;

  // ############################### PARCE #####################################
  int liters = (v * 1000).toInt();
  int lsb = liters & 65535;
  int msb = liters >> 16;
  // ###########################################################################

  var clientSender = modbus.createTcpClient(itemDb.ip,
      port: 503,
      mode: modbus.ModbusMode.rtu,
      timeout: const Duration(seconds: 3),
      unitId: itemDb.id);
  try {
    await clientSender.connect();

    // +++++++++++++++++++++++++++++ WRITE +++++++++++++++++++++++++++++++++++++
    var newRespMsb = await clientSender.writeSingleRegister(addr, msb);
    var newRespLsb = await clientSender.writeSingleRegister(addr + 1, lsb);
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    if (newRespMsb == msb && newRespLsb == lsb) {
      sendResult = true; // Successefull write
    }
    return [
      sendResult,
      RegisterState(addr, [newRespMsb, newRespLsb])
    ];
  } catch (err) {
    clientSender.close();
    return [
      false,
      RegisterState(addr, [msb, lsb])
    ];
  } finally {
    clientSender.close();
  }
}
