part of '../../device.dart';

Column settingsMain(context, itemDb, oneDeviceStates, formKey,
    updateOneDeviceStates, periodicUpdate) {
  String reg0 = oneDeviceStates[0].value;
  bool blocked = reg0.substring(19, 20) == '1';
  bool multiMegaZona = reg0.substring(21, 22) == '1';
  bool lostAndClose = reg0.substring(20, 21) == '1';
  bool addNewRadio = reg0.substring(24, 25) == '1';
  void updateNewRegister(ind, res) {
    if (res[0]) {
      updateOneDeviceStates(ind, res[1]);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: const Text('Произошла ошибка, попробуйте снова')),
      );
      SystemSound.play(SystemSoundType.alert);
    }
  }

  List<String> txts = [];
  if (MediaQuery.of(context).size.width > 800) {
    txts = [
      '   Разделение состояний и управления на две независимые зоны',
      '   Отключение реагирования на нажатия физических кнопок',
      '  Закрывать краны при потере радиодатчика',
      '   Краны будут закрыты, если один из беспроводных датчиков не вышел на связь',
      '  Включить режим добавления радиодатчиков',
      '   Время работы режима - 1 мин., список датчиков и состояние переключателя обновляются\n   с интервалом 5 сек автоматически, только при включенном режиме'
    ];
  } else {
    txts = [
      '   Разделение на две независимые зоны',
      '   Отключение физических кнопок',
      '  Закрывать краны\n  при потере радиодатчика',
      '   Краны будут закрыты,\n   если радиодатчик потерян',
      '  Включить режим\n  добавления радиодатчиков',
      '   Время работы режима - 1 минута'
    ];
  }

  return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(style: titleStyle(context), 'Параметры'),
        // ---------------------------------------------------------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(children: [
                  Icon(
                      color: Theme.of(context).colorScheme.secondary,
                      CupertinoIcons.square_line_vertical_square_fill),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            style: subTitleStyle(context),
                            '  Многозонный режим'),
                        Text(style: descStyle(context), txts[0])
                      ]),
                ])
              ],
            ),
            CupertinoSwitch(
              value: multiMegaZona,
              thumbColor: CupertinoColors.white,
              trackColor: CupertinoColors.inactiveGray.withOpacity(0.4),
              activeColor: CupertinoColors.systemGreen.withOpacity(0.6),
              onChanged: (bool? value) async {
                var res = await sendOneRegister(
                    reg0, 21, multiMegaZona ? '0' : '1', 1, 0, itemDb);
                updateNewRegister(0, res);
              },
            ),
          ],
        ),
        // ---------------------------------------------------------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(children: [
                  Icon(
                      color: Theme.of(context).colorScheme.secondary,
                      CupertinoIcons.lock),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            style: subTitleStyle(context),
                            '  Блокировка кнопок'),
                        Text(style: descStyle(context), txts[1])
                      ])
                ])
              ],
            ),
            CupertinoSwitch(
              value: blocked,
              thumbColor: CupertinoColors.white,
              trackColor: CupertinoColors.inactiveGray.withOpacity(0.4),
              activeColor: CupertinoColors.systemGreen.withOpacity(0.6),
              onChanged: (bool? value) async {
                var res = await sendOneRegister(
                    reg0, 19, blocked ? '0' : '1', 1, 0, itemDb);
                updateNewRegister(0, res);
              },
            ),
          ],
        ),
        // ---------------------------------------------------------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(children: [
                  Icon(
                      color: Theme.of(context).colorScheme.secondary,
                      CupertinoIcons.eye_slash),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(style: subTitleStyle(context), txts[2]),
                        Text(style: descStyle(context), txts[3])
                      ])
                ])
              ],
            ),
            CupertinoSwitch(
              value: lostAndClose,
              thumbColor: CupertinoColors.white,
              trackColor: CupertinoColors.inactiveGray.withOpacity(0.4),
              activeColor: CupertinoColors.systemGreen.withOpacity(0.6),
              onChanged: (bool? value) async {
                var res = await sendOneRegister(
                    reg0, 20, lostAndClose ? '0' : '1', 1, 0, itemDb);
                updateNewRegister(0, res);
              },
            ),
          ],
        ),
        // ---------------------------------------------------------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(children: [
                  Icon(
                      color: Theme.of(context).colorScheme.secondary,
                      CupertinoIcons.dot_radiowaves_left_right),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(style: subTitleStyle(context), txts[4]),
                        Text(style: descStyle(context), txts[5])
                      ])
                ])
              ],
            ),
            CupertinoSwitch(
              value: addNewRadio,
              thumbColor: CupertinoColors.white,
              trackColor: CupertinoColors.inactiveGray.withOpacity(0.4),
              activeColor: CupertinoColors.systemGreen.withOpacity(0.6),
              onChanged: (bool? value) async {
                var res = await sendOneRegister(
                    reg0, 24, addNewRadio ? '0' : '1', 1, 0, itemDb);
                updateNewRegister(0, res);
                periodicUpdate(value);
              },
            ),
          ],
        ),
        // ---------------------------------------------------------------------
      ]);
}
