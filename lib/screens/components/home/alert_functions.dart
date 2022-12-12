part of '../../home.dart';

bool stopPlayArlam = false;
int alarmTotalCount = 0;
bool equalAlarm = false;

LocalNotification notification = LocalNotification(
  title: "Внимание! Тревога!",
  body:
      "Обнаружена тревога! Перейдите в журнал приложения для просмотра подробностей",
);

AudioInApp alertInApp = AudioInApp();
AudioPlayer alertPlayer = AudioPlayer();

// Check where is an alarm and open dialog
checkAlarms(ds, context, setAlarmsArrState, a, al, closeThisAlert,
    setThisHistory, reorderMe) {
  if (ds.isNotEmpty && !reorderMe) {
    if (equalal0.isEmpty || equalal1.isEmpty) {
      equalal0 = [];
      equalal1 = [];
      for (int k = 0; k < ds.length; k++) {
        equalal0.add(Equalal(
            ds[k].index, false, false, false, false, false, false, false));
        equalal1.add(Equalal(
            ds[k].index, false, false, false, false, false, false, false));
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
        bool counter = false;
        bool overlimit = false;
        var thisdevice = allDevicesDb()[n];
        bool scanCParams =
            thisdevice.cswitch.where((sp) => sp == true).toList().length > 0;
        if (scanCParams) {
          for (int cp = 0; cp < ds[n].countersNames.length; cp++) {
            if (!counter) {
              counter =
                  ds[n].countersParams[cp].value.substring(28, 30) != '00';
            }
            List cc = ds[n].countersStates[cp].value;
            num litres = cc[0] << 16 | cc[1];
            double cvalue = litres / 1000;
            List<double> limits = climits.get(thisdevice.mac);
            if (!overlimit) {
              overlimit = limits[cp] > 0 && cvalue > limits[cp];
            }
          }
        }

        if ((alarm1 ||
                alarm2 ||
                sensorIsLost ||
                sensorIsDischarged ||
                counter ||
                overlimit) &&
            !isPersist) {
          a.add(eidx);
          stopPlayArlam = false;
        } else if ((!alarm1 &&
                !alarm2 &&
                !sensorIsLost &&
                !sensorIsDischarged &&
                !counter &&
                !overlimit) &&
            isPersist) {
          a.removeWhere((item) => item == eidx);
          alarmTotalCount--;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setAlarmsArrState(a, a.length);
          });
          stopPlayArlam = true;
        }
        equalal1[eidx] = Equalal(eidx, ds[n].state, alarm1, alarm2,
            sensorIsLost, sensorIsDischarged, counter, overlimit);
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
            equalal0[eidx].sensorIsDischarged,
            equalal0[eidx].counter,
            equalal0[eidx].overlimit);
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
        if ((equalal0[eq].counter != equalal1[eq].counter) &&
            equalal1[eq].counter) {
          trigThis(trigDevice);
        }
        if ((equalal0[eq].overlimit != equalal1[eq].overlimit) &&
            equalal1[eq].overlimit) {
          trigThis(trigDevice);
        }
      }
    }
    equalal0 = [...equalal1];
  }

  // int restrictionL = allDevicesDb().length + 5;
  // if ((equalAlarm) && (alarmTotalCount < restrictionL)) {
  if (((a.length != al) || equalAlarm) && !reorderMe) {
    bool checkCallback = true;
    stopPlayArlam = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _alertBuilderAlarm(context, ds, closeThisAlert, false);
      setAlarmsArrState(a, a.length);
      checkCallback = false;
      backTrigd = false;
    });
    if (checkCallback && !backTrigd) {
      if (Platform.isAndroid || Platform.isIOS) {
        showNotification("Внимание! Тревога!",
            "Обнаружена тревога! Перейдите в журнал приложение для просмотра подробностей");
      } else {
        notification.show();
      }
    }
    equalAlarm = false;
    backTrigd = false;
  }
}

// Play alarm sound
Future<void> playAlarm(durdur, type) async {
  if (Platform.isAndroid || Platform.isIOS) {
    if (!stopPlayArlam) {
      await alertPlayer.play(AssetSource('audios/02070.mp3'));
    } else {
      await alertPlayer.stop();
    }
  } else {
    await alertInApp.createNewAudioCache(
        playerId: 'alarm',
        route: 'audios/02070.mp3',
        audioInAppType: AudioInAppType.determined);
    await alertInApp.setVol('alarm', 1.1);
    if (!stopPlayArlam) {
      alertInApp.play(playerId: 'alarm');
    } else {
      await alertInApp.removeAudio('alarm');
    }
  }
  // LINUX ONLY
  // if (!stopPlayArlam) {
  //   await shell.run(
  //       'ffplay -nodisp -autoexit $appDataDirectory/Sounds/02070.mp3');
  // } else {
  //   await shell.run('killall ffplay');
  // }
}
