part of '../../device.dart';

Future<void> _dialogBuilderRelay(context, editData, formKey, updateItemDb,
    oneDeviceStates, updateNewRegister) {
  double wsize = MediaQuery.of(context).size.width;
  String title =
      wsize > 800 ? 'Переключение реле событий' : 'Переключение реле';

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
              CupertinoIcons.alt),
          Text('   $title')
        ]),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          _setState = setState;

          String reg4 = oneDeviceStates[4].value;
          String triggerValve = reg4.substring(28, 30);
          String alarmValve = reg4.substring(30, 32);
          bool busy = false;

          void stateReg(r, v) {
            _setState(() {
              reg4 = v;
            });
          }

          void setBusy(v) {
            _setState(() {
              busy = v;
            });
          }

          return SizedBox(
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
                          child: editRelayConfig(
                              editData,
                              triggerValve,
                              alarmValve,
                              context,
                              reg4,
                              updateNewRegister,
                              stateReg,
                              busy,
                              setBusy,
                              wsize > 800)),
                    ],
                  )));
        }),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () {
              Navigator.of(context).pop();
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
