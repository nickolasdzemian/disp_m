part of '../../counter.dart';

Future<void> _dialogBuilder(context, item, editData, formKey, type,
    updateItemDb, updateoneDeviceCounters, updateoneDeviceCountersParams) {
  String title = 'Редактирование';
  switch (type) {
    case 0:
      title = 'Изменение имени';
      break;
    case 2:
      title = 'Новое значение';
      break;
    case 3:
      title = 'Установка лимита';
      break;
  }

  String tempuid = 'NC';
  List obstructc = [...editData.counters];
  return showDialog<void>(
    context: context,
    builder: (BuildContext contextBase) {
      return AlertDialog(
        alignment: Alignment.center,
        title: Row(children: [
          Icon(
              color: Theme.of(context).colorScheme.secondary,
              CupertinoIcons.text_cursor),
          Text('   $title')
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
                      child: type == 0
                          // ==================== EDIT NAME ====================
                          ? TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Имя счетчика',
                              ),
                              onChanged: (value) => {
                                obstructc[item.index] = value,
                                newDevice = Device(
                                    editData.index,
                                    editData.ip,
                                    editData.mac,
                                    editData.id,
                                    editData.name,
                                    editData.lines,
                                    editData.sensors,
                                    editData.zones,
                                    obstructc,
                                    editData.cswitch)
                              },
                              initialValue: editData.counters[item.index],
                              validator: (String? value) {
                                return (value != null && value.length < 32)
                                    ? null
                                    : 'Максимальная длина имени - 32 символа';
                              },
                            )
                          // ---------------------------------------------------
                          : type == 2
                              // ============== EDIT VALUE =================
                              ? TextFormField(
                                  keyboardType: TextInputType.number,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Текущие показания, м³',
                                  ),
                                  onChanged: (value) => {
                                    tempuid = value,
                                  },
                                  initialValue: item.value.toString(),
                                  validator: (String? value) {
                                    return (value != null && validValue(value))
                                        ? null
                                        : 'Допустимый диапазон значений 0 - ${6553565534 / 1000}\nдлина значения после точки не должна превышать 3';
                                  },
                                )
                              : type == 3
                                  // ============== EDIT LIMIT =================
                                  ? TextFormField(
                                      keyboardType: TextInputType.number,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: 'Лимит, м³',
                                      ),
                                      onChanged: (value) => {
                                        newDevice = value,
                                      },
                                      initialValue: item.limit.toString(),
                                      validator: (String? value) {
                                        return (value != null &&
                                                validValue(value))
                                            ? null
                                            : 'Допустимый диапазон значений 0 - ${6553565534 / 1000}\nдлина значения после точки не должна превышать 3';
                                      },
                                    )
                                  : null,
                      // -------------------------------------------------------
                    ),
                  ],
                ))),
        actions: <Widget>[
          type == 2
              ? TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  onPressed: () async {
                    if (tempuid != 'NC') {
                      double v = double.parse(tempuid);
                      int adrr = item.index + 107;
                      var res = await sendCounterValue(v, adrr, editData);
                      if (res[0]) {
                        item.value = v;
                        updateoneDeviceCounters(item.index, res[1]);
                        updateItemDb();
                      } else {
                        playError(context);
                      }
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                      'Применить на устройство'),
                )
              : const SizedBox(),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Отмена'),
            onPressed: () {
              newDevice = [];
              Navigator.of(context).pop();
            },
          ),
          type != 2
              ? TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  onPressed: () {
                    saveData(
                        formKey, context, type, updateItemDb, item, editData);
                  },
                  child: Text(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      'Сохранить'),
                )
              : const SizedBox(),
        ],
      );
    },
  );
}
