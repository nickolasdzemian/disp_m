// ignore_for_file: unnecessary_string_escapes

import 'dart:async';
import 'package:neptun_m/lib/modbus/modbus.dart' as modbus;
import 'package:neptun_m/db/db.dart';
import 'package:neptun_m/connect/scan.dart';
import 'package:neptun_m/lib/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// .............................................................................
import 'dart:io';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/services.dart';
import 'package:restart_app/restart_app.dart';
// .............................................................................
import 'package:neptun_m/lib/err_push.dart';
// .............................................................................
import 'package:neptun_m/lib/cstats.dart';
import 'package:neptun_m/lib/plan.dart';
import 'package:neptun_m/api/route.dart';

part './helpers.dart';
part './grnd_alarm.dart';

int thisIDX = 666;

Timer? _timer;
// int _timerHash = 0;

const doradura = Duration(seconds: 1);
String noll = '0';
bool run = false;
bool runner = false;
bool errr = false;

// num registers = 106 + 1; // Max 0x130; this MVP 0x106
List registersStates = [];
List sensorsNames = [];
List<DeviceState> devicesStates = [];
List<DeviceState> devicesStatesNew = [];
List deviceParams = [];
List deviceParamsNew = [];
List deviceParamsTemp = [];
List deviceCountersStates = [];
List deviceCountersParams = [];
List deviceOneState = [];
List deviceOneParams = [];
List deviceOneCountersStates = [];
List deviceOneCountersParams = [];

int lostCounter = 0;
List lost = [];
String statusDispTop = '';

/// Get and parce specified register to string representation of 32-bit bin
Future<dynamic> read(client, int register, int length) async {
  var response = await client.readHoldingRegisters(register, length);
  return response;
}

/// #### Requests all devices states and update states via Provider
class StatesModel extends Cubit<List> {
  StatesModel() : super([]);

  // ***************************************************************************
  //          Implementation of background native service for Android
  // ***************************************************************************

  // final platform = const MethodChannel('com.example.neptun_m/common');
  // platform.setMethodCallHandler((call) => methodHandler(call));
  // Future<void> methodHandler(MethodCall call) async {
  //   switch (call.method) {
  //     case "zaloop":
  //       print('ДА ПРЕИСПОЛНИТСЯ ПИЗДА СПЕРМОЮ');
  //       slave();
  //       break;
  //   }
  // }

  /// Worker for background request on Android
  Future<void> slave() async {
    run = true;
    runner = true;
    await getState();
    devicesStatesNew = devicesStates;
    devicesStates = [];
    if (devicesStatesNew.isNotEmpty && devicesStatesNew.length == all.length) {
      devicesStatesNew.sort((a, b) => a.index.compareTo(b.index));
      try {
        await checkAlarms(devicesStatesNew);
      } catch (e) {
        DataBase.updateEventList([
          4,
          'Возникла ошибка, выполнен перезапуск',
          e.toString(),
        ]);
      }
      devicesStatesNew = [];
    }
    runner = false;
  }
  // ---------------------------------------------------------------------------

  var all = allDevicesDb();
  var set = allSettingsDb();
  var jou = allEventsDb();

  // Cycle and states resetting
  stopTimer() {
    run = false;
    statusDispTop = '- ОСТАНОВЛЕНА';
    setWindowTitleState();
    _timer?.cancel();
    registersStates = [];
    devicesStates = [];
    devicesStatesNew = [];
    deviceParamsTemp = [];
    SystemSound.play(SystemSoundType.alert);
    DataBase.updateEventList([
      4,
      'Опрос остановлен',
      'Выполнена остановка периодического опроса устройств. Обновление состояния не производится',
    ]);
  }

  // Restart cycle
  Future<void> restartTimer() async {
    run = false;
    _timer?.cancel();
    registersStates = [];
    devicesStates = [];
    devicesStatesNew = [];
    deviceParamsTemp = [];
    run = true;
    DataBase.updateEventList([
      4,
      'Опрос остановлен',
      'Выполнена остановка периодического опроса устройств. Обновление состояния не производится',
    ]);
    await zaloop();
  }

  /// Requests all devices at set interval (can be changed in app settings)
  /// - default interval is 3 seconds
  Future<void> zaloop() async {
    int duration; // Default value
    bool mainMode = false;
    // Additional reinsurance
    set.isNotEmpty ? duration = settings.get('interval') : duration = 3;
    set.isNotEmpty ? mainMode = settings.get('scanMode') : mainMode = false;
    var dura = Duration(seconds: duration);

    // Worker for trigger request method and put new states via emitter
    Future<void> worker() async {
      run = true;
      statusDispTop = '- В РАБОТЕ';
      setWindowTitleState();
      runner = true;
      await getState();
      devicesStatesNew = devicesStates;
      devicesStates = [];
      if (devicesStatesNew.isNotEmpty &&
          devicesStatesNew.length == all.length) {
        devicesStatesNew.sort((a, b) => a.index.compareTo(b.index));
        try {
          emit(devicesStatesNew);
          serveStates = devicesStatesNew;
        } catch (e) {
          stopTimer();
          run = false;
          statusDispTop = '- ОШИБКА';
          setWindowTitleState();
          errr = true;
          // showErrPush(
          //     'Возникла непредвиденная ошибка! Требуется перезапуск!\n${e.toString()}');
          DataBase.updateEventList([
            4,
            'Возникла ошибка, выполнен перезапуск',
            e.toString(),
          ]);
          // restartTimer();
        }
        devicesStatesNew = [];
      }
      runner = false;
    }

    // *************************************************************************
    //                  MAIN LOOP WORKER with two modes
    // *************************************************************************
    // Additional reinsurance for timers (implemented by [hashCode])
    // _timer?.hashCode != _timerHash ? _timer?.cancel() : null;
    // if (_timer != null) {
    //   _timerHash = _timer.hashCode;
    // }

    if (mainMode) {
      _timer?.cancel();
      _timer = Timer.periodic(dura, (timer) async {
        await worker();
        // return timer.cancel();
      });
    } else if (!mainMode) {
      while (run) {
        await Future.delayed(dura, () async {
          await worker();
        });
      }
    }
    // *************************************************************************
  }

  /// Automatic recconnect lost devices
  Future<void> recconect() async {
    bool mode = false; // Default value
    set.isNotEmpty ? mode = await settings.get('autoScan') : null;
    if (lost.isNotEmpty && mode) {
      lostCounter++;
      if (lostCounter % 10 == 0 && lostCounter < 110) {
        stopTimer();
        statusDispTop = '- ПЕРЕПОДКЛЮЧЕНИЕ';
        setWindowTitleState();
        showErrPush(
            'Выполняется поиск и переподключение устройств из-за потери связи..');
        DataBase.updateEventList([
          4,
          'Переподключение',
          'Запущено автоматическое сканирование и обновление данных для устройств не вышедших на связь',
        ]);
        SystemSound.play(SystemSoundType.alert);
        await Scan.getAllDevices(lost, null);
        lost = [];
        run = true;
        statusDispTop = '- В РАБОТЕ';
        setWindowTitleState();
        await zaloop();
      }
      if (lostCounter > 1000) {
        lostCounter = 0;
      }
    }
  }

  // ***************************************************************************
  //                GET STATES OF DEVICES OR THROW ERROR
  // ***************************************************************************
  Future<void> getState() async {
    all = allDevicesDb();
    if (all.isNotEmpty && run) {
      for (int i = 0; i < all.length; i++) {
        // ---------------------------------------------------------------------
        if (!run) {
          // print('stopped $i');
          stopTimer();
          break;
        }
        // print(i);
        // ---------------------------------------------------------------------

        thisIDX = all[i].index;
        int id = all[i].id;
        bool scanCParams =
            all[i].cswitch.where((i) => i == true).toList().length > 0;
        int cidx = 0;
        var client = modbus.createTcpClient(all[i].ip,
            port: 503,
            mode: modbus.ModbusMode.rtu,
            timeout: doradura,
            unitId: id);
        try {
          await client.connect();
          var response = await read(client, 0, 123);
          num sensorsAmount = 0;
          if (response.isNotEmpty) {
            for (num j = 0; j < response.length; j++) {
              var oneRegState = response.elementAt(j).toRadixString(2);
              if (oneRegState.length < 32) {
                num fixed = 32 - oneRegState.length;
                for (int k = 0; k < fixed; k++) {
                  oneRegState = noll + oneRegState;
                }
              }
              // if (j + 50 - sensorsAmount == registers) {
              //   break;
              // }
              if (j == 6) {
                oneRegState = response.elementAt(j);
                sensorsAmount = oneRegState;
                registersStates.add(RegisterState(j, oneRegState));
                // Sensors names init
                for (int m = 0; m < sensorsAmount; m++) {
                  if (all[i].sensors.length < sensorsAmount) {
                    sensorsNames = all[i].sensors;
                    sensorsNames.add('Датчик ${m + 1}');
                    await DataBase.updateDevice(Device(
                        all[i].index,
                        all[i].ip,
                        all[i].mac,
                        all[i].id,
                        all[i].name,
                        all[i].lines,
                        sensorsNames,
                        all[i].zones,
                        all[i].counters,
                        all[i].cswitch));
                    sensorsNames = [];
                  }
                }
                // Skip sensors params
                j += 50;
              } else if (j > 106 && j < 123) {
                deviceCountersStates.add(RegisterState(
                    j, [response.elementAt(j), response.elementAt(j + 1)]));

                // Write stats if counter is ON in db
                if (all[i].cswitch[cidx]) {
                  await writeStats(all[i].mac, cidx,
                      [response.elementAt(j), response.elementAt(j + 1)]);
                }

                j++;
                cidx++;
              } else {
                registersStates.add(RegisterState(j, oneRegState));
              }
            }
            // Radio params for permanent saving to var
            num paramsLength = 58;
            for (num j = 6; j < paramsLength; j++) {
              var oneRegState = response.elementAt(j).toRadixString(2);
              if (oneRegState.length < 32) {
                num fixed = 32 - oneRegState.length;
                for (int k = 0; k < fixed; k++) {
                  oneRegState = noll + oneRegState;
                }
              }
              if (j == 6) {
                paramsLength = response.elementAt(j) + 7;
                deviceParamsTemp.add(RegisterState(j, response.elementAt(j)));
              } else {
                deviceParamsTemp.add(RegisterState(j, oneRegState));
              }
            }
            // Counters params for permanent saving to var
            if (scanCParams) {
              var responseCP = await read(client, 123, 8);
              for (num j = 0; j < responseCP.length; j++) {
                var oneRegState = responseCP.elementAt(j).toRadixString(2);
                if (oneRegState.length < 32) {
                  num fixed = 32 - oneRegState.length;
                  for (int k = 0; k < fixed; k++) {
                    oneRegState = noll + oneRegState;
                  }
                }
                deviceCountersParams.add(RegisterState(j + 123, oneRegState));
              }
            }
            // inspect(registersStates);
          }

          // Do planned actions
          if (!await doPlan(client, all[i].mac, registersStates[0])) {
            await doPlan(client, all[i].mac, registersStates[0]);
          }

          devicesStates.add(DeviceState(
              all[i].index,
              true,
              all[i].name,
              all[i].lines,
              all[i].sensors,
              all[i].zones,
              registersStates,
              deviceParamsTemp,
              all[i].counters,
              deviceCountersStates,
              deviceCountersParams));
          registersStates = [];
          deviceParamsTemp = [];
          deviceCountersStates = [];
          deviceCountersParams = [];
          lost.removeWhere((lEl) => lEl.mac == all[i].mac);
        } catch (e) {
          await client.close();
          await doPlan(client, all[i].mac, null);
          devicesStates.add(DeviceState(
              all[i].index,
              false,
              all[i].name,
              all[i].lines,
              all[i].sensors,
              all[i].zones,
              [all[i].ip, all[i].mac, all[i].id, e],
              [],
              all[i].counters,
              [],
              []));
          registersStates = [];
          deviceParamsTemp = [];
          lost.add(Scan(all[i].ip, all[i].mac, all[i].id));
          DataBase.updateEventList([
            3,
            all[i].name,
            e.toString(),
          ]);
          // showErrPush(e.toString());
          await recconect();
        } finally {
          await client.close();
        }
      }
    }
  }
  // ***************************************************************************
}

// #############################################################################
//                    GET DEVICE PARAMS OR THROW ERROR
// #############################################################################
/// #### Requests (one) device params and return the result of request
// Future<List> getParams(item) async {
//   deviceParams = [];
//   deviceParamsNew = [];
//   bool success = false;
//   var clientParams = modbus.createTcpClient(item.ip,
//       port: 503,
//       mode: modbus.ModbusMode.rtu,
//       timeout: doradura,
//       unitId: item.id);
//   try {
//     await clientParams.connect();
//     var response = await read(clientParams, 0);
//     num sensorsAmount = 0;
//     if (response.isNotEmpty) {
//       for (num j = 6; j < response.length; j++) {
//         var oneRegState = response.elementAt(j).toRadixString(2);
//         if (oneRegState.length < 32) {
//           num fixed = 32 - oneRegState.length;
//           for (int k = 0; k < fixed; k++) {
//             oneRegState = noll + oneRegState;
//           }
//         }
//         if (j == 6) {
//           oneRegState = response.elementAt(j);
//           sensorsAmount = oneRegState;
//           deviceParams.add(RegisterState(j, oneRegState));
//         } else {
//           deviceParams.add(RegisterState(j, oneRegState));
//         }
//         if (registers - (50 - sensorsAmount) == j + (50 + 1)) {
//           // Skip sensors states
//           // j += 50;
//           break;
//         }
//       }
//       // inspect(deviceParams);
//     }
//     await clientParams.close();
//     success = true;
//     deviceParamsNew = deviceParams;
//     return [success, deviceParamsNew];
//   } catch (e) {
//     SystemSound.play(SystemSoundType.alert);
//     await clientParams.close();
//     return [false];
//   } finally {
//     await clientParams.close();
//   }
// }

/// #### Requests (one) device state and return the result of request
Future<List> getOneDevice(item) async {
  bool success = false;
  int id = item.id;
  var clientOneState = modbus.createTcpClient(item.ip,
      port: 503, mode: modbus.ModbusMode.rtu, timeout: doradura, unitId: id);
  try {
    await clientOneState.connect();
    var response = await read(clientOneState, 0, 123);
    if (response.isNotEmpty) {
      for (num j = 0; j < response.length; j++) {
        var oneRegState = response.elementAt(j).toRadixString(2);
        if (oneRegState.length < 32) {
          num fixed = 32 - oneRegState.length;
          for (int k = 0; k < fixed; k++) {
            oneRegState = noll + oneRegState;
          }
        }
        // if (j + 50 - sensorsAmount == registers) {
        //   break;
        // }
        if (j == 6) {
          oneRegState = response.elementAt(j);
          deviceOneState.add(RegisterState(j, oneRegState));
          // Skip sensors params
          j += 50;
        } else if (j > 106 && j < 123) {
          deviceOneCountersStates.add(RegisterState(
              j, [response.elementAt(j), response.elementAt(j + 1)]));
          j++;
        } else {
          deviceOneState.add(RegisterState(j, oneRegState));
        }
      }
      // Radio params for permanent saving to var
      num paramsLength = 58;
      for (num j = 6; j < paramsLength; j++) {
        var oneRegState = response.elementAt(j).toRadixString(2);
        if (oneRegState.length < 32) {
          num fixed = 32 - oneRegState.length;
          for (int k = 0; k < fixed; k++) {
            oneRegState = noll + oneRegState;
          }
        }
        if (j == 6) {
          paramsLength = response.elementAt(j) + 7;
          deviceOneParams.add(RegisterState(j, response.elementAt(j)));
        } else {
          deviceOneParams.add(RegisterState(j, oneRegState));
        }
      }
      // Counters params for permanent saving to var
      var responseCP = await read(clientOneState, 123, 8);
      for (num j = 0; j < responseCP.length; j++) {
        var oneRegState = responseCP.elementAt(j).toRadixString(2);
        if (oneRegState.length < 32) {
          num fixed = 32 - oneRegState.length;
          for (int k = 0; k < fixed; k++) {
            oneRegState = noll + oneRegState;
          }
        }
        deviceOneCountersParams.add(RegisterState(j + 123, oneRegState));
      }
    }
    var devicesStatesOnly = DeviceState(
        item.index,
        true,
        item.name,
        item.lines,
        item.sensors,
        item.zones,
        deviceOneState,
        deviceOneParams,
        item.counters,
        deviceOneCountersStates,
        deviceOneCountersParams);
    success = true;
    deviceOneState = [];
    deviceOneParams = [];
    deviceOneCountersStates = [];
    deviceOneCountersParams = [];
    return [success, devicesStatesOnly];
  } catch (e) {
    await clientOneState.close();
    deviceOneState = [];
    deviceOneParams = [];
    deviceOneCountersStates = [];
    deviceOneCountersParams = [];
    return [false];
  } finally {
    await clientOneState.close();
    deviceOneState = [];
    deviceOneParams = [];
    deviceOneCountersStates = [];
    deviceOneCountersParams = [];
  }
}

// #############################################################################

// -----------------------------------------------------------------------------
//              OLD PARTIAL REQUEST METHOD (device params)
// -----------------------------------------------------------------------------
/// #### Requests (one) device params and update states via Provider
// class ParamsModel extends Cubit<List> {
//   ParamsModel() : super([]);

//   var all = allDevicesDb();
//   var set = allSettingsDb();
//   var jou = allEventsDb();

//   void getParam(item) async {
//     all = allDevicesDb();
//     deviceParams = [];
//     deviceParamsNew = [];
//     if (all.isNotEmpty) {
//       int id = item.id;
//       var client = modbus.createTcpClient(item.ip,
//           port: 503,
//           mode: modbus.ModbusMode.rtu,
//           timeout: doradura,
//           unitId: id);
//       try {
//         await client.connect();
//         for (num j = 6; j < registers; j++) {
//           if (j == 6) {
//             var sensorsAmount = await read(client, j);
//             // Sensors params
//             for (int k = 0; k < sensorsAmount; k++) {
//               dynamic value = await read(client, j);
//               deviceParams.add(RegisterState(j, value));
//               j++;
//             }
//             j = j + (50 + 1 - sensorsAmount); // ???
//           } else {
//             dynamic value = await read(client, j);
//             deviceParams.add(RegisterState(j, value));
//           }
//         }
//       } catch (e) {
//         inspect(e);
//         // lost.add(Scan(item.ip, item.mac, item.id));
//         await client.close();
//       } finally {
//         await client.close();
//       }
//       if (deviceParams.isNotEmpty) {
//         deviceParamsNew = deviceParams;
//         emit(deviceParamsNew);
//         deviceParams = [];
//       }
//     }
//   }
// }
// -----------------------------------------------------------------------------
