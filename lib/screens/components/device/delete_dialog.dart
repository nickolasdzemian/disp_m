part of '../../device.dart';

Future<void> _dialogBuilderDelete(context, editData, updateItemDb) {
  String title = 'Удаление устройства';

  // StateSetter _setState;

  return showDialog<void>(
    context: context,
    builder: (BuildContext contextDel) {
      return AlertDialog(
        alignment: Alignment.topCenter,
        // backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        title: Row(children: [
          Icon(
              color: Theme.of(context).colorScheme.error,
              CupertinoIcons.delete),
          Text('   $title')
        ]),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          // _setState = setState;

          return const SizedBox(
            width: 400,
            child: Text(
                'Вы уверены, что хотите удалить устройство?\nДанное действие необратимо. После удаления интерфейс будет перезапущен.'),
          );
        }),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () async {
              await DataBase.delete([editData.mac]);
              run = false;
              globalStopTimer();
              Navigator.of(context).pop();
              Rebuilder.of(context)?.rebuild();
            },
            child: Text(
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                'Удаление'),
          ),
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
                'Отмена'),
          ),
        ],
      );
    },
  );
}
