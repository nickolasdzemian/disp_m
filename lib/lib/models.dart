part of './getters.dart';

class DeviceState {
  bool state; // Online/Offline
  String name;
  List linesNames;
  List sensorsNames;
  List zones;
  List registersStates;
  DeviceState(this.state, this.name, this.linesNames, this.sensorsNames,
      this.zones, this.registersStates);
}

class RegisterState {
  num adrr;
  dynamic value;
  RegisterState(this.adrr, this.value);
}
