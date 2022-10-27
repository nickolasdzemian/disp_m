part of '../../home.dart';

bool stopPlayArlam = false;
int alarmTotalCount = 0;
List equalal0 = [];
List equalal1 = [];
bool equalAlarm = false;

LocalNotification notification = LocalNotification(
  title: "Внимание! Тревога!",
  body:
      "Обнаружена тревога! Перейдите в журнал приложения для просмотра подробностей",
);

AudioInApp alertInApp = AudioInApp();

// Check where is an alarm and open dialog
checkAlarms(
    ds, context, setAlarmsArrState, a, al, closeThisAlert, setThisHistory) {
  if (ds.isNotEmpty) {
    if (equalal0.isEmpty || equalal1.isEmpty) {
        equalal0 = [];
        equalal1 = [];
      for (int k = 0; k < ds.length; k++) {
        equalal0.add(Equalal(ds[k].index, false, false, false, false, false));
        equalal1.add(Equalal(ds[k].index, false, false, false, false, false));
      }
    }
    equalal0.sort((a, b) => a.index.compareTo(b.index));
    equalal1.sort((a, b) => a.index.compareTo(b.index));
    for (int n = 0; n < ds.length; n++) {
      bool isPersist = a.contains(ds[n].index);
      int eidx = ds[n].index;
      if (ds[n].state) {
        String reg0 = ds[n].registersStates[0].value;
        bool alarm1 = reg0.substring(29, 30) == '1';
        bool alarm2 = reg0.substring(30, 31) == '1';
        bool sensorIsLost = reg0.substring(27, 28) == '1';
        bool sensorIsDischarged = reg0.substring(28, 29) == '1';

        if ((alarm1 || alarm2 || sensorIsLost || sensorIsDischarged) &&
            !isPersist) {
          a.add(eidx);
          stopPlayArlam = false;
        } else if ((!alarm1 &&
                !alarm2 &&
                !sensorIsLost &&
                !sensorIsDischarged) &&
            isPersist) {
          a.removeWhere((item) => item == eidx);
          alarmTotalCount--;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setAlarmsArrState(a, a.length);
          });
          stopPlayArlam = true;
        }
        equalal1[eidx] = Equalal(eidx, ds[n].state, alarm1, alarm2,
            sensorIsLost, sensorIsDischarged);
      } else {
        if (!isPersist) {
          a.add(eidx);
        }
        equalal1[eidx] = Equalal(
            eidx,
            false,
            equalal0[eidx].alarm1,
            equalal0[eidx].alarm2,
            equalal0[eidx].sensorIsLost,
            equalal0[eidx].sensorIsDischarged);
      }
    }
    // Compare state to prevent loop and display the thruth
    void trigThis(td) {
      writeAlarmHistory(td);
      equalAlarm = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setThisHistory();
      });
    }

    if (equalal0.length == equalal1.length) {
      for (int eq = 0; eq < equalal0.length; eq++) {
        var trigDevice = ds[equalal0[eq].index];
        if ((equalal0[eq].alarm1 != equalal1[eq].alarm1) &&
            equalal1[eq].alarm1) {
          trigThis(trigDevice);
        }
        if ((equalal0[eq].alarm2 != equalal1[eq].alarm2) &&
            equalal1[eq].alarm2) {
          trigThis(trigDevice);
        }
        if ((equalal0[eq].sensorIsLost != equalal1[eq].sensorIsLost) &&
            equalal1[eq].sensorIsLost) {
          trigThis(trigDevice);
        }
        if ((equalal0[eq].sensorIsDischarged !=
                equalal1[eq].sensorIsDischarged) &&
            equalal1[eq].sensorIsDischarged) {
          trigThis(trigDevice);
        }
        if ((equalal0[eq].state != equalal1[eq].state) && !equalal1[eq].state) {
          trigThis(trigDevice);
        }
      }
    }
    equalal0 = [...equalal1];
  }

  int restrictionL = allDevicesDb().length + 5;
  // if ((equalAlarm) && (alarmTotalCount < restrictionL)) {
  if ((a.length != al) || equalAlarm) {
    bool checkCallback = true;
    stopPlayArlam = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _alertBuilderAlarm(context, ds, closeThisAlert, false);
      setAlarmsArrState(a, a.length);
      checkCallback = false;
    });
    if (checkCallback) {
      notification.show();
    }
    equalAlarm = false;
  }
}

// Play alarm sound
Future<void> playAlarm(durdur, type) async {
  await alertInApp.createNewAudioCache(
      playerId: 'alarm',
      route: 'audios/02070.mp3',
      audioInAppType: AudioInAppType.determined);
  await alertInApp.setVol('alarm', 1.1);
  if (!stopPlayArlam) {
    await alertInApp.play(playerId: 'alarm');
  } else {
    await alertInApp.removeAudio('alarm');
  }
}

String parceLineZones(v, z) {
  String res = '';
  switch (v) {
    case '01':
      res = z[0];
      break;
    case '10':
      res = z[1];
      break;
    case '11':
      res = '${z[0]}, ${z[1]}';
      break;
  }
  return res;
}

void writeAlarmHistory(ad) {
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
  if (ad.state) {
    String reg0 = ad.registersStates[0].value;
    alarmTotal1 = reg0.substring(29, 30) == '1';
    alarmTotal2 = reg0.substring(30, 31) == '1';
    multiMegaZona = reg0.substring(21, 22) == '1';
    sensorIsLost = reg0.substring(27, 28) == '1';
    sensorIsDischarged = reg0.substring(28, 29) == '1';
    String reg3 = ad.registersStates[3].value;
    line1 = reg3.substring(31, 32) == '1';
    line2 = reg3.substring(30, 31) == '1';
    line3 = reg3.substring(29, 30) == '1';
    line4 = reg3.substring(28, 29) == '1';
    String reg1 = ad.registersStates[1].value;
    String reg2 = ad.registersStates[2].value;
    String valvesLine1 = reg1.substring(23, 25);
    String valvesLine2 = reg1.substring(30, 32);
    String valvesLine3 = reg2.substring(23, 25);
    String valvesLine4 = reg2.substring(30, 32);
    List linesNames = ad.linesNames;
    List zones = ad.zones;
    if (line1) {
      String lzone1 = multiMegaZona ? parceLineZones(valvesLine1, zones) : '';
      alarmsList.add(AlarmNoti(0, '',
          'Обнаружена протечка - Линия 1: ${linesNames[0]}, Зона(-ы): $lzone1'));
    } else if (line2) {
      String lzone2 = multiMegaZona ? parceLineZones(valvesLine2, zones) : '';
      alarmsList.add(AlarmNoti(0, '',
          'Обнаружена протечка - Линия 2: ${linesNames[1]}, Зона(-ы): $lzone2'));
    } else if (line3) {
      String lzone3 = multiMegaZona ? parceLineZones(valvesLine3, zones) : '';
      alarmsList.add(AlarmNoti(0, '',
          'Обнаружена протечка - Линия 3: ${linesNames[2]}, Зона(-ы): $lzone3'));
    } else if (line4) {
      String lzone4 = multiMegaZona ? parceLineZones(valvesLine4, zones) : '';
      alarmsList.add(AlarmNoti(0, '',
          'Обнаружена протечка - Линия 4: ${linesNames[3]}, Зона(-ы): $lzone4'));
    }

    // Parse radio sensors states
    int sensorsAmount = ad.registersStates[6].value;
    for (int s = 7; s < sensorsAmount + 7; s++) {
      var oneRadioState = ad.registersStates[s].value;
      var oneRadioParam = ad.radioParams[s - 6].value;
      bool lost = oneRadioState.substring(29, 30) == '1';
      bool discharged = oneRadioState.substring(30, 31) == '1';
      bool alarma = oneRadioState.substring(31, 32) == '1';
      String name = ad.sensorsNames[s - 7];
      String zonereg = oneRadioParam.substring(30, 32);
      String zone = zonereg == '01'
          ? zones[0]
          : zonereg == '10'
              ? zones[1]
              : '${zones[0]}, ${zones[1]}';

      if (alarma && !multiMegaZona) {
        alarmsList
            .add(AlarmNoti(0, '', 'Обнаружена протечка - Радиодатчик: $name'));
      } else if (alarma && multiMegaZona) {
        alarmsList.add(AlarmNoti(0, '',
            'Обнаружена протечка - Радиодатчик: $name, Зона(-ы): $zone'));
      } else if (discharged) {
        alarmsList.add(
            AlarmNoti(2, '', 'Разряжена батарея в беспроводном датчике $name'));
      } else if (lost) {
        alarmsList.add(
            AlarmNoti(1, '', 'Потеря связи с беспроводным датчиком $name'));
      }
    }
  }

  if (alarmsList.isNotEmpty) {
    for (int p = 0; p < alarmsList.length; p++) {
      var onlyData = alarmsList[p];
      DataBase.updateEventList([
        onlyData.type,
        ad.name,
        onlyData.body,
      ]);
    }
  }
}
