part of 'db.dart';

class Line {
  String name;
  Line(this.name);
}

class Sensor {
  String name;
  Sensor(this.name);
}

class Device {
  @HiveField(0)
  String ip;
  @HiveField(1)
  String mac;
  @HiveField(2)
  int id;
  @HiveField(3)
  String name;
  @HiveField(4)
  List lines;
  @HiveField(5)
  List sensors;
  @HiveField(6)
  List zones;
  Device(this.ip, this.mac, this.id, this.name, this.lines, this.sensors,
      this.zones);

  Device.fromJson(Map<String, dynamic> json)
      : ip = json['ip'],
        id = json['id'],
        mac = json['mac'],
        name = json['name'],
        lines = json['lines'],
        sensors = json['sensors'],
        zones = json['zones'];
  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'id': id,
      'mac': mac,
      'name': name,
      'lines': lines,
      'sensors': sensors,
      'zones': zones,
    };
  }
}

class Settings {
  @HiveField(0)
  bool autoScan;
  @HiveField(1)
  int interval;
  @HiveField(2)
  bool server;
  @HiveField(3)
  int serverPort;
  @HiveField(4)
  List notifications;
  @HiveField(5)
  List reserved;
  @HiveField(6)
  String updates;
  @HiveField(7)
  bool zorro = true;
  Settings(this.autoScan, this.interval, this.server, this.serverPort,
      this.notifications, this.reserved, this.updates, this.zorro);
}

class SettingInt {
  @HiveField(0)
  int value;
  SettingInt(this.value);
}

class SettingBool {
  @HiveField(0)
  bool value;
  SettingBool(this.value);
}

class SettingString {
  @HiveField(0)
  String value;
  SettingString(this.value);
}

class SettingList {
  @HiveField(0)
  List value;
  SettingList(this.value);
}

class EventItem {
  @HiveField(0)
  String timestamp;
  @HiveField(1)
  String evName;
  @HiveField(2)
  String deviceName;
  @HiveField(3)
  List triggers;
  EventItem(this.timestamp, this.evName, this.deviceName, this.triggers);

  EventItem.fromJson(Map<String, dynamic> json)
      : timestamp = json['timestamp'],
        evName = json['evName'],
        deviceName = json['deviceName'],
        triggers = json['triggers'];
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'evName': evName,
      'deviceName': deviceName,
      'triggers': triggers,
    };
  }
}
