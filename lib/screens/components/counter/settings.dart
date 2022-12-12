part of '../../counter.dart';

Column settingsBase(context, item, itemDb, formKey, updateItemDb,
    updateoneDeviceCounters, updateoneDeviceCountersParams) {
  bool wsize = MediaQuery.of(context).size.width > 800;
  return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(style: titleStyle(context), 'Настройки'),
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
                            text: '  Имя счётчика: ',
                            children: <TextSpan>[
                              TextSpan(
                                  text: wsize
                                      ? '${itemDb.counters[item.index]}'
                                      : '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        Text(
                            style: descStyle(context),
                            '   Переименование счётчика')
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
                _dialogBuilder(context, item, itemDb, formKey, 0, updateItemDb,
                    updateoneDeviceCounters, updateoneDeviceCountersParams);
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
                      CupertinoIcons.gauge),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: subTitleStyle(context),
                            text: '  Текущие показания: ',
                            children: <TextSpan>[
                              TextSpan(
                                  text: '${item.value}м³',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        Text(
                            style: descStyle(context),
                            '   Изменение текущих показаний')
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
                _dialogBuilder(context, item, itemDb, formKey, 2, updateItemDb,
                    updateoneDeviceCounters, updateoneDeviceCountersParams);
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
                      CupertinoIcons.drop_triangle),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: subTitleStyle(context),
                            text: '  Уведомление по лимиту: ',
                            children: <TextSpan>[
                              TextSpan(
                                  text: item.limit > 0 && wsize
                                      ? '${item.limit}м³'
                                      : !wsize
                                          ? ''
                                          : 'нет',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        Text(
                            style: descStyle(context),
                            wsize
                                ? '   Отображать уведомление при достижении указанного лимита\n   0 - для отключения, уведомление отображается на главном экране'
                                : '   Отображать уведомление по лимиту\n   0 - для отключения')
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
                _dialogBuilder(context, item, itemDb, formKey, 3, updateItemDb,
                    updateoneDeviceCounters, updateoneDeviceCountersParams);
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
                      CupertinoIcons.brightness),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: subTitleStyle(context),
                            text: '  Состояние счётчика: ',
                          ),
                        ),
                        Text(
                            style: descStyle(context),
                            '   Включение или выключение подсчёта')
                      ])
                ])
              ],
            ),
            Transform.scale(
              scale: 0.95,
              child: CupertinoSwitch(
                value: item.state,
                thumbColor: CupertinoColors.white,
                trackColor: CupertinoColors.inactiveGray.withOpacity(0.4),
                activeColor: CupertinoColors.systemGreen.withOpacity(0.6),
                onChanged: (bool? value) async {
                  var res = await sendOneRegister(item.reg, 31,
                      item.state ? '0' : '1', 1, item.index + 123, itemDb);
                  if (res[0]) {
                    updateoneDeviceCountersParams(item.index, res[1]);
                    item.state = !item.state;
                    updateItemDb();
                  } else {
                    playError(context);
                  }
                },
              ),
            ),
          ],
        ), // ---------------------------------------------------------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(children: [
                  Icon(
                      color: Theme.of(context).colorScheme.secondary,
                      CupertinoIcons.f_cursive),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: subTitleStyle(context),
                            text: '  Тип счётчика Namur: ',
                          ),
                        ),
                        Text(
                            style: descStyle(context),
                            '   Переключение типа счётчика')
                      ])
                ])
              ],
            ),
            Transform.scale(
              scale: 0.95,
              child: CupertinoSwitch(
                value: item.type,
                thumbColor: CupertinoColors.white,
                trackColor: CupertinoColors.inactiveGray.withOpacity(0.4),
                activeColor: CupertinoColors.systemGreen.withOpacity(0.6),
                onChanged: (bool? value) async {
                  var res = await sendOneRegister(item.reg, 30,
                      item.type ? '0' : '1', 1, item.index + 123, itemDb);
                  if (res[0]) {
                    updateoneDeviceCountersParams(item.index, res[1]);
                    item.type = !item.type;
                    updateItemDb();
                  } else {
                    playError(context);
                  }
                },
              ),
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
                      CupertinoIcons.gauge_badge_plus),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: subTitleStyle(context),
                            text: '  Шаг счёта: ',
                          ),
                        ),
                        Text(
                            style: descStyle(context),
                            '   Выбора шага счёта на импульс')
                      ])
                ])
              ],
            ),
            stepper(context, item, itemDb, updateItemDb,
                updateoneDeviceCountersParams),
          ],
        ),
      ]);
}
