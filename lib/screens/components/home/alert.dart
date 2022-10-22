part of '../../home.dart';

Timer? _timerSound;

Future<void> _alertBuilderAlarm(
    context, alarmedDevices, closeThisAlert, bool isAlone) async {
  // 0 - alarm, 1 - lost sensor, 2 - sensor discharged, 3 - device offline
  List notifications = settings.get('notifications');

  String title = '!!! ОБНАРУЖЕНА ТРЕВОГА !!!';
  List alarmsList = [];
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
        String lzone1 = multiMegaZona ? parceLineZones(valvesLine1, zones) : '';
        alarmsList.add(AlarmNoti(0, '$deviceName - Обнаружена протечка',
            'Линия 1: ${linesNames[0]}, зона(-ы): $lzone1'));
      } else if (line2 && (notifications[0] || isAlone)) {
        String lzone2 = multiMegaZona ? parceLineZones(valvesLine2, zones) : '';
        alarmsList.add(AlarmNoti(0, '$deviceName - Обнаружена протечка',
            'Линия 2: ${linesNames[1]}, зона(-ы): $lzone2'));
      } else if (line3 && (notifications[0] || isAlone)) {
        String lzone3 = multiMegaZona ? parceLineZones(valvesLine3, zones) : '';
        alarmsList.add(AlarmNoti(0, '$deviceName - Обнаружена протечка',
            'Линия 3: ${linesNames[2]}, зона(-ы): $lzone3'));
      } else if (line4 && (notifications[0] || isAlone)) {
        String lzone4 = multiMegaZona ? parceLineZones(valvesLine4, zones) : '';
        alarmsList.add(AlarmNoti(0, '$deviceName - Обнаружена протечка',
            'Линия 4: ${linesNames[3]}, зона(-ы): $lzone4'));
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
          alarmsList.add(AlarmNoti(
              0, '$deviceName - Обнаружена протечка', 'Радиодатчик: $name'));
        } else if (alarma && (notifications[0] || isAlone) && multiMegaZona) {
          alarmsList.add(AlarmNoti(0, '$deviceName - Обнаружена протечка',
              'Радиодатчик: $name, зона(-ы): $zone'));
        } else if (discharged && (notifications[2] || isAlone)) {
          alarmsList.add(AlarmNoti(2,
              '$deviceName - Разряжена батарея в беспроводном датчике', name));
        } else if (lost && (notifications[1] || isAlone)) {
          alarmsList.add(AlarmNoti(
              1, '$deviceName - Потеря связи с беспроводным датчиком', name));
        }
      }
    } else {
      offline = true;
      (notifications[3] || isAlone) && offline
          ? alarmsList.add(AlarmNoti(
              3,
              'Устройство ${alarmedDevices[i].name} не в сети',
              alarmedDevices[i].registersStates[3]?.message))
          : null;
    }
  }

  if (((notifications[0] && (alarmTotal1 || alarmTotal2)) ||
          (notifications[1] && sensorIsLost) ||
          (notifications[2] && sensorIsDischarged) ||
          (notifications[3] && offline)) ||
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
                                  color: Colors.yellow,
                                  CupertinoIcons.antenna_radiowaves_left_right)
                              : item.type == 2
                                  ? const Icon(
                                      color: Colors.yellow,
                                      CupertinoIcons.battery_empty)
                                  : item.type == 3
                                      ? Icon(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          CupertinoIcons.wifi_slash)
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
                alarmTotalCount = 0;
                stopPlayArlam = true;
                await alertInApp.stop(playerId: 'alarm');
                closeThisAlert();
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
