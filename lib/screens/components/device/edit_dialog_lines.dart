part of '../../device.dart';

List obstructLinesNames = [];

Future<void> _dialogBuilderLines(context, editData, formKey, updateItemDb,
    oneDeviceStates, updateNewRegister) {
  String title = 'Конфигурация проводных линий';

  // String reg0 = oneDeviceStates[0].value;
  // bool multiMegaZona = reg0.substring(21, 22) == '1';
  // ignore: no_leading_underscores_for_local_identifiers
  StateSetter _setState;
  return showDialog<void>(
    context: context,
    builder: (BuildContext contextLines) {
      return AlertDialog(
        alignment: Alignment.center,
        // backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        title: Row(children: [
          Icon(
              color: Theme.of(context).colorScheme.secondary,
              CupertinoIcons.bars),
          Text('   $title')
        ]),
        content: StatefulBuilder(// You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
          _setState = setState;

          String reg1 = oneDeviceStates[1].value;
          String reg2 = oneDeviceStates[2].value;

          String valvesLine1 = reg1.substring(23, 25);
          bool isButtonLine1 = reg1.substring(20, 22) == '01';
          String valvesLine2 = reg1.substring(30, 32);
          bool isButtonLine2 = reg1.substring(28, 30) == '01';

          String valvesLine3 = reg2.substring(23, 25);
          bool isButtonLine3 = reg2.substring(20, 22) == '01';
          String valvesLine4 = reg2.substring(30, 32);
          bool isButtonLine4 = reg2.substring(28, 30) == '01';

          void stateReg(r, v) {
            _setState(() {
              switch (r) {
                case 1:
                  reg1 = v;
                  break;
                case 2:
                  reg2 = v;
                  break;
              }
            });
          }

          return SizedBox(
              width: 700,
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
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  linesBox(
                                      Column(children: [
                                        editLineName(editData, 0),
                                        editLineButton(
                                            editData,
                                            isButtonLine1,
                                            context,
                                            reg1,
                                            21,
                                            1,
                                            updateNewRegister,
                                            stateReg),
                                        marginVertical(),
                                        editLineZones(
                                            editData,
                                            valvesLine1,
                                            context,
                                            reg1,
                                            23,
                                            1,
                                            updateNewRegister,
                                            stateReg)
                                      ]),
                                      context),
                                  linesBox(
                                      Column(children: [
                                        editLineName(editData, 1),
                                        editLineButton(
                                            editData,
                                            isButtonLine2,
                                            context,
                                            reg1,
                                            28,
                                            1,
                                            updateNewRegister,
                                            stateReg),
                                        marginVertical(),
                                        editLineZones(
                                            editData,
                                            valvesLine2,
                                            context,
                                            reg1,
                                            30,
                                            1,
                                            updateNewRegister,
                                            stateReg)
                                      ]),
                                      context),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  linesBox(
                                      Column(children: [
                                        editLineName(editData, 2),
                                        editLineButton(
                                            editData,
                                            isButtonLine3,
                                            context,
                                            reg2,
                                            21,
                                            2,
                                            updateNewRegister,
                                            stateReg),
                                        marginVertical(),
                                        editLineZones(
                                            editData,
                                            valvesLine3,
                                            context,
                                            reg2,
                                            23,
                                            2,
                                            updateNewRegister,
                                            stateReg)
                                      ]),
                                      context),
                                  linesBox(
                                      Column(children: [
                                        editLineName(editData, 3),
                                        editLineButton(
                                            editData,
                                            isButtonLine4,
                                            context,
                                            reg2,
                                            28,
                                            2,
                                            updateNewRegister,
                                            stateReg),
                                        marginVertical(),
                                        editLineZones(
                                            editData,
                                            valvesLine4,
                                            context,
                                            reg2,
                                            30,
                                            2,
                                            updateNewRegister,
                                            stateReg)
                                      ]),
                                      context),
                                ],
                              ),
                            ],
                          )
                          // -----------------------------------------------------
                          ),
                    ],
                  )));
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
