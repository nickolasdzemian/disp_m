part of '.././../device.dart';

// ignore: prefer_typing_uninitialized_variables
var newDevice;
List linesNamesEdit = [];
List zonesNamesEdit = [];
List radiosNamesEdit = [];

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
bool validUID(value) {
  bool res = false;
  int val = 666;
  if (value.isNotEmpty) {
    try {
      val = int.parse(value);
    } catch (e) {
      // print(e.toString());
    }
    if (val >= 0 && val <= 247) {
      res = true;
    } else {
      res = false;
    }
  } else {
    res = false;
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
void saveData(formKey, context, type, updateItemDb) async {
  try {
    if (formKey.currentState!.validate()) {
      if (type < 5) {
        await updateDB(newDevice);
        updateItemDb();
      }
      if (devicesStates.length > newDevice.index) {
        devicesStates[newDevice.index].name = newDevice.name;
        devicesStates[newDevice.index].linesNames = newDevice.lines;
        devicesStates[newDevice.index].zones = newDevice.zones;
        devicesStates[newDevice.index].sensorsNames = newDevice.sensors;
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
    linesNamesEdit = [];
    obstructLinesNames = [];
    zonesNamesEdit = [];
    obstructZonesNames = [];
    radiosNamesEdit = [];
    obstructRadiosNames = [];
    Navigator.of(context).pop();
  } catch (err) {
    print;
  }
}
// =============================================================================

// void updateNewRegister(ind, res, context, updateOneDeviceStates) {
//   if (res[0]) {
//     updateOneDeviceStates(ind, res[1]);
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//           backgroundColor: Theme.of(context).colorScheme.error,
//           content: const Text('Произошла ошибка, попробуйте снова')),
//     );
//   }
// }

// #############################################################################
// ------------------------------ UNIT ID UPDATE -------------------------------
// #############################################################################
Future<void> changeUnitId(
    context, reg5, int value, editData, updateItemDb) async {
  String strvalue = value.toRadixString(2);
  var res = await sendOneRegister(reg5, 16, strvalue, 8, 5, editData);
  if (res[0]) {
    await updateDB(newDevice);
    updateItemDb();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 10),
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
              'Внимание! Выполнено обновление UnitID устройства!\nНе забудьте проверить, что данное значение ($value) корректно отображается в меню настроек устройства!\nУстройство появится в сети после завершения текущего цикла опроса, ожидайте')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: const Text(
              'Обновление UnitID не выполнено или завершилось с ошибкой')),
    );
  }
  SystemSound.play(SystemSoundType.alert);
  Navigator.of(context).pop();
}
// =============================================================================

// #############################################################################
// -------------------------------- ZONE RENAME --------------------------------
// #############################################################################
/// Edit zone name
SizedBox editZoneName(editData, int number) {
  zonesNamesEdit = editData.zones;
  // -----------------------------------------
  //         For testing purposes only
  // if (zonesNamesEdit.length < 2) {
  //   zonesNamesEdit = ['Зона I', 'Зона II'];
  // }
  // -----------------------------------------
  obstructZonesNames = [zonesNamesEdit[0], zonesNamesEdit[1]];
  return SizedBox(
      width: 500,
      height: 80,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: 'Наименование зоны/группы ${number + 1}',
        ),
        onChanged: (value) => {
          obstructZonesNames[number] = value,
          newDevice = Device(
              editData.index,
              editData.ip,
              editData.mac,
              editData.id,
              editData.name,
              editData.lines,
              editData.sensors,
              obstructZonesNames,
              editData.counters,
              editData.cswitch)
        },
        validator: (String? value) {
          return (value != null && value.length < 22)
              ? null
              : 'Максимальная длина имени - 22 символа ';
        },
        initialValue: editData.zones[number], // FOR RELEASE
        // initialValue: zonesNamesEdit[number], // FOR TESTS
      ));
}
// =============================================================================

// #############################################################################
// ------------------------------ LINES FUNCTIONS ------------------------------
// #############################################################################

/// Margin only =)
SizedBox marginVertical() {
  return const SizedBox(
    height: 8,
  );
}

// -----------------------------------------------------------------------------

/// Edit line name
SizedBox editLineName(editData, int number) {
  linesNamesEdit = editData.lines;
  obstructLinesNames = [
    linesNamesEdit[0],
    linesNamesEdit[1],
    linesNamesEdit[2],
    linesNamesEdit[3]
  ];
  return SizedBox(
      width: 275,
      height: 80,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: 'Наименование линии ${number + 1}',
        ),
        onChanged: (value) => {
          obstructLinesNames[number] = value,
          newDevice = Device(
              editData.index,
              editData.ip,
              editData.mac,
              editData.id,
              editData.name,
              obstructLinesNames,
              editData.sensors,
              editData.zones,
              editData.counters,
              editData.cswitch)
        },
        validator: (String? value) {
          return (value != null && value.length < 30)
              ? null
              : 'Максимальная длина имени - 30 символов ';
        },
        initialValue: editData.lines[number],
      ));
}

// -----------------------------------------------------------------------------

/// Set line as button instead of wired sensor
SizedBox editLineButton(editData, bool isButton, context, reg, regIdx, addr,
    updateNewRegister, stateReg) {
  return SizedBox(
      width: 275,
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(
                color: Theme.of(context).colorScheme.secondary,
                CupertinoIcons.command),
            Text(style: subTitleStyle(context), '  Режим кнопки'),
          ]),
          Transform.scale(
              scale: 0.75,
              child: CupertinoSwitch(
                value: isButton,
                thumbColor: CupertinoColors.white,
                trackColor: CupertinoColors.inactiveGray.withOpacity(0.4),
                activeColor: CupertinoColors.systemGreen.withOpacity(0.6),
                onChanged: (bool? value) async {
                  var res = await sendOneRegister(
                      reg, regIdx, isButton ? '00' : '01', 2, addr, editData);
                  if (res[0]) {
                    updateNewRegister(addr, res);
                    stateReg(addr, res[1].value);
                  }
                },
              )),
        ],
      ));
}

// -----------------------------------------------------------------------------

/// Select zone to be controled by line
SizedBox editLineZones(editData, valvesLine, context, reg, regIdx, addr,
    updateNewRegister, stateReg) {
  List<String> list = <String>['01', '10', '11'];
  String parceToTxt(v) {
    String res = 'Ошибка';
    switch (v) {
      case '01':
        res = 'I группы';
        break;
      case '10':
        res = 'II группы';
        break;
      case '11':
        res = 'I и II группы ';
        break;
    }
    return res;
  }

  String dropdownValue = valvesLine;
  return SizedBox(
      width: 275,
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(
                color: Theme.of(context).colorScheme.secondary,
                CupertinoIcons.increase_indent),
            Text(style: subTitleStyle(context), '  Контроль:'),
          ]),
          DropdownButton<String>(
            key: UniqueKey(),
            value: dropdownValue,
            // icon: const Icon(CupertinoIcons.chevron_down),
            elevation: 16,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            hint: Container(
              height: 1.5,
              margin: const EdgeInsets.only(top: 10),
              color: Theme.of(context).colorScheme.primary,
            ),
            onChanged: (String? value) async {
              valvesLine = value!;
              var res =
                  await sendOneRegister(reg, regIdx, value, 2, addr, editData);
              if (res[0]) {
                updateNewRegister(addr, res);
                stateReg(addr, res[1].value);
              }
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                alignment: AlignmentDirectional.center,
                value: value,
                child:
                    Text(style: subTitleValueStyle(context), parceToTxt(value)),
              );
            }).toList(),
          ),
        ],
      ));
}
// =============================================================================

// #############################################################################
// ------------------------------ RELAY FUNCTIONS ------------------------------
// #############################################################################
/// Relay config
// with test busy indicator in icon place
SizedBox editRelayConfig(editData, triggerValve, alarmValve, context, reg,
    updateNewRegister, stateReg, busy, setBusy, bool big) {
  List<String> list = <String>['00', '01', '10', '11'];
  String parceToTxt(v) {
    String res = 'Ошибка';
    switch (v) {
      case '00':
        res = 'выключено';
        break;
      case '01':
        res = 'I группа';
        break;
      case '10':
        res = 'II группа';
        break;
      case '11':
        res = 'I и II группа ';
        break;
    }
    return res;
  }

  String dropdownValue1 = triggerValve;
  String dropdownValue2 = alarmValve;
  return SizedBox(
      width: 400,
      height: 120,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              !busy
                  ? Icon(
                      color: Theme.of(context).colorScheme.secondary,
                      CupertinoIcons.lock)
                  : SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: Theme.of(context).colorScheme.secondary)),
              Text(
                  style: subTitleStyle(context),
                  '  ${big ? 'При закрытии кранов:' : 'При закрытии\n  кранов:'}'),
            ]),
            DropdownButton<String>(
              key: UniqueKey(),
              value: dropdownValue1,
              icon: const Icon(CupertinoIcons.chevron_down),
              elevation: 16,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              hint: Container(
                height: 1.5,
                margin: const EdgeInsets.only(top: 10),
                color: Theme.of(context).colorScheme.primary,
              ),
              onChanged: (String? value) async {
                setBusy(true);
                triggerValve = value!;
                var res = await sendOneRegister(reg, 28, value, 2, 4, editData);
                if (res[0]) {
                  updateNewRegister(4, res);
                  stateReg(4, res[1].value);
                }
                setBusy(false);
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  alignment: AlignmentDirectional.center,
                  value: value,
                  child: Text(
                      style: subTitleValueStyle(context), parceToTxt(value)),
                );
              }).toList(),
            ),
          ],
        ),
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        marginVertical(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              !busy
                  ? Icon(
                      color: Theme.of(context).colorScheme.secondary,
                      CupertinoIcons.bell)
                  : SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: Theme.of(context).colorScheme.secondary)),
              Text(style: subTitleStyle(context), '  При тревоге:'),
            ]),
            DropdownButton<String>(
              key: UniqueKey(),
              value: dropdownValue2,
              icon: const Icon(CupertinoIcons.chevron_down),
              elevation: 16,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              hint: Container(
                height: 1.5,
                margin: const EdgeInsets.only(top: 10),
                color: Theme.of(context).colorScheme.primary,
              ),
              onChanged: (String? value) async {
                setBusy(true);
                dropdownValue2 = value!;
                var res = await sendOneRegister(reg, 30, value, 2, 4, editData);
                if (res[0]) {
                  updateNewRegister(4, res);
                  stateReg(4, res[1].value);
                }
                setBusy(false);
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  alignment: AlignmentDirectional.center,
                  value: value,
                  child: Text(
                      style: subTitleValueStyle(context), parceToTxt(value)),
                );
              }).toList(),
            ),
          ],
        ),
      ]));
}
// =============================================================================

// #############################################################################
// --------------------------------- COUNTERS ----------------------------------
// #############################################################################
/// Select counter to be displayed
Column editCounterVisibility(context, cswitch, stateCswitch, i) {
  num snum = 0;
  switch (i) {
    case 0:
      snum = 1;
      break;
    case 2:
      snum = 2;
      break;
    case 4:
      snum = 3;
      break;
    case 6:
      snum = 4;
      break;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(style: titleStyle(context), 'Слот $snum'),
      marginVertical(),
      SizedBox(
        width: 200,
        height: 35,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Icon(
                color: Theme.of(context).colorScheme.secondary,
                CupertinoIcons.drop),
            Text(style: subTitleStyle(context), '  Счетчик 1:'),
          ]),
          Transform.scale(
            scale: 0.75,
            child: CupertinoSwitch(
              value: cswitch[i],
              thumbColor: CupertinoColors.white,
              trackColor: CupertinoColors.inactiveGray.withOpacity(0.4),
              activeColor: CupertinoColors.systemGreen.withOpacity(0.6),
              onChanged: (bool? value) {
                stateCswitch(i, !cswitch[i]);
              },
            ),
          )
        ]),
      ),
      SizedBox(
        width: 200,
        height: 35,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Icon(
                color: Theme.of(context).colorScheme.secondary,
                CupertinoIcons.drop),
            Text(style: subTitleStyle(context), '  Счетчик 2:'),
          ]),
          Transform.scale(
            scale: 0.75,
            child: CupertinoSwitch(
              value: cswitch[i + 1],
              thumbColor: CupertinoColors.white,
              trackColor: CupertinoColors.inactiveGray.withOpacity(0.4),
              activeColor: CupertinoColors.systemGreen.withOpacity(0.6),
              onChanged: (bool? value) {
                stateCswitch(i + 1, !cswitch[i + 1]);
              },
            ),
          )
        ]),
      )
    ],
  );
}
// =============================================================================

// #############################################################################
// ------------------------------- RADIO SENSOR --------------------------------
// #############################################################################
/// Select zone to be controled by sensor
SizedBox editRadioZones(editData, valvesLine, context, reg, regIdx, addr,
    updateNewRegister, stateReg, getAdditionalParams) {
  List<String> list = <String>['01', '10', '11'];
  String parceToTxt(v) {
    String res = 'Ошибка';
    switch (v) {
      case '01':
        res = 'I группы';
        break;
      case '10':
        res = 'II группы';
        break;
      case '11':
        res = 'I и II группы ';
        break;
    }
    return res;
  }

  String dropdownValue = valvesLine;
  return SizedBox(
      width: 500,
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(
                color: Theme.of(context).colorScheme.secondary,
                CupertinoIcons.increase_indent),
            Text(style: subTitleStyle(context), '  Контроль:'),
          ]),
          DropdownButton<String>(
            key: UniqueKey(),
            value: dropdownValue,
            // icon: const Icon(CupertinoIcons.chevron_down),
            elevation: 16,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            hint: Container(
              height: 1.5,
              margin: const EdgeInsets.only(top: 10),
              color: Theme.of(context).colorScheme.primary,
            ),
            onChanged: (String? value) async {
              valvesLine = value!;
              var res =
                  await sendOneRegister(reg, regIdx, value, 2, addr, editData);
              if (res[0]) {
                updateNewRegister(addr, res);
                stateReg(addr, res[1]);
                getAdditionalParams(
                    false); // UPDATE DIALOG BUILDER AND FATHER STATE
              }
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                alignment: AlignmentDirectional.center,
                value: value,
                child:
                    Text(style: subTitleValueStyle(context), parceToTxt(value)),
              );
            }).toList(),
          ),
        ],
      ));
}

// -----------------------------------------------------------------------------

/// Edit sensor name
SizedBox editSensorName(editData, int number) {
  radiosNamesEdit = [...editData.sensors];
  return SizedBox(
      width: 500,
      height: 80,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: 'Наименование датчика ${number + 1}',
        ),
        onChanged: (value) => {
          radiosNamesEdit[number] = value,
          newDevice = Device(
              editData.index,
              editData.ip,
              editData.mac,
              editData.id,
              editData.name,
              editData.lines,
              radiosNamesEdit,
              editData.zones,
              editData.counters,
              editData.cswitch)
        },
        validator: (String? value) {
          return (value != null && value.length < 30)
              ? null
              : 'Максимальная длина имени - 30 символа ';
        },
        initialValue: editData.sensors[number],
      ));
}
// =============================================================================
