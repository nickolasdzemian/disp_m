part of '../../device.dart';

Column settingsBase(context, itemDb, formKey, updateItemDb, state) {
  double wsize = MediaQuery.of(context).size.width;
  return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(style: titleStyle(context), 'Основное'),
          Row(children: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelSmall,
              ),
              onPressed: () {
                _dialogBuilderDelete(context, itemDb, updateItemDb);
              },
              child: Text(style: titleStyleErr(context), ' Удалить устройство'),
            ),
          ]),
        ]),
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
                      CupertinoIcons.italic),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: subTitleStyle(context),
                            text: '  Имя устройства: ',
                            children: <TextSpan>[
                              TextSpan(
                                  text: wsize > 800 ? '${itemDb.name}' : '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        Text(
                            style: descStyle(context),
                            '   Переименование устройства')
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
                    context, itemDb, formKey, 0, updateItemDb, state);
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
                      CupertinoIcons.squares_below_rectangle),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: subTitleStyle(context),
                            text: '  IP-адрес: ',
                            children: <TextSpan>[
                              TextSpan(
                                  text: wsize > 800 ? '${itemDb.ip}' : '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        Text(
                            style: descStyle(context),
                            '   Изменение IP-адреса устройства')
                      ])
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
                    context, itemDb, formKey, 1, updateItemDb, state);
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
                      CupertinoIcons.textformat_123),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: subTitleStyle(context),
                            text: '  Текущий UnitID: ',
                            children: <TextSpan>[
                              TextSpan(
                                  text: wsize > 800 ? '${itemDb.id}' : '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        Text(
                            style: descStyle(context),
                            '   Изменение UnitID устройства ${wsize > 800 ? '(по умолчанию 240)' : ''}')
                      ])
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
                    context, itemDb, formKey, 2, updateItemDb, state);
              },
            ),
          ],
        ),
      ]);
}
