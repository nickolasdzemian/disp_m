part of '../../device.dart';

List obstructZonesNames = [];

Future<void> _dialogBuilder(
    context, editData, formKey, type, updateItemDb, state) {
  String title = 'Редактирование';
  switch (type) {
    case 0:
      title = 'Изменение имени';
      break;
    case 1:
      title = 'Изменение IP-адреса';
      break;
    case 2:
      title = 'Изменение UnitID';
      break;
    case 3:
      title = 'Переименование линий';
      break;
    case 4:
      title = 'Переименование зон';
      break;
  }

  String tempuid = 'NC';
  return showDialog<void>(
    context: context,
    builder: (BuildContext contextBase) {
      return AlertDialog(
        alignment: Alignment.topCenter,
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
                                labelText: 'Имя устройства',
                              ),
                              onChanged: (value) => newDevice = Device(
                                  editData.index,
                                  editData.ip,
                                  editData.mac,
                                  editData.id,
                                  value,
                                  editData.lines,
                                  editData.sensors,
                                  editData.zones),
                              initialValue: editData.name,
                              validator: (String? value) {
                                return (value != null && value.length < 22)
                                    ? null
                                    : 'Максимальная длина имени - 22 символа';
                              },
                            )
                          // ---------------------------------------------------
                          : type == 1
                              // ================= EDIT IP =====================
                              ? TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'IP-адрес устройства',
                                  ),
                                  onChanged: (value) => newDevice = Device(
                                      editData.index,
                                      value,
                                      editData.mac,
                                      editData.id,
                                      editData.name,
                                      editData.lines,
                                      editData.sensors,
                                      editData.zones),
                                  initialValue: editData.ip,
                                  validator: (String? value) {
                                    return (value != null &&
                                            RegExp(r'^((25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])(\.(?!$)|$)){4}$')
                                                .hasMatch(value))
                                        ? null
                                        : 'Поле должно быть IP-адресом!';
                                  },
                                )
                              // -----------------------------------------------
                              : type == 2
                                  // ================ EDIT ID ==================
                                  ? TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText:
                                            'UnitID устройства (по умолчанию 240)',
                                      ),
                                      onChanged: (value) => {
                                        newDevice = Device(
                                            editData.index,
                                            editData.ip,
                                            editData.mac,
                                            value == ''
                                                ? 240
                                                : int.parse(value),
                                            editData.name,
                                            editData.lines,
                                            editData.sensors,
                                            editData.zones),
                                        tempuid = value,
                                      },
                                      initialValue: editData.id.toString(),
                                      validator: (String? value) {
                                        return (value != null &&
                                                validUID(value))
                                            ? null
                                            : 'Допустимый диапазон значений 0 - 247 ';
                                      },
                                    )
                                  // -------------------------------------------
                                  : type == 4
                                      // ============== EDIT ZONES =============
                                      ? Column(
                                          children: [
                                            editZoneName(editData, 0),
                                            editZoneName(editData, 1),
                                          ],
                                        )
                                      : null,
                      // -------------------------------------------------------
                    ),
                  ],
                ))),
        actions: <Widget>[
          type == 2 && state
              ? TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  onPressed: () {
                    String reg5 =
                        '00000000000000001111000000000011'; // This is default value for register 5
                    tempuid != 'NC' &&
                            newDevice != [] &&
                            newDevice != null &&
                            newDevice?.id != editData?.id &&
                            newDevice?.id >= 0 &&
                            newDevice?.id <= 247
                        ? changeUnitId(
                            context, reg5, newDevice.id, editData, updateItemDb)
                        : null;
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
              linesNamesEdit = [];
              obstructLinesNames = [];
              zonesNamesEdit = [];
              obstructZonesNames = [];
              radiosNamesEdit = [];
              obstructRadiosNames = [];
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () {
              saveData(formKey, context, type, updateItemDb);
            },
            child: Text(
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                'Сохранить'),
          ),
        ],
      );
    },
  );
}
