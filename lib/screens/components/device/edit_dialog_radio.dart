part of '../../device.dart';

List obstructRadiosNames = [];

Future<void> _dialogBuilderRadio(context, editData, index, item, reg, formKey,
    updateItemDb, oneDeviceStates, updateNewRegister, getAdditionalParams) {
  bool wsize = MediaQuery.of(context).size.width > 800;
  String title = wsize ? 'Настройка радиодатчика' : 'Параметры датчика';

  // ignore: no_leading_underscores_for_local_identifiers
  StateSetter _setState;
  return showDialog<void>(
    context: context,
    builder: (BuildContext contextLines) {
      return AlertDialog(
        alignment: Alignment.bottomCenter,
        // backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        title: Row(children: [
          Icon(
              color: Theme.of(context).colorScheme.secondary,
              CupertinoIcons.radiowaves_right),
          Text('   $title')
        ]),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          _setState = setState;

          String triggerValve = reg.value.substring(30, 32);

          void stateReg(r, v) {
            _setState(() {
              reg = v;
            });
          }

          return SingleChildScrollView(
              child: SizedBox(
                  width: 400,
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
                              child: Column(children: [
                                editSensorName(editData, index),
                                editRadioZones(
                                    editData,
                                    triggerValve,
                                    context,
                                    reg.value,
                                    30,
                                    reg.adrr,
                                    updateNewRegister,
                                    stateReg,
                                    getAdditionalParams),
                              ])),
                        ],
                      ))));
        }),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Закрыть'),
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
              saveData(formKey, context, 0, updateItemDb);
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
