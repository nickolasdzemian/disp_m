part of 'db.dart';

@HiveType(typeId: 0, adapterName: "DeviceAdapter")
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
  @HiveField(8)
  List counters;
  @HiveField(9)
  List cswitch;
  Device(this.index, this.ip, this.mac, this.id, this.name, this.lines,
      this.sensors, this.zones, this.counters, this.cswitch);

  Device.fromJson(Map<String, dynamic> json)
      : index = json['index'],
        ip = json['ip'],
        id = json['id'],
        mac = json['mac'],
        name = json['name'],
        lines = json['lines'],
        sensors = json['sensors'],
        zones = json['zones'],
        counters = json['counters'],
        cswitch = json['cswitch'];
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
      'counters': counters,
      'cswitch': cswitch,
    };
  }
}

@HiveType(typeId: 1, adapterName: "EventListAdapter")
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
      'timestamp': timestamp.toIso8601String(),
      'formatedStamp': formatedStamp,
      'evType': evType,
      'evName': evName,
      'deviceName': deviceName,
      'info': info,
    };
  }
}

@HiveType(typeId: 2, adapterName: "CStatsAdapter")
class CounterSItem extends HiveObject {
  @HiveField(0)
  DateTime date;
  @HiveField(1)
  double value;
  CounterSItem({required this.date, required this.value});

  CounterSItem.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        value = json['value'];
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'value': value,
    };
  }
}

@HiveType(typeId: 3, adapterName: "PlanAdapter")
class PlanItem {
  @HiveField(0)
  int index;
  @HiveField(1)
  int type;
  @HiveField(2)
  DateTime date;
  @HiveField(3)
  String desc;
  @HiveField(4)
  int state;
  @HiveField(5)
  List todo;
  @HiveField(6)
  DateTime resact;
  PlanItem(this.index, this.type, this.date, this.desc, this.state, this.todo,
      this.resact);

  PlanItem.fromJson(Map<String, dynamic> json)
      : index = json['index'],
        type = json['type'],
        date = json['date'],
        desc = json['desc'],
        state = json['state'],
        todo = json['todo'],
        resact = json['resact'];
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'type': type,
      'date': date,
      'desc': desc,
      'state': state,
      'todo': todo,
      'resact': resact,
    };
  }
}

// -----------------------------------------------------------------------------

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
  bool counter = false;
  bool overlimit = false;
  Equalal(this.index, this.state, this.alarm1, this.alarm2, this.sensorIsLost,
      this.sensorIsDischarged, this.counter, this.overlimit);
}

class CounterFinal {
  int index = 0;
  String name = '';
  double value = 0;
  bool state = false;
  bool type = false; // true = namur
  String err = '';
  String step = '';
  String position = '';
  double limit = 0;
  String reg = '';
  CounterFinal(this.index, this.name, this.value, this.state, this.type,
      this.err, this.step, this.position, this.limit, this.reg);
}

class CounterNavArguments {
  final String title;
  final Device itemDb;
  final CounterFinal item;
  final Function updateoneDeviceCounters;
  final Function updateoneDeviceCountersParams;

  CounterNavArguments(this.title, this.itemDb, this.item,
      this.updateoneDeviceCounters, this.updateoneDeviceCountersParams);
}

class ProgNavArguments {
  final Device itemDb;
  final Function updateEvents;
  final String key;

  ProgNavArguments(this.itemDb, this.updateEvents, this.key);
}
