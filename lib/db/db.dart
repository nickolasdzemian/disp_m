// import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:neptun_m/che_guevara.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:process_run/shell_run.dart' as shell;
import 'package:neptun_m/lib/err_push.dart';
import 'package:neptun_m/screens/history.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:neptun_m/lib/getters.dart';
part 'dbenv.dart';
part 'models.dart';
part 'adapters.dart';

var devices = Hive.box<Device>(devicesBOXname);
var settings = Hive.box(settingsBOXname);
var events = Hive.box<EventItem>(eventsBOXname);
var climits = Hive.box(limitsBOXname);
var cstats = Hive.box<List>(cstatsBOXname);
var plan = Hive.box<List>(progBOXname);
bool isDEMO = true;
String appDataDirectory = '';

void registerAdapters() {
  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(EventListAdapter());
  Hive.registerAdapter(CStatsAdapter());
  Hive.registerAdapter(PlanAdapter());
}

FutureOr<SentryEvent?> beforeSend(SentryEvent event, {dynamic hint}) async {
  final String eventFile = jsonEncode(event).toString();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final File file = File('$appDataDirectory/ERR_$timestamp.txt');
  if (event.level != SentryLevel.info) {
    await file.writeAsString(eventFile);
  }
  return event;
}

Future<void> initDatabase() async {
  try {
    Hive.init('$appDataDirectory/Data');
    registerAdapters();
    await Hive.openBox<EventItem>(eventsBOXname);
    await Hive.openBox<Device>(devicesBOXname,
        compactionStrategy: (entries, deletedEntries) {
      return deletedEntries > 50; // 50
    });
    await Hive.openBox(settingsBOXname);
    await Hive.openBox(limitsBOXname);
    await Hive.openBox<List>(cstatsBOXname,
        compactionStrategy: (entries, deletedEntries) {
      return deletedEntries > 400; // 50 * 8
    });
    await Hive.openBox<List>(progBOXname,
        compactionStrategy: (entries, deletedEntries) {
      return deletedEntries > 400; // 50 * 8
    });
  } catch (exception, stackTrace) {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://0fab3f35d0354df48ac143d5a6a96ab4@o4504078561771520.ingest.sentry.io/4504078562820096';
        options.tracesSampleRate = 1.0;
        options.debug = false;
        options.enableNativeCrashHandling = true;
        options.beforeSend = beforeSend;
      },
    );
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
    showErrPush(
        'Возникла непредвиденная ошибка! Будет выполнен полный сброс!\n${exception.toString()}');
    DataBase.updateEventList([
      4,
      'Возникла непредвиденная ошибка БД, будет выполнен полный сброс',
      exception.toString(),
    ]);
    try {
      if (allEventsDb().isNotEmpty) {
        exportFile(allEventsDb());
      }
    } catch (e) {
      showErrPush(
          'Экстренное копирование журанала не выполнено!\n${e.toString()}');
      await Sentry.captureException(
        'Also, there is a history db err. WAT?',
        stackTrace: stackTrace,
      );
    }
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await shell.run('cp -r $appDataDirectory ~/Neptun_backup_$timestamp/');
    final dir = Directory(appDataDirectory);
    dir.deleteSync(recursive: true);
    emergencyRestart();
  }

  var initialRun = await settings.get('firstStart');
  if (initialRun == null || initialRun[0] == true) {
    await DataBase.firstRun();
    await settings.put('firstStart', [false, true, true, true]);
    // --- DEMO init ---
    await settings.put('isDEMO', false);
    isDEMO = settings.get('isDEMO');
    // -----------------
    if (Platform.isLinux) {
      // Put files for ffmpeg for audioplayers linux bug workaround (libstream)
      ByteData byteDataCat =
          await rootBundle.load('assets/audios/NeptunCat.mp3');
      ByteData byteDataAlarm = await rootBundle.load('assets/audios/02070.mp3');
      File cat = await File('$appDataDirectory/Sounds/NeptunCat.mp3')
          .create(recursive: true);
      File alarm = await File('$appDataDirectory/Sounds/02070.mp3')
          .create(recursive: true);
      await cat.writeAsBytes(byteDataCat.buffer
          .asUint8List(byteDataCat.offsetInBytes, byteDataCat.lengthInBytes));
      await alarm.writeAsBytes(byteDataAlarm.buffer.asUint8List(
          byteDataAlarm.offsetInBytes, byteDataAlarm.lengthInBytes));
    }
  }
}

List allDevicesDb() {
  bool opened = Hive.isBoxOpen(devicesBOXname);
  var sortedDevices = [];
  if (opened) {
    sortedDevices = devices.values.toList();
    sortedDevices.sort((a, b) => a.index.compareTo(b.index));
  }
  return sortedDevices;
  // return devices.values.toList();
}

List allSettingsDb() {
  return settings.values.toList();
}

List allEventsDb() {
  return events.values.toList();
}

List allLimitsDb() {
  return climits.values.toList();
}

Future<void> closeAllDb() async {
  await devices.compact();
  await events.compact();
  await climits.compact();
  await cstats.compact();
  await plan.compact();

  await devices.flush();
  await settings.flush();
  await events.flush();
  await climits.flush();
  await cstats.flush();
  await plan.flush();

  await devices.close();
  await settings.close();
  await events.close();
  await climits.close();
  await cstats.close();
  await plan.close();
}

/// #### Database operations
/// ##### Limitations:
/// - Keys have to be 32 bit unsigned integers or ASCII Strings with a max length of 255 chars.
/// - The supported integer values include all integers between -2^53 and 2^53, and some integers with larger magnitude
/// - Objects are not allowed to contain cycles. Hive will not detect them and storing will result in an infinite loop.
/// - Only one process can access a box at any time. Bad things happen otherwise.
/// - Boxes are stored as files in the user's app-directory. Common illegal characters/symbols such as /%& should therefore be avoided.
class DataBase {
  static var all = allDevicesDb();
  static var set = allSettingsDb();
  static var jou = allEventsDb();
  // ***************************************************************************
  // Devices database

  /// - add new devices wich were found by scanner [allD]
  static addNew(List allD) async {
    List allDevices = allDevicesDb();
    for (int i = 0; i < allDevices.length; i++) {
      allD = allD.where((el) => el.mac != allDevices[i].mac).toList();
    }
    int index = allDevices.isEmpty ? 0 : allDevices.length;
    for (int i = 0; i < allD.length; i++) {
      index += i;
      String key = allD[i].mac;
      var value = Device(index, allD[i].ip, key, allD[i].id, key, [
        'Линия 1',
        'Линия 2',
        'Линия 3',
        'Линия 4'
      ], [], [
        'Зона I',
        'Зона II'
      ], [
        'Счётчик 1-1',
        'Счётчик 1-2',
        'Счётчик 2-1',
        'Счётчик 2-2',
        'Счётчик 3-1',
        'Счётчик 3-2',
        'Счётчик 4-1',
        'Счётчик 4-2',
      ], [
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
      ]);
      await devices.put(key, value);

      List<double> countLimits = [0, 0, 0, 0, 0, 0, 0, 0];
      await climits.put(key, countLimits);

      final now = DateTime.now().toLocal();
      final List initialStats = [CounterSItem(date: now, value: 0)];
      for (int s = 0; s < 8; s++) {
        await cstats.put('$key-CS$s', initialStats);
      }
      final List emptyProg = <PlanItem>[];
      await plan.put(key, emptyProg);
    }
    equalal0 = [];
    equalal1 = [];
  }

  /// - reorder devices in db from homescreen [allD]
  static reorder(List allD) async {
    await devices.clear();
    for (int i = 0; i < allD.length; i++) {
      String key = allD[i].mac;
      var value = Device(
          i,
          allD[i].ip,
          allD[i].mac,
          allD[i].id,
          allD[i].name,
          allD[i].lines,
          allD[i].sensors,
          allD[i].zones,
          allD[i].counters,
          allD[i].cswitch);
      await devices.put(key, value);
    }
    equalal0 = [];
    equalal1 = [];
  }

  /// - update existing devices IPs wich were found and filtered by scanner [allD]
  static updateIP(List allD) async {
    updateDB(item, ip) async {
      await devices.put(
          item.mac,
          Device(item.index, ip, item.mac, item.id, item.name, item.lines,
              item.sensors, item.zones, item.counters, item.cswtich));
    }

    for (int i = 0; i < allD.length; i++) {
      devices.values
          .where((item) => item.mac == allD[i].mac)
          .forEach((item) => updateDB(item, allD[i].ip));
    }
  }

  /// - update device info (like lines names etc) [device] 98519
  static updateDevice(device) async {
    updateDB(device) async {
      await devices.put(
          device.mac,
          Device(
              device.index,
              device.ip,
              device.mac,
              device.id,
              device.name,
              device.lines,
              device.sensors,
              device.zones,
              device.counters,
              device.cswitch));
    }

    devices.values
        .where((item) => item.mac == device.mac)
        .forEach((item) => updateDB(device));
  }

  /// - delete devices by mac [macs] and update their indexies
  static Future delete(List macs) async {
    for (int i = 0; i < macs.length; i++) {
      String key = macs[i];
      await devices.delete(key);
      await climits.delete(key);
      for (int s = 0; s < 8; s++) {
        await climits.delete('$key-CS$s');
      }
    }

    var newIndexies = allDevicesDb();
    for (int k = 0; k < newIndexies.length; k++) {
      await devices.put(
          newIndexies[k].mac,
          Device(
              k,
              newIndexies[k].ip,
              newIndexies[k].mac,
              newIndexies[k].id,
              newIndexies[k].name,
              newIndexies[k].lines,
              newIndexies[k].sensors,
              newIndexies[k].zones,
              newIndexies[k].counters,
              newIndexies[k].cswitch));
    }
    equalal0 = [];
    equalal1 = [];
  }
  // ***************************************************************************

  // ***************************************************************************
  // Settings database

  /// First start settings definition
  static Future firstRun() async {
    bool autoScan = false;
    await settings.put('autoScan', autoScan);
    bool scanMode = false; // false - рекурсивный, true - интервальный
    await settings.put('scanMode', scanMode);
    int interval = 3;
    await settings.put('interval', interval);
    bool server = false;
    await settings.put('server', server);
    int serverPort = 3003;
    await settings.put('serverPort', serverPort);
    // 0 - alarm, 1 - lost sensor, 2 - sensor discharged, 3 - device offline, 4 - namur counters errs
    List notifications = [true, true, true, false, false];
    await settings.put('notifications', notifications);
    List reserved = [];
    await settings.put('reserved', reserved);
    String updates = 'false';
    await settings.put('updates', updates);
    bool themeMode = true; // light
    await settings.put('themeMode', themeMode);
    List firstStart = [
      true,
      true,
      true,
      true
    ]; // [Common, Device params apply delay, Device params offline, width noti]
    await settings.put('firstStart', firstStart);
    await settings.put('prog', true);
    await settings.put('repeatProg', 2);
    await settings.put('isDEMO', true);
  }

  /// Update parameter and return new value
  static updateOnlySetting(String key, value) async {
    await settings.put(key, value);
    return settings.get(key);
  }
  // ***************************************************************************

  // ***************************************************************************
  // Event list database
  static Future updateEventList(item) async {
    // 0 - alarm, 1 - lost sensor, 2 - sensor discharged, 3 - device offline, 4 - system event
    final List evNames = [
      'Протечка/Тревога',
      'Потеря радиодатчика',
      'Разряд батареи радиодатчика',
      'Устройство не в сети',
      'Системное событие',
      'Ошибка счётчика',
      'Достигнут лимит по счётчику'
    ];
    final now = DateTime.now().toLocal();
    var newFormat = DateFormat("HH:mm:ss, dd.MM.yy");
    var formattedNow = newFormat.format(now);
    final String evName = evNames[item[0]];
    final String deviceName = item[1];
    final String info = item[2];
    events.add(EventItem(
      now,
      formattedNow,
      item[0],
      evName,
      deviceName,
      info,
    ));
  }
  // ***************************************************************************
}

String errParce(s) {
  int e = int.parse(s, radix: 2);
  String res = '';
  switch (e) {
    case 2: // Wrong official registers map (inverted)
      res = 'короткое замыкание';
      break;
    case 1:
      res = 'обрыв линии';
      break;
  }
  return res;
}

String parceLineZones(v, z) {
  String res = '';
  switch (v) {
    case '01':
      res = z[0];
      break;
    case '10':
      res = z[1];
      break;
    case '11':
      res = '${z[0]}, ${z[1]}';
      break;
  }
  return res;
}

void writeAlarmHistory(ad) {
  List<AlarmNoti> alarmsList = [];
  bool multiMegaZona = false;
  bool line1 = false;
  bool line2 = false;
  bool line3 = false;
  bool line4 = false;
  if (ad.state) {
    String reg0 = ad.registersStates[0].value;
    multiMegaZona = reg0.substring(21, 22) == '1';
    String reg3 = ad.registersStates[3].value;
    line1 = reg3.substring(31, 32) == '1';
    line2 = reg3.substring(30, 31) == '1';
    line3 = reg3.substring(29, 30) == '1';
    line4 = reg3.substring(28, 29) == '1';
    String reg1 = ad.registersStates[1].value;
    String reg2 = ad.registersStates[2].value;
    String valvesLine1 = reg1.substring(23, 25);
    String valvesLine2 = reg1.substring(30, 32);
    String valvesLine3 = reg2.substring(23, 25);
    String valvesLine4 = reg2.substring(30, 32);
    List linesNames = ad.linesNames;
    List zones = ad.zones;
    if (line1) {
      String lzone1 = multiMegaZona
          ? ', Зона(-ы): ${parceLineZones(valvesLine1, zones)}'
          : '';
      alarmsList.add(AlarmNoti(
          0, '', 'Обнаружена протечка - Линия 1: ${linesNames[0]}$lzone1'));
    } else if (line2) {
      String lzone2 = multiMegaZona
          ? ', Зона(-ы): ${parceLineZones(valvesLine2, zones)}'
          : '';
      alarmsList.add(AlarmNoti(
          0, '', 'Обнаружена протечка - Линия 2: ${linesNames[1]}$lzone2'));
    } else if (line3) {
      String lzone3 = multiMegaZona
          ? ', Зона(-ы): ${parceLineZones(valvesLine3, zones)}'
          : '';
      alarmsList.add(AlarmNoti(
          0, '', 'Обнаружена протечка - Линия 3: ${linesNames[2]}$lzone3'));
    } else if (line4) {
      String lzone4 = multiMegaZona
          ? ', Зона(-ы): ${parceLineZones(valvesLine4, zones)}'
          : '';
      alarmsList.add(AlarmNoti(
          0, '', 'Обнаружена протечка - Линия 4: ${linesNames[3]}$lzone4'));
    }

    // Parse radio sensors states
    int sensorsAmount = ad.registersStates[6].value;
    for (int s = 7; s < sensorsAmount + 7; s++) {
      var oneRadioState = ad.registersStates[s].value;
      var oneRadioParam = ad.radioParams[s - 6].value;
      bool lost = oneRadioState.substring(29, 30) == '1';
      bool discharged = oneRadioState.substring(30, 31) == '1';
      bool alarma = oneRadioState.substring(31, 32) == '1';
      String name = ad.sensorsNames[s - 7];
      String zonereg = oneRadioParam.substring(30, 32);
      String zone = zonereg == '01'
          ? zones[0]
          : zonereg == '10'
              ? zones[1]
              : '${zones[0]}, ${zones[1]}';

      if (alarma && !multiMegaZona) {
        alarmsList
            .add(AlarmNoti(0, '', 'Обнаружена протечка - Радиодатчик: $name'));
      } else if (alarma && multiMegaZona) {
        alarmsList.add(AlarmNoti(0, '',
            'Обнаружена протечка - Радиодатчик: $name, Зона(-ы): $zone'));
      } else if (discharged) {
        alarmsList.add(
            AlarmNoti(2, '', 'Разряжена батарея в беспроводном датчике $name'));
      } else if (lost) {
        alarmsList.add(
            AlarmNoti(1, '', 'Потеря связи с беспроводным датчиком $name'));
      }
    }

    // Parce counters overlimits and errors
    bool counter = false;
    bool overlimit = false;
    var thisdevice = allDevicesDb()[ad.index];
    bool scanCParams =
        thisdevice.cswitch.where((sp) => sp == true).toList().length > 0;
    if (scanCParams) {
      for (int cp = 0; cp < ad.countersNames.length; cp++) {
        bool cstate = ad.countersParams[cp].value.substring(31, 32) == '1';
        counter = ad.countersParams[cp].value.substring(28, 30) != '00';
        List cc = ad.countersStates[cp].value;
        num litres = cc[0] << 16 | cc[1];
        double cvalue = litres / 1000;
        List<double> limits = climits.get(thisdevice.mac);
        overlimit = limits[cp] > 0 && cvalue > limits[cp];
        String name = ad.countersNames[cp];
        if (counter && cstate) {
          alarmsList.add(AlarmNoti(5, '',
              '$name - ${errParce(ad.countersParams[cp].value.substring(28, 30))}'));
        }
        if (overlimit && cstate) {
          alarmsList.add(AlarmNoti(
              6, '', '$name - превышение на ${cvalue - limits[cp]}м³'));
        }
      }
    }
  }

  if (alarmsList.isNotEmpty) {
    for (int p = 0; p < alarmsList.length; p++) {
      var onlyData = alarmsList[p];
      DataBase.updateEventList([
        onlyData.type,
        ad.name,
        onlyData.body,
      ]);
    }
  }
}
