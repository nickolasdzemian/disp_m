part of '../../history.dart';

Future<void> exportFile(allevents) async {
  // ---------------------------------------------------------------------------
  // Init
  var excel = Excel.createExcel();
  excel.rename('Sheet1', 'HISTORY');
  Sheet sheetObject = excel['HISTORY'];
  List<String> dataList = [
    "Время события",
    "Timestamp",
    "Тип",
    "Имя",
    "Инициализатор",
    "Сообщение",
  ];
  sheetObject.insertRowIterables(dataList, 0);
  sheetObject.insertRowIterables([], 1);
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // Write data
  for (int e = 0; e < allevents.length; e++) {
    sheetObject.insertRowIterables([
      allevents[e].formatedStamp,
      allevents[e].timestamp.toString(),
      allevents[e].evType,
      allevents[e].evName,
      allevents[e].deviceName,
      allevents[e].info
    ], e + 2);
  }
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // Saving
  final now = DateTime.now().toLocal();
  var newFormat = DateFormat("HH-mm-ss_dd-MM-yy");
  var formattedNow = newFormat.format(now);
  var fileBytes = excel.save();
  File(join("$appDataDirectory/History/Neptun_history_$formattedNow.xlsx"))
    ..createSync(recursive: true)
    ..writeAsBytesSync(fileBytes!);
  // ---------------------------------------------------------------------------
  if (Platform.isAndroid || Platform.isIOS) {
    Share.shareXFiles(
        [XFile("$appDataDirectory/History/Neptun_history_$formattedNow.xlsx")],
        text: 'Сохраните файл');
  }
}

Future<void> _dialogBuilderExport(context, allevents) {
  String title = 'Резервное копирование';

  return showDialog<void>(
    context: context,
    builder: (BuildContext contextClean) {
      return AlertDialog(
        alignment: Alignment.topCenter,
        // backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        title: Row(children: [
          Icon(
              color: Theme.of(context).colorScheme.secondary,
              CupertinoIcons.arrow_down_doc),
          Text('   $title')
        ]),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            width: 400,
            child: SelectableText.rich(
              TextSpan(
                text:
                    'Будет выполнен экспорт журнала событий.\nЭкспорт выполняется в соответствии с заданными фильтрами и текущим отображением на экране.\n\nСохраненный файл будет доступен в директории приложения: ', // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '$appDataDirectory/History ',
                      style: const TextStyle(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          );
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
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                'Отмена'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () {
              exportFile(allevents);
              Navigator.of(context).pop();
            },
            child: Text(
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                'Экспорт'),
          ),
        ],
      );
    },
  );
}
