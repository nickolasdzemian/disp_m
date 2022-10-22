part of '../../device.dart';

Column settingsMain(
    context, itemDb, oneDeviceStates, formKey, updateOneDeviceStates) {
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
                        Text(
                            style: descStyle(context),
                            '   Разделение состояний и управления на две независимые зоны')
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
                        Text(
                            style: descStyle(context),
                            '   Отключение реагирования на нажатия физических кнопок')
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
                        Text(
                            style: subTitleStyle(context),
                            '  Закрывать краны при потере радиодатчика'),
                        Text(
                            style: descStyle(context),
                            '   Краны будут закрыты, если один из беспроводных датчиков не вышел на связь')
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
                        Text(
                            style: subTitleStyle(context),
                            '  Включить режим добавления радиодатчиков'),
                        Text(
                            style: descStyle(context),
                            '   Время работы режима - минута,\n   состояние переключателя режима не обновляется автоматически')
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
              },
            ),
          ],
        ),
        // ---------------------------------------------------------------------
      ]);
}
