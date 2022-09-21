part of '../../settings.dart';

String ip0 = '';
String id0 = '';
String mac0 = '';
List newDevice0 = [];

void writeDevice0(newDevice0, setCount) async {
  ip0 = '';
  id0 = '';
  mac0 = '';
  await DataBase.addNew(newDevice0);
  setCount();
  newDevice0 = [];
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

Future<void> _dialogBuilder(context, all, formKey, setCount) {
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
            child: Text(
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                'Добавить'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Успешно добавлено')),
                );
                int id00 = id0 == '' ? 240 : int.parse(id0);
                newDevice0.add(Scan(ip0, mac0, id00));
                writeDevice0(newDevice0, setCount);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
