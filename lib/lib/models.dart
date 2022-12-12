class DeviceState {
  int index;
  bool state; // Online/Offline
  String name;
  List linesNames;
  List sensorsNames;
  List zones;
  List registersStates;
  List radioParams;
  List countersNames;
  List countersStates;
  List countersParams;
  DeviceState(
      this.index,
      this.state,
      this.name,
      this.linesNames,
      this.sensorsNames,
      this.zones,
      this.registersStates,
      this.radioParams,
      this.countersNames,
      this.countersStates,
      this.countersParams);

  DeviceState.fromJson(Map<String, dynamic> json)
      : index = json['index'],
        state = json['state'],
        name = json['name'],
        linesNames = json['linesNames'],
        sensorsNames = json['sensorsNames'],
        zones = json['zones'],
        registersStates = json['registersStates'],
        radioParams = json['radioParams'],
        countersNames = json['countersNames'],
        countersStates = json['countersStates'],
        countersParams = json['countersParams'];
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'state': state,
      'name': name,
      'linesNames': linesNames,
      'sensorsNames': sensorsNames,
      'zones': zones,
      'registersStates': registersStates,
      'radioParams': radioParams,
      'countersNames': countersNames,
      'countersStates': countersStates,
      'countersParams': countersParams,
    };
  }
}

class RegisterState {
  num adrr;
  dynamic value;
  RegisterState(this.adrr, this.value);

  RegisterState.fromJson(Map<String, dynamic> json)
      : adrr = json['adrr'],
        value = json['value'];
  Map<String, dynamic> toJson() {
    return {
      'adrr': adrr,
      'value': value,
    };
  }
}
