import 'package:neptun_m/db/db.dart';
// import 'dart:developer';

Future<bool> doPlan(client, key, reg0) async {
  bool isSuccess = false;

  List? devPlans = [...plan.get(key)!];

  DateTime now = DateTime.now().toLocal();
  Duration hell = const Duration(hours: 1);
  now = DateTime(now.year, now.month, now.day, now.hour, now.minute);
  int nowWeek = now.weekday;
  int scanInterval = settings.get('interval');
  int intervalMultiplier = settings.get('repeatProg');
  Duration intrvl =
      Duration(seconds: (((scanInterval * intervalMultiplier) + 1) / 2).ceil());

  List actions = [];
  for (int i = 0; i < devPlans.length; i++) {
    DateTime evd = devPlans[i].date;
    switch (devPlans[i].type) {
      case 0: // once
        DateTime evDate =
            DateTime(evd.year, evd.month, evd.day, evd.hour, evd.minute);
        if (now.isAfter(evDate.subtract(intrvl)) &&
            now.isBefore(evDate.add(intrvl)) &&
            (devPlans[i].state != 0) &&
            (now.isAfter(devPlans[i].resact))) {
          actions.add(devPlans[i]);
        }
        break;
      case 1: // every day
        DateTime evDate =
            DateTime(now.year, now.month, now.day, evd.hour, evd.minute);
        if (now.isAfter(evDate.subtract(intrvl)) &&
            now.isBefore(evDate.add(intrvl)) &&
            (devPlans[i].state != 0) &&
            (now.isAfter(devPlans[i].resact))) {
          actions.add(devPlans[i]);
        }
        break;
      case 2: // every week
        DateTime evDate =
            DateTime(now.year, now.month, now.day, evd.hour, evd.minute);
        int evWeek = evDate.weekday;
        if ((now.isAfter(evDate.subtract(intrvl)) &&
                now.isBefore(evDate.add(intrvl))) &&
            (evWeek == nowWeek) &&
            (devPlans[i].state != 0) &&
            (now.isAfter(devPlans[i].resact))) {
          actions.add(devPlans[i]);
        }
        break;
      case 3: // every month
        DateTime evDate =
            DateTime(now.year, now.month, now.day, evd.hour, evd.minute);
        if ((now.isAfter(evDate.subtract(intrvl)) &&
                now.isBefore(evDate.add(intrvl))) &&
            (evd.day == now.day) &&
            (devPlans[i].state != 0) &&
            (now.isAfter(devPlans[i].resact))) {
          actions.add(devPlans[i]);
        }
        break;
    }
  }

  void setErrors() {
    if (actions.isNotEmpty) {
      for (int i = 0; i < devPlans!.length; i++) {
        for (int k = 0; k < actions.length; k++) {
          if (devPlans[i].index == actions[k].index) {
            devPlans[i].state = 2;
          }
        }
      }
    }
  }

  if (actions.isNotEmpty && reg0 != null) {
    String newRegisterState = reg0.value;
    for (int i = 0; i < actions.length; i++) {
      List item = actions[i].todo;
      if (item[0] != 0) {
        String val = (item[0] - 1).toString();
        newRegisterState = newRegisterState.replaceRange(0, 1, val);
      }
      if (item[1] != 0) {
        String val = (item[1] - 1).toString();
        newRegisterState = newRegisterState.replaceRange(23, 24, val);
      }
      if (item[2] != 0) {
        String val = (item[2] - 1).toString();
        newRegisterState = newRegisterState.replaceRange(22, 23, val);
      }
      if (item[3] != 0) {
        String val = (item[3] - 1).toString();
        newRegisterState = newRegisterState.replaceRange(31, 32, val);
      }
    }
    final forsend = int.parse(newRegisterState, radix: 2);
    try {
      final result = await client.writeSingleRegister(0, forsend);
      if (result == forsend) {
        for (int i = 0; i < devPlans.length; i++) {
          for (int k = 0; k < actions.length; k++) {
            if (devPlans[i].index == actions[k].index) {
              devPlans[i].state = 3;
              devPlans[i].resact = now.add(hell);
            }
          }
        }
        isSuccess = true;
      } else {
        setErrors();
      }
    } catch (e) {
      setErrors();
    } finally {}
  } else {
    setErrors();
  }
  actions = [];
  await plan.put(key, devPlans);
  devPlans = [];
  return isSuccess;
}
