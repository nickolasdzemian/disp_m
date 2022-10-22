// import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
part 'dbenv.dart';
part 'models.dart';
part 'adapters.dart';

var devices = Hive.box<Device>(devicesBOXname);
var settings = Hive.box(settingsBOXname);
var events = Hive.box<EventItem>(eventsBOXname);
String appDataDirectory = '';

void registerAdapters() {
  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(EventListAdapter());
}

List allDevicesDb() {
  var sortedDevices = devices.values.toList();
  sortedDevices.sort((a, b) => a.index.compareTo(b.index));
  return sortedDevices;
  // return devices.values.toList();
}

List allSettingsDb() {
  return settings.values.toList();
}

List allEventsDb() {
  return events.values.toList();
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
    int index = allDevicesDb().isEmpty ? 0 : allDevicesDb().length;
    for (int i = 0; i < allD.length; i++) {
      if (allDevicesDb().isNotEmpty && allDevicesDb()[i].mac == allD[i].mac) {
        // devices.deleteAt(toDelExist);
        break;
      } else {
        index += i;
        String key = allD[i].mac;
        var value = Device(
            index,
            allD[i].ip,
            key,
            allD[i].id,
            key,
            ['Линия 1', 'Линия 2', 'Линия 3', 'Линия 4'],
            [],
            ['Зона I', 'Зона II']);
        await devices.put(key, value);
      }
    }
  }

  /// - reorder devices in db from homescreen [allD]
  static reorder(List allD) async {
    await devices.clear();
    for (int i = 0; i < allD.length; i++) {
      String key = allD[i].mac;
      var value = Device(i, allD[i].ip, allD[i].mac, allD[i].id, allD[i].name,
          allD[i].lines, allD[i].sensors, allD[i].zones);
      await devices.put(key, value);
    }
  }

  /// - update existing devices IPs wich were found and filtered by scanner [allD]
  static updateIP(List allD) async {
    updateDB(item, ip) async {
      await devices.put(
          item.mac,
          Device(item.index, ip, item.mac, item.id, item.name, item.lines,
              item.sensors, item.zones));
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
          Device(device.index, device.ip, device.mac, device.id, device.name,
              device.lines, device.sensors, device.zones));
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
              newIndexies[k].zones));
    }
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
    int serverPort = 3001;
    await settings.put('serverPort', serverPort);
    // 0 - alarm, 1 - lost sensor, 2 - sensor discharged, 3 - device offline
    List notifications = [true, true, true, false];
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
      true
    ]; // [Common, Device params apply delay, Device params offline]
    await settings.put('firstStart', firstStart);
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
      'Системное событие'
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
