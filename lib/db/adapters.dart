part of 'db.dart';

class DeviceAdapter extends TypeAdapter<Device> {
  @override
  final typeId = 0;

  @override
  Device read(BinaryReader reader) {
    final index = reader.read();
    final ip = reader.read();
    final mac = reader.read();
    final id = reader.read();
    final name = reader.read();
    final lines = reader.read();
    final sensors = reader.read();
    final zones = reader.read();
    final counters = reader.read();
    final cswitch = reader.read();
    return Device(
        index, ip, mac, id, name, lines, sensors, zones, counters, cswitch);
  }

  @override
  void write(BinaryWriter writer, Device obj) {
    writer.write(obj.index);
    writer.write(obj.ip);
    writer.write(obj.mac);
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.lines);
    writer.write(obj.sensors);
    writer.write(obj.zones);
    writer.write(obj.counters);
    writer.write(obj.cswitch);
  }
}

class EventListAdapter extends TypeAdapter<EventItem> {
  @override
  final typeId = 1;

  @override
  EventItem read(BinaryReader reader) {
    final timestamp = reader.read();
    final formatedStamp = reader.read();
    final evType = reader.read();
    final evName = reader.read();
    final deviceName = reader.read();
    final info = reader.read();
    return EventItem(
        timestamp, formatedStamp, evType, evName, deviceName, info);
  }

  @override
  void write(BinaryWriter writer, EventItem obj) {
    writer.write(obj.timestamp);
    writer.write(obj.formatedStamp);
    writer.write(obj.evType);
    writer.write(obj.evName);
    writer.write(obj.deviceName);
    writer.write(obj.info);
  }
}

class CStatsAdapter extends TypeAdapter<CounterSItem> {
  @override
  final typeId = 2;

  @override
  CounterSItem read(BinaryReader reader) {
    final DateTime date = reader.read();
    final double value = reader.read();
    return CounterSItem(date: date, value: value);
  }

  @override
  void write(BinaryWriter writer, CounterSItem obj) {
    writer.write(obj.date);
    writer.write(obj.value);
  }
}

class PlanAdapter extends TypeAdapter<PlanItem> {
  @override
  final typeId = 3;

  @override
  PlanItem read(BinaryReader reader) {
    final index = reader.read();
    final type = reader.read();
    final date = reader.read();
    final desc = reader.read();
    final state = reader.read();
    final todo = reader.read();
    final resact = reader.read();
    return PlanItem(index, type, date, desc, state, todo, resact);
  }

  @override
  void write(BinaryWriter writer, PlanItem obj) {
    writer.write(obj.index);
    writer.write(obj.type);
    writer.write(obj.date);
    writer.write(obj.desc);
    writer.write(obj.state);
    writer.write(obj.todo);
    writer.write(obj.resact);
  }
}
