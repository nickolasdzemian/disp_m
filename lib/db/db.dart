// import 'dart:developer';
import 'package:hive/hive.dart';
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
  return devices.values.toList();
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
    for (int i = 0; i < allD.length; i++) {
      String key = allD[i].mac;
      var value = Device(
          allD[i].ip, key, allD[i].id, allD[i].mac, ['', '', '', ''], [], []);
      await devices.put(key, value);
    }
  }

  /// - update existing devices IPs wich were found and filtered by scanner [allD]
  static updateIP(List allD) async {
    updateDB(item, ip) async {
      await devices.put(
          item.mac,
          Device(ip, item.mac, item.id, item.mac, item.lines, item.sensors,
              item.zones));
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
          Device(device.ip, device.mac, device.id, device.mac, device.lines,
              device.sensors, device.zones));
    }

    devices.values
        .where((item) => item.mac == device.mac)
        .forEach((item) => updateDB(device));
  }

  /// - delete devices by mac [macs]
  static delete(List macs) async {
    for (int i = 0; i < macs.length; i++) {
      String key = macs[i];
      devices.delete(key);
    }
  }
  // ***************************************************************************

  // ***************************************************************************
  // Settings database

  /// First start settings definition
  static Future firstRun() async {
    bool autoScan = false;
    await settings.put('autoScan', autoScan);
    int interval = 3;
    await settings.put('interval', interval);
    bool server = false;
    await settings.put('server', server);
    int serverPort = 3001;
    await settings.put('serverPort', serverPort);
    List notifications = [true, true, true, true];
    await settings.put('notifications', notifications);
    List reserved = [];
    await settings.put('reserved', reserved);
    String updates = 'false';
    await settings.put('updates', updates);
    bool themeMode = true; // light
    await settings.put('themeMode', themeMode);
    bool firstStart = true;
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
    events.add(EventItem(
      item.timestamp,
      item.evName,
      item.deviceName,
      item.triggers,
    ));
  }
  // ***************************************************************************
}
