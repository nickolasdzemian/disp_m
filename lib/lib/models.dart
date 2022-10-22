class DeviceState {
  int index;
  bool state; // Online/Offline
  String name;
  List linesNames;
  List sensorsNames;
  List zones;
  List registersStates;
  List radioParams;
  DeviceState(this.index, this.state, this.name, this.linesNames,
      this.sensorsNames, this.zones, this.registersStates, this.radioParams);
}

class RegisterState {
  num adrr;
  dynamic value;
  RegisterState(this.adrr, this.value);
}
