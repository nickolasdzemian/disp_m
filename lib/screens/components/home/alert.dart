part of '../../home.dart';

Timer? _timerSound;

Future<void> _alertBuilderAlarm(
    context, alarmedDevices, closeThisAlert, bool isAlone) async {
  // 0 - alarm, 1 - lost sensor, 2 - sensor discharged, 3 - device offline, 4 - counter error
  List notifications = settings.get('notifications');
  bool wsize = MediaQuery.of(context).size.width > 800;
  String w = wsize ? '' : '\n';

  String title = wsize ? '!!! ОБНАРУЖЕНА ТРЕВОГА !!!' : '! ТРЕВОГА !';
  List<AlarmNoti> alarmsList = [];
  bool offline = false;
  bool alarmTotal1 = false;
  bool alarmTotal2 = false;
  bool multiMegaZona = false;
  bool sensorIsLost = false;
  bool sensorIsDischarged = false;
  bool line1 = false;
  bool line2 = false;
  bool line3 = false;
  bool line4 = false;
  bool counterErr = false;
  bool overlimited = false;
  for (int i = 0; i < alarmedDevices.length; i++) {
    if (alarmedDevices[i].state) {
      String deviceName = alarmedDevices[i].name;
      String reg0 = alarmedDevices[i].registersStates[0].value;
      alarmTotal1 = reg0.substring(29, 30) == '1';
      alarmTotal2 = reg0.substring(30, 31) == '1';
      multiMegaZona = reg0.substring(21, 22) == '1';
      sensorIsLost = reg0.substring(27, 28) == '1';
      sensorIsDischarged = reg0.substring(28, 29) == '1';
      String reg3 = alarmedDevices[i].registersStates[3].value;
      line1 = reg3.substring(31, 32) == '1';
      line2 = reg3.substring(30, 31) == '1';
      line3 = reg3.substring(29, 30) == '1';
      line4 = reg3.substring(28, 29) == '1';
      String reg1 = alarmedDevices[i].registersStates[1].value;
      String reg2 = alarmedDevices[i].registersStates[2].value;
      String valvesLine1 = reg1.substring(23, 25);
      String valvesLine2 = reg1.substring(30, 32);
      String valvesLine3 = reg2.substring(23, 25);
      String valvesLine4 = reg2.substring(30, 32);
      List linesNames = alarmedDevices[i].linesNames;
      List zones = alarmedDevices[i].zones;
      if (line1 && (notifications[0] || isAlone)) {
        String lzone1 = multiMegaZona
            ? '$w, зона(-ы): ${parceLineZones(valvesLine1, zones)}'
            : '';
        alarmsList.add(AlarmNoti(0, '$deviceName$w - Обнаружена протечка',
            'Линия 1: ${linesNames[0]}$lzone1'));
      } else if (line2 && (notifications[0] || isAlone)) {
        String lzone2 = multiMegaZona
            ? '$w, зона(-ы): ${parceLineZones(valvesLine2, zones)}'
            : '';
        alarmsList.add(AlarmNoti(0, '$deviceName$w - Обнаружена протечка',
            'Линия 2: $w${linesNames[1]}$w$lzone2'));
      } else if (line3 && (notifications[0] || isAlone)) {
        String lzone3 = multiMegaZona
            ? '$w, зона(-ы): ${parceLineZones(valvesLine3, zones)}'
            : '';
        alarmsList.add(AlarmNoti(0, '$deviceName$w - Обнаружена протечка',
            'Линия 3: ${linesNames[2]}$w$lzone3'));
      } else if (line4 && (notifications[0] || isAlone)) {
        String lzone4 = multiMegaZona
            ? '$w, зона(-ы): ${parceLineZones(valvesLine4, zones)}'
            : '';
        alarmsList.add(AlarmNoti(0, '$deviceName$w - Обнаружена протечка',
            'Линия 4: ${linesNames[3]}$w$lzone4'));
      }

      // Parse radio sensors states
      int sensorsAmount = alarmedDevices[i].registersStates[6].value;
      for (int s = 7; s < sensorsAmount + 7; s++) {
        var oneRadioState = alarmedDevices[i].registersStates[s].value;
        var oneRadioParam = alarmedDevices[i].radioParams[s - 6].value;
        bool lost = oneRadioState.substring(29, 30) == '1';
        bool discharged = oneRadioState.substring(30, 31) == '1';
        bool alarma = oneRadioState.substring(31, 32) == '1';
        String name = alarmedDevices[i].sensorsNames[s - 7];
        String zonereg = oneRadioParam.substring(30, 32);
        String zone = zonereg == '01'
            ? zones[0]
            : zonereg == '10'
                ? zones[1]
                : '${zones[0]}, ${zones[1]}';

        if (alarma && (notifications[0] || isAlone) && !multiMegaZona) {
          alarmsList.add(AlarmNoti(0, '$deviceName$w - Обнаружена протечка',
              '$wРадиодатчик: $name'));
        } else if (alarma && (notifications[0] || isAlone) && multiMegaZona) {
          alarmsList.add(AlarmNoti(0, '$deviceName$w - Обнаружена протечка',
              'Радиодатчик: $w$name, $wзона(-ы): $zone'));
        } else if (discharged && (notifications[2] || isAlone)) {
          alarmsList.add(AlarmNoti(
              2,
              '$deviceName$w - Разряжена батарея в беспроводном датчике$w',
              name));
        } else if (lost && (notifications[1] || isAlone)) {
          alarmsList.add(AlarmNoti(1,
              '$deviceName$w - Потеря связи с беспроводным датчиком$w', name));
        }
      }

      // Parce counters overlimits and errors
      var thisdevice = allDevicesDb()[alarmedDevices[i].index];
      bool scanCParams =
          thisdevice.cswitch.where((sp) => sp == true).toList().length > 0;
      if (scanCParams) {
        bool counter = false;
        bool overlimit = false;
        for (int cp = 0; cp < alarmedDevices[i].countersNames.length; cp++) {
          bool cstate =
              alarmedDevices[i].countersParams[cp].value.substring(31, 32) ==
                  '1';
          counter =
              alarmedDevices[i].countersParams[cp].value.substring(28, 30) !=
                  '00';
          List cc = alarmedDevices[i].countersStates[cp].value;
          num litres = cc[0] << 16 | cc[1];
          double cvalue = litres / 1000;
          List<double> limits = climits.get(thisdevice.mac);
          overlimit = limits[cp] > 0 && cvalue > limits[cp];
          String name = alarmedDevices[i].countersNames[cp];
          if ((counter && cstate) && (notifications[4] || isAlone)) {
            alarmsList.add(AlarmNoti(5, '$deviceName$w - Ошибка счётчика',
                '$name$w - ${errParce(alarmedDevices[i].countersParams[cp].value.substring(28, 30))}'));
            counterErr = true;
          }
          if (overlimit && cstate) {
            alarmsList.add(AlarmNoti(
                6,
                '$deviceName$w - Достигнут лимит по счётчику$w $name',
                'Превышение на ${cvalue - limits[cp]}м³'));
            overlimited = true;
          }
        }
      }
    } else {
      offline = true;
      (notifications[3] || isAlone) && offline
          ? alarmsList.add(AlarmNoti(
              3,
              '${wsize ? 'Устройство' : ''} ${alarmedDevices[i].name}$w не в сети',
              alarmedDevices[i].registersStates[3]?.message))
          : null;
    }
  }

  if (((notifications[0] && (alarmTotal1 || alarmTotal2)) ||
          (notifications[1] && sensorIsLost) ||
          (notifications[2] && sensorIsDischarged) ||
          (notifications[3] && offline) ||
          (notifications[4] && counterErr) ||
          (overlimited)) ||
      isAlone) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext contextNoti) {
        if ((Platform.isWindows || Platform.isLinux || Platform.isMacOS) &&
            !stopPlayArlam) {
          // notification.show();
        }
        alarmsList.sort((a, b) => a.type.compareTo(b.type));
        const durdur = Duration(seconds: 5);
        if (!stopPlayArlam) {
          _timerSound?.cancel();
          _timerSound = Timer.periodic(durdur, (timer) async {
            playAlarm(durdur, null);
            if (stopPlayArlam) {
              timer.cancel();
            }
          });
        }
        alarmTotalCount++;
        return AlertDialog(
          alignment: Alignment.center,
          title: Row(children: [
            Icon(
                color: Theme.of(context).colorScheme.error,
                CupertinoIcons.exclamationmark_triangle_fill),
            BlinkText(
              '   $title',
              endColor: Theme.of(context).colorScheme.error,
              duration: const Duration(milliseconds: 100),
            ),
          ]),
          content: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    width: 3, color: Theme.of(context).colorScheme.error),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              width: 750,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: alarmsList.length,
                itemBuilder: (context, index) {
                  final item = alarmsList[index];

                  return ListTile(
                    minVerticalPadding: 5,
                    title: Row(children: [
                      item.type == 0
                          ? Icon(
                              color: Theme.of(context).colorScheme.secondary,
                              CupertinoIcons.drop_fill)
                          : item.type == 1
                              ? const Icon(
                                  color: Colors.orange,
                                  CupertinoIcons.antenna_radiowaves_left_right)
                              : item.type == 2
                                  ? const Icon(
                                      color: Colors.orange,
                                      CupertinoIcons.battery_empty)
                                  : item.type == 3
                                      ? Icon(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          CupertinoIcons.wifi_slash)
                                      : item.type == 5
                                          ? Icon(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              CupertinoIcons.gauge)
                                          : item.type == 6
                                              ? Icon(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  CupertinoIcons.drop_triangle)
                                              : Icon(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error,
                                                  CupertinoIcons
                                                      .exclamationmark_triangle_fill),
                      Text('  ${item.title}')
                    ]),
                    subtitle: Text(item.body),
                  );
                },
              )),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: () async {
                stopPlayArlam = true;
                await alertInApp.stop(playerId: 'alarm');
                await alertPlayer.stop();
                // LINUX ONLY
                // await shell.run('killall ffplay');
                closeThisAlert(false);
              },
              child: Text(
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  'Скрыть все'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: () async {
                stopPlayArlam = true;
                await alertInApp.stop(playerId: 'alarm');
                await alertPlayer.stop();
                // LINUX ONLY
                // await shell.run('killall ffplay');
                closeThisAlert(true);
              },
              child: Text(
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  'Скрыть'),
            ),
          ],
        );
      },
    );
  }
}
