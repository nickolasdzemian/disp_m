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
    return Device(index, ip, mac, id, name, lines, sensors, zones);
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
  }
}

class SettingIntAdapter extends TypeAdapter<SettingInt> {
  @override
  final typeId = 11;

  @override
  SettingInt read(BinaryReader reader) {
    final value = reader.read();
    return SettingInt(value);
  }

  @override
  void write(BinaryWriter writer, SettingInt obj) {
    writer.write(obj.value);
  }
}

class SettingBoolAdapter extends TypeAdapter<SettingBool> {
  @override
  final typeId = 12;

  @override
  SettingBool read(BinaryReader reader) {
    final value = reader.read();
    return SettingBool(value);
  }

  @override
  void write(BinaryWriter writer, SettingBool obj) {
    writer.write(obj.value);
  }
}

class SettingStringAdapter extends TypeAdapter<SettingString> {
  @override
  final typeId = 13;

  @override
  SettingString read(BinaryReader reader) {
    final value = reader.read();
    return SettingString(value);
  }

  @override
  void write(BinaryWriter writer, SettingString obj) {
    writer.write(obj.value);
  }
}

class SettingListAdapter extends TypeAdapter<SettingList> {
  @override
  final typeId = 14;

  @override
  SettingList read(BinaryReader reader) {
    final value = reader.read();
    return SettingList(value);
  }

  @override
  void write(BinaryWriter writer, SettingList obj) {
    writer.write(obj.value);
  }
}

class EventListAdapter extends TypeAdapter<EventItem> {
  @override
  final typeId = 2;

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
