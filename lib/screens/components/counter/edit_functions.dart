part of '.././../counter.dart';

// ignore: prefer_typing_uninitialized_variables
var newDevice;
List linesNamesEdit = [];
List zonesNamesEdit = [];
List radiosNamesEdit = [];
List<double> limits = settings.get('countLimits');

// #############################################################################
// ---------------------------- Update database --------------------------------
// #############################################################################
Future updateDB(newDeviceWrite) async {
  await DataBase.updateDevice(newDeviceWrite);
}
// =============================================================================

// #############################################################################
// ------------------------------ Validators -----------------------------------
// #############################################################################
bool validValue(value) {
  bool res = false;
  double val = 666;
  int dotpos = value.indexOf('.', 0);
  int afterdot = dotpos > -1 ? value.substring(dotpos + 1).length : 0;
  if (RegExp(r'(?<=^| )\d+(\.\d+)?(?=$| )').hasMatch(value)) {
    if (value.isNotEmpty) {
      try {
        val = double.parse(value);
      } catch (e) {
        res = false;
      }
      if ((val >= 0 && val <= (6553565534 / 1000)) && afterdot <= 3) {
        res = true;
      } else {
        res = false;
      }
    } else {
      res = false;
    }
  }
  return res;
}

bool validID(value, all) {
  all = allDevicesDb();
  bool res = true;
  if (all.isNotEmpty) {
    for (int i = 0; i < all.length; i++) {
      if (value == all[i].mac) {
        return res = false;
      }
    }
  } else {
    return res = true;
  }
  return res;
}

bool validMC(value) {
  bool res = false;
  if (value.isNotEmpty) {
    res = RegExp(r'(?:[0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})').hasMatch(value);
  } else {
    res = false;
  }
  return res;
}
// =============================================================================

// #############################################################################
// ---------------------------- Save & update data -----------------------------
// #############################################################################
void saveData(formKey, context, type, updateItemDb, item, editData) async {
  try {
    if (formKey.currentState!.validate()) {
      if (type != 3) {
        await updateDB(newDevice);
        updateItemDb();
        if (devicesStates.length > newDevice.index) {
          devicesStates[newDevice.index].countersNames = newDevice.counters;
        }
      } else if (type == 3) {
        List<double> limits = [...climits.get(editData.mac)];
        double newLimit = double.parse(newDevice);
        limits[item.index] = newLimit;
        climits.put(editData.mac, limits);
        item.limit = newLimit;
        updateItemDb();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: CupertinoColors.systemGreen.withOpacity(0.8),
            content: const Text(
                'Данные успешно сохранены и будут обновлены на главном экране после завершения очередного цикла опроса')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: const Text(
                'Обновление параметров не выполнено, попробуйте снова')),
      );
      SystemSound.play(SystemSoundType.alert);
    }
    newDevice = [];
    Navigator.of(context).pop();
  } catch (err) {
    print;
  }
}

void playError(context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content:
            const Text('Обновление параметров не выполнено, попробуйте снова')),
  );
  SystemSound.play(SystemSoundType.alert);
}
// =============================================================================

DropdownButton stepper(
    context, item, itemDb, updateItemDb, updateoneDeviceCountersParams) {
  List<String> list = <String>['00000001', '00001010', '01100100'];
  String parceToTxt(v) {
    String res = 'Ошибка';
    switch (v) {
      case '00000001':
        res = '1';
        break;
      case '00001010':
        res = '10';
        break;
      case '01100100':
        res = '100';
        break;
      default:
        res = '0';
        break;
    }
    return res;
  }

  String dropdownValue = item.step.toString();
  return DropdownButton<String>(
    key: UniqueKey(),
    value: dropdownValue,
    icon: const Icon(CupertinoIcons.chevron_down),
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    hint: null,
    onChanged: (String? value) async {
      item.step = value!;
      var res = await sendOneRegister(
          item.reg, 16, value, 8, item.index + 123, itemDb);
      if (res[0]) {
        updateoneDeviceCountersParams(item.index, res[1]);
        item.step = value;
        updateItemDb();
      } else {
        playError(context);
      }
    },
    items: list.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        alignment: AlignmentDirectional.center,
        value: value,
        child: Text(style: bigValueStyle(context), parceToTxt(value)),
      );
    }).toList(),
  );
}
