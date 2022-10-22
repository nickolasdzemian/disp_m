part of '../../device.dart';

Column settingsBase(context, itemDb, formKey, updateItemDb, state) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  text: '${itemDb.name}',
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  text: '${itemDb.ip}',
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  text: '${itemDb.id}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        Text(
                            style: descStyle(context),
                            '   Изменение UnitID устройства (по умолчанию 240)')
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
        // ------------------------------------------------------------------------------------------------
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Column(
        //       children: [
        //         Row(children: [
        //           Icon(
        //               color: Theme.of(context).colorScheme.secondary,
        //               CupertinoIcons.text_justifyleft),
        //           Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text(style: subTitleStyle(context), '  ${itemDb.id}'),
        //                 Text(
        //                     style: descStyle(context),
        //                     '   Переименование проводных линий')
        //               ])
        //         ])
        //       ],
        //     ),
        //     IconButton(
        //       icon: const Icon(
        //         CupertinoIcons.right_chevron,
        //         size: 22,
        //       ),
        //       onPressed: () {
        //         _dialogBuilder(context, itemDb, formKey, 3, updateItemDb);
        //       },
        //     ),
        //   ],
        // ),
        // ------------------------------------------------------------------------------------------------
      ]);
}
