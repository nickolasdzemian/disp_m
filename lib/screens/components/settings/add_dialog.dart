part of '../../settings.dart';

String ip0 = '';
String id0 = '';
String mac0 = '';
List newDevice0 = [];

Future writeDevice0(newDevice0, setCount) async {
  ip0 = '';
  id0 = '';
  mac0 = '';
  await DataBase.addNew(newDevice0);
  setCount();
}

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

bool blockAddNewBtn = false;

void addSomeNewManually(formKey, context, setCount, stopTimer) async {
  blockAddNewBtn = true;
  int id00 = id0 == '' ? 240 : int.parse(id0);
  bool scanBoolResult = await Scan.checkerOneOf(Scan(ip0, mac0, id00));
  try {
    if (formKey.currentState!.validate() && scanBoolResult) {
      // if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: CupertinoColors.systemGreen.withOpacity(0.6),
            content: const Text('Успешно добавлено')),
      );
      stopTimer();
      newDevice0.add(Scan(ip0, mac0, id00));
      await writeDevice0(newDevice0, setCount);
      blockAddNewBtn = false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: const Text(
                'Проверка устройства не пройдена, устройство не добавлено')),
      );
      SystemSound.play(SystemSoundType.alert);
      blockAddNewBtn = false;
    }
    newDevice0 = [];
    Navigator.of(context).pop();
  } catch (err) {
    print;
  }
}

Future<void> _dialogBuilder(context, all, formKey, setCount, stopTimer) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext contextAdd) {
      return AlertDialog(
        alignment: Alignment.topLeft,
        title: Row(children: [
          Icon(
              color: Theme.of(context).colorScheme.secondary,
              CupertinoIcons.hand_draw),
          const Text('   Добавление устройства')
        ]),
        content: SizedBox(
            width: 350,
            child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'IP-адрес устройства',
                        ),
                        onChanged: (value) => ip0 = value,
                        validator: (String? value) {
                          return (value != null &&
                                  RegExp(r'^((25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])(\.(?!$)|$)){4}$')
                                      .hasMatch(value))
                              ? null
                              : 'Поле должно быть IP-адресом!';
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'UnitID устройства (по умолчанию 240)',
                        ),
                        onChanged: (value) => id0 = value,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (String? value) {
                          return (value != null && validUID(value))
                              ? null
                              : 'Допустимый диапазон значений 0 - 247 ';
                        },
                        initialValue: '240',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Mac-адрес устройства',
                        ),
                        onChanged: (value) => mac0 = value,
                        validator: (String? value) {
                          return !validMC(value)
                              ? 'Mac-адрес по стандарту IEEE 802'
                              : !validID(value, all)
                                  ? 'Значение уже присутствует!'
                                  : null;
                        },
                      ),
                    ),
                  ],
                ))),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Отмена'),
            onPressed: () {
              ip0 = '';
              id0 = '';
              mac0 = '';
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: !blockAddNewBtn
                ? () {
                    addSomeNewManually(formKey, context, setCount, stopTimer);
                  }
                : null,
            child: Text(
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                'Добавить'),
          ),
        ],
      );
    },
  );
}
