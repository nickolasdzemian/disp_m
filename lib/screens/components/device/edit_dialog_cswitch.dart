part of '../../device.dart';

Future<void> _dialogBuilderCswitch(context, editData, formKey, updateItemDb,
    oneDeviceStates, updateNewRegister, getAdditionalParams) {
  double wsize = MediaQuery.of(context).size.width;
  String title = wsize > 800 ? 'Отображение счётчиков:' : 'Cчётчики:';

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
              CupertinoIcons.gauge_badge_plus),
          Text('   $title')
        ]),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          _setState = setState;
          List cswitch = editData.cswitch;

          void stateCswitch(int i, bool v) async {
            _setState(() {
              cswitch[i] = v;
            });
            newDevice = Device(
                editData.index,
                editData.ip,
                editData.mac,
                editData.id,
                editData.name,
                editData.lines,
                editData.sensors,
                editData.zones,
                editData.counters,
                cswitch);
            await updateDB(newDevice);
            updateItemDb();
          }

          return SingleChildScrollView(
              child: SizedBox(
                  width: wsize > 800 ? 500 : wsize,
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
                              child: Wrap(
                                children: [
                                  linesBox(
                                      editCounterVisibility(
                                          context, cswitch, stateCswitch, 0),
                                      context),
                                  linesBox(
                                      editCounterVisibility(
                                          context, cswitch, stateCswitch, 2),
                                      context),
                                  linesBox(
                                      editCounterVisibility(
                                          context, cswitch, stateCswitch, 4),
                                      context),
                                  linesBox(
                                      editCounterVisibility(
                                          context, cswitch, stateCswitch, 6),
                                      context),
                                ],
                              )),
                        ],
                      ))));
        }),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () {
              newDevice = [];
              Navigator.of(context).pop();
            },
            child: Text(
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                'Закрыть'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () async {
              newDevice = [];
              await getAdditionalParams(false);
              updateItemDb();
              Navigator.of(context).pop();
            },
            child: Text(
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                'Сохранить'),
          )
        ],
      );
    },
  );
}
