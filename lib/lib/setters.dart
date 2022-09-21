int configStateTo(configState) {
  for (int j = 0; j < configState.length; j++) {
    configState[j] = configState[j].toString();
  }
  var strnumber = configState.join();
  final number = int.parse(strnumber, radix: 2);
  return number;
}
