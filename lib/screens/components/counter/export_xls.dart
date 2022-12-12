part of '../../counter.dart';

Future<void> exportFile(allevents, titlec, devname) async {
  // ---------------------------------------------------------------------------
  // Init
  var excel = Excel.createExcel();
  excel.rename('Sheet1', 'STATS');
  Sheet sheetObject = excel['STATS'];
  List<String> dataCommon = [
    "Устройство $devname - Счётчик $titlec",
  ];
  List<String> dataList = [
    "Дата",
    "Расход, м3",
  ];
  sheetObject.insertRowIterables(dataCommon, 0);
  sheetObject.insertRowIterables(dataList, 1);
  sheetObject.insertRowIterables([], 2);
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // Write data
  for (int e = 0; e < allevents.length; e++) {
    var newFormat = DateFormat("dd.MM.yy");
    var formatted = newFormat.format(allevents[e].date);
    sheetObject.insertRowIterables([
      formatted.toString(),
      allevents[e].value,
    ], e + 3);
  }
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // Saving
  final now = DateTime.now().toLocal();
  var newFormat = DateFormat("HH-mm-ss_dd-MM-yy");
  var formattedNow = newFormat.format(now);
  var fileBytes = excel.save();
  File(join("$appDataDirectory/Stats/$titlec-$formattedNow.xlsx"))
    ..createSync(recursive: true)
    ..writeAsBytesSync(fileBytes!);
  // ---------------------------------------------------------------------------
  if (Platform.isAndroid || Platform.isIOS) {
    Share.shareXFiles(
        [XFile("$appDataDirectory/Stats/$titlec-$formattedNow.xlsx")],
        text: 'Сохраните файл');
  }
}

Future<void> _dialogBuilderExport(context, allevents, titlec, devname) {
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
                    'Будет выполнен экспорт статистики по данному счётчику.\nЭкспорт выполняется в соответствии с заданными фильтрами и текущим отображением на экране.\n\nСохраненный файл будет доступен в директории приложения: ', // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '$appDataDirectory/Stats ',
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
              exportFile(allevents, titlec, devname);
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
