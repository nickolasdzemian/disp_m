part of '../../device.dart';

Column settingsLines(context, itemDb, oneDeviceStates, formKey,
    updateOneDeviceStates, updateItemDb, state, getAdditionalParams) {
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
      '   Переименование зон для корректного отображения уведомлений в многозонном режиме',
      '   Переименование, установка типа, назначение группы',
      '   Режим переключения и назначение группы для срабатывания реле',
      '   Переключение отображения счётиков по слотам'
    ];
  } else {
    txts = [
      '   Переименование зон контроля\n   для многозонного режима',
      '   Переименование, установка типа,\n   назначение группы',
      '   Режим переключения и назначение зоны',
      '   Отображение счётиков по слотам'
    ];
  }

  return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(style: titleStyle(context), 'Настройки'),
        // ---------------------------------------------------------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(children: [
                  Icon(
                      color: Theme.of(context).colorScheme.secondary,
                      CupertinoIcons.text_cursor),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(style: subTitleStyle(context), '  Названия зон'),
                        Text(style: descStyle(context), txts[0])
                      ]),
                ])
              ],
            ),
            IconButton(
              icon: Icon(
                CupertinoIcons.right_chevron,
                size: 22,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                _dialogBuilder(
                    context, itemDb, formKey, 4, updateItemDb, state);
              },
            ),
          ],
        ),
        // ---------------------------------------------------------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(children: [
                  Icon(
                      color: Theme.of(context).colorScheme.secondary,
                      CupertinoIcons.bars),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            style: subTitleStyle(context),
                            '  Настройки проводных линий'),
                        Text(style: descStyle(context), txts[1])
                      ]),
                ])
              ],
            ),
            IconButton(
              icon: Icon(
                CupertinoIcons.right_chevron,
                size: 22,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                _dialogBuilderLines(context, itemDb, formKey, updateItemDb,
                    oneDeviceStates, updateNewRegister);
              },
            ),
          ],
        ),
        // ---------------------------------------------------------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(children: [
                  Icon(
                      color: Theme.of(context).colorScheme.secondary,
                      CupertinoIcons.alt),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            style: subTitleStyle(context),
                            '  Настройка реле событий'),
                        Text(style: descStyle(context), txts[2])
                      ]),
                ])
              ],
            ),
            IconButton(
              icon: Icon(
                CupertinoIcons.right_chevron,
                size: 22,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                _dialogBuilderRelay(context, itemDb, formKey, updateItemDb,
                    oneDeviceStates, updateNewRegister);
              },
            ),
          ],
        ),
        // ---------------------------------------------------------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(children: [
                  Icon(
                      color: Theme.of(context).colorScheme.secondary,
                      CupertinoIcons.gauge),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            style: subTitleStyle(context),
                            '  Отображение счётчиков'),
                        Text(style: descStyle(context), txts[3])
                      ]),
                ])
              ],
            ),
            IconButton(
              icon: Icon(
                CupertinoIcons.right_chevron,
                size: 22,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                _dialogBuilderCswitch(context, itemDb, formKey, updateItemDb,
                    oneDeviceStates, updateNewRegister, getAdditionalParams);
              },
            ),
          ],
        ),
        // ---------------------------------------------------------------------
      ]);
}
