part of '../../home.dart';

Container deviceItemBoxView(context, item, child) {
  bool state = item.state;
  bool alarmTotal = false;
  bool yellowAlarm = false;
  if (state) {
    String reg0 = item?.registersStates[0]?.value;
    bool alarmTotal1 = reg0.substring(29, 30) == '1';
    bool alarmTotal2 = reg0.substring(30, 31) == '1';
    bool sensorIsLost = reg0.substring(27, 28) == '1';
    bool sensorIsDischarged = reg0.substring(28, 29) == '1';
    if (alarmTotal1 || alarmTotal2) {
      alarmTotal = true;
    } else if (sensorIsLost || sensorIsDischarged) {
      yellowAlarm = true;
    }
  }
  double paddingStep = alarmTotal
      ? 17
      : !state
          ? 19
          : 20;
  return Container(
      key: UniqueKey(),
      height: 265,
      width: 360,
      margin: const EdgeInsets.only(top: 25, left: 17.5, right: 17.5),
      padding: EdgeInsets.only(
          left: paddingStep, top: paddingStep, right: 3, bottom: paddingStep),
      decoration: BoxDecoration(
        border: alarmTotal
            ? Border.all(width: 3, color: Theme.of(context).colorScheme.error)
            : !state || yellowAlarm
                ? Border.all(width: 1, color: Colors.yellow)
                : null,
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: alarmTotal
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.shadow,
            offset: const Offset(1, 5),
            spreadRadius: -10,
            blurRadius: 10,
          ),
        ],
      ),
      child: child);
}
