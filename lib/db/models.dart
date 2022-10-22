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
  int index;
  @HiveField(1)
  String ip;
  @HiveField(2)
  String mac;
  @HiveField(3)
  int id;
  @HiveField(4)
  String name;
  @HiveField(5)
  List lines;
  @HiveField(6)
  List sensors;
  @HiveField(7)
  List zones;
  Device(this.index, this.ip, this.mac, this.id, this.name, this.lines,
      this.sensors, this.zones);

  Device.fromJson(Map<String, dynamic> json)
      : index = json['index'],
        ip = json['ip'],
        id = json['id'],
        mac = json['mac'],
        name = json['name'],
        lines = json['lines'],
        sensors = json['sensors'],
        zones = json['zones'];
  Map<String, dynamic> toJson() {
    return {
      'index': index,
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
  DateTime timestamp;
  @HiveField(1)
  String formatedStamp;
  @HiveField(2)
  int evType;
  @HiveField(3)
  String evName;
  @HiveField(4)
  String deviceName;
  @HiveField(5)
  String info;
  EventItem(this.timestamp, this.formatedStamp, this.evType, this.evName,
      this.deviceName, this.info);

  EventItem.fromJson(Map<String, dynamic> json)
      : timestamp = json['timestamp'],
        formatedStamp = json['formatedStamp'],
        evType = json['evType'],
        evName = json['evName'],
        deviceName = json['deviceName'],
        info = json['info'];
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'formatedStamp': formatedStamp,
      'evType': evType,
      'evName': evName,
      'deviceName': deviceName,
      'info': info,
    };
  }
}

class RadioFinal {
  String name = '';
  String param = '';
  int battery = 0;
  int signal = 0;
  bool isLost = false;
  bool isDischarged = false;
  bool alarm = false;
  RadioFinal(this.name, this.param, this.battery, this.signal, this.isLost,
      this.isDischarged, this.alarm);
}

class AlarmNoti {
  int type = 0;
  String title = '';
  String body = '';
  AlarmNoti(this.type, this.title, this.body);
}

class Equalal {
  int index = 0;
  bool state = false;
  bool alarm1 = false;
  bool alarm2 = false;
  bool sensorIsLost = false;
  bool sensorIsDischarged = false;
  Equalal(this.index, this.state, this.alarm1, this.alarm2, this.sensorIsLost,
      this.sensorIsDischarged);
}
