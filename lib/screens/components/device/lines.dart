part of '../../device.dart';

Column settingsLines(context, itemDb, oneDeviceStates, formKey,
    updateOneDeviceStates, updateItemDb, state) {
  // String reg0 = oneDeviceStates[0].value;
  // bool multiMegaZona = reg0.substring(21, 22) == '1';
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
        Text(style: titleStyle(context), 'Настройки'),
        // ------------------------------------------------------------------------------------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        Text(
                            style: descStyle(context),
                            '   Переименование зон для корректного отображения уведомлений в многозонном режиме')
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
        // ------------------------------------------------------------------------------------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        Text(
                            style: descStyle(context),
                            '   Переименование, установка типа, назначение группы')
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
        // ------------------------------------------------------------------------------------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        Text(
                            style: descStyle(context),
                            '   Режим переключения и назначение группы для срабатывания реле')
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
        // ------------------------------------------------------------------------------------------------
      ]);
}
