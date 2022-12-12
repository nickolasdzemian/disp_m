part of '../../counter.dart';

Future<void> _dialogBuilderClean(context, updateState, key) {
  String title = 'Очистка журнала';

  return showDialog<void>(
    context: context,
    builder: (BuildContext contextClean) {
      return AlertDialog(
        alignment: Alignment.topCenter,
        // backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        title: Row(children: [
          Icon(
              color: Theme.of(context).colorScheme.error,
              CupertinoIcons.delete),
          Text('   $title')
        ]),
        content: const SizedBox(
          width: 400,
          child: Text(
              'Вы уверены, что хотите очистить статистику по счётчику?\nДанное действие необратимо. Рекомендуется сделать резервную копию!'),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () async {
              await cstats.delete(key);
              List<CounterSItem> initialStats = <CounterSItem>[
                CounterSItem(date: DateTime.now().toLocal(), value: 0)
              ];
              await cstats.put(key, initialStats);
              updateState();
              Navigator.of(context).pop();
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
