part of './getters.dart';

List equalal00 = [];
List equalal11 = [];
bool trigAlarm = false;
bool backTrigd = false;

checkAlarms(ds) {
  if (ds.isNotEmpty) {
    if (equalal00.isEmpty || equalal11.isEmpty) {
      equalal00 = [];
      equalal11 = [];
      for (int k = 0; k < ds.length; k++) {
        equalal00.add(Equalal(
            ds[k].index, false, false, false, false, false, false, false));
        equalal11.add(Equalal(
            ds[k].index, false, false, false, false, false, false, false));
      }
    }
    equalal00.sort((a, b) => a.index.compareTo(b.index));
    equalal11.sort((a, b) => a.index.compareTo(b.index));
    for (int n = 0; n < ds.length; n++) {
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

        equalal11[eidx] = Equalal(eidx, ds[n].state, alarm1, alarm2,
            sensorIsLost, sensorIsDischarged, counter, overlimit);
      } else {
        equalal11[eidx] = Equalal(
            eidx,
            false,
            equalal00[eidx].alarm1,
            equalal00[eidx].alarm2,
            equalal00[eidx].sensorIsLost,
            equalal00[eidx].sensorIsDischarged,
            equalal00[eidx].counter,
            equalal00[eidx].overlimit);
      }
    }

    // Compare state to prevent loop and display the thruth
    // 0 - alarm, 1 - lost sensor, 2 - sensor discharged, 3 - device offline, 4 - counter error
    List notifications = settings.get('notifications');
    void trigThis(td, bool trig) {
      writeAlarmHistory(td);
      if (trig) trigAlarm = true;
    }

    if (equalal00.length == equalal11.length) {
      for (int eq = 0; eq < equalal00.length; eq++) {
        var trigDevice = ds[equalal00[eq].index];
        if ((equalal00[eq].alarm1 != equalal11[eq].alarm1) &&
            equalal11[eq].alarm1) {
          trigThis(trigDevice, notifications[0]);
        }
        if ((equalal00[eq].alarm2 != equalal11[eq].alarm2) &&
            equalal11[eq].alarm2) {
          trigThis(trigDevice, notifications[0]);
        }
        if ((equalal00[eq].sensorIsLost != equalal11[eq].sensorIsLost) &&
            equalal11[eq].sensorIsLost) {
          trigThis(trigDevice, notifications[1]);
        }
        if ((equalal00[eq].sensorIsDischarged !=
                equalal11[eq].sensorIsDischarged) &&
            equalal11[eq].sensorIsDischarged) {
          trigThis(trigDevice, notifications[2]);
        }
        if ((equalal00[eq].state != equalal11[eq].state) &&
            !equalal11[eq].state) {
          trigThis(trigDevice, notifications[3]);
        }
        if ((equalal00[eq].counter != equalal11[eq].counter) &&
            equalal11[eq].counter) {
          trigThis(trigDevice, notifications[4]);
        }
        if ((equalal00[eq].overlimit != equalal11[eq].overlimit) &&
            equalal11[eq].overlimit) {
          trigThis(trigDevice, true);
        }
      }
    }
    equalal00 = [...equalal11];
  }
  if (trigAlarm) {
    showErrPush(
        'Обнаружена тревога! Откройте приложение для просмотра подробностей');
    trigAlarm = false;
    backTrigd = true;
  }
}
