part of '../../settings.dart';

Column settingsOther(context, autoScan, server, serverPort, notifications,
    reserved, updates, state) {
  List<String> txts = [];
  if (MediaQuery.of(context).size.width > 800) {
    txts = [
      '  Автоматический поиск при потере связи:',
      '''   Система инициирует автоматический поиск и обновление параметров
   для потерянных устройств. Всего существляется 10 попыток восстановления''',
      '  Уведомления при отсутствии связи с устройством:',
      '''   Если устройство потеряно и не отвечает на запросы системы''',
      '  Уведомления по тревоге:',
      '''   Если сработал датчик или произошла протечка''',
      '  Уведомления при потере радиодатчика:',
      '''   Если нет связи с беспроводным датчиком''',
      '  Уведомления при разряде батареи радиодатчика:',
      '''   Если уровень заряда батареи критически низкий
   и необходимо заменить элемент питания (CR123A 3V)''',
      '  Уведомления об ошибках счётчиков:',
      '''   Если тип подключенного счётчика Namur,
   отображаются ошибки при коротком замыкании или обрыве линии''',
      '  Локальный сервер и доступ к API:',
      '''   Включение локального сервера для получения данных по API
   и возможности распределенного управления'''
    ];
  } else {
    txts = [
      '  Автопоиск при потере связи:',
      '''   Система инициирует автоматический
   для потерянных устройств.''',
      '  Уведомления при потере\n  связи с устройством:',
      '''   Если устройство не отвечает''',
      '  Уведомления по тревоге:',
      '''   Если произошла протечка''',
      '  Уведомления при потере\n  радиодатчика:',
      '''   Если нет связи с датчиком''',
      '  Уведомления при разряде\n  батареи радиодатчика:',
      '''   Если уровень заряда батареи низкий
   заменить элемент питания (CR123A 3V)''',
      '  Уведомления по счётчикам:',
      '''   Если тип счётчика Namur, сообщение
   о коротком замыкании или обрыве''',
      '  Локальный сервер и API:',
      '''   Включение локального сервера'''
    ];
  }
  return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      CupertinoIcons.arrow_clockwise),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(style: subTitleStyle(context), txts[0]),
                        Text(
                            overflow: TextOverflow.ellipsis,
                            style: descStyle(context),
                            txts[1])
                      ])
                ])
              ],
            ),
            CupertinoSwitch(
              value: autoScan,
              thumbColor: CupertinoColors.white,
              trackColor: CupertinoColors.inactiveGray.withOpacity(0.4),
              activeColor: CupertinoColors.systemGreen.withOpacity(0.6),
              onChanged: (bool? value) {
                state('autoScan', !autoScan);
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
                      CupertinoIcons.chart_bar),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(style: subTitleStyle(context), txts[2]),
                        Text(style: descStyle(context), txts[3]),
                      ])
                ])
              ],
            ),
            CupertinoSwitch(
              value: notifications[3],
              thumbColor: CupertinoColors.white,
              trackColor: CupertinoColors.inactiveGray.withOpacity(0.4),
              activeColor: CupertinoColors.systemGreen.withOpacity(0.6),
              onChanged: (bool? value) {
                state('notifications3', !notifications[3]);
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
                      CupertinoIcons.drop),
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
              value: notifications[0],
              thumbColor: CupertinoColors.white,
              trackColor: CupertinoColors.inactiveGray.withOpacity(0.4),
              activeColor: CupertinoColors.systemGreen.withOpacity(0.6),
              onChanged: (bool? value) {
                state('notifications0', !notifications[0]);
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
                      CupertinoIcons.dot_radiowaves_right),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(style: subTitleStyle(context), txts[6]),
                        Text(style: descStyle(context), txts[7])
                      ])
                ])
              ],
            ),
            CupertinoSwitch(
              value: notifications[1],
              thumbColor: CupertinoColors.white,
              trackColor: CupertinoColors.inactiveGray.withOpacity(0.4),
              activeColor: CupertinoColors.systemGreen.withOpacity(0.6),
              onChanged: (bool? value) {
                state('notifications1', !notifications[1]);
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
                      CupertinoIcons.battery_0),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(style: subTitleStyle(context), txts[8]),
                        Text(style: descStyle(context), txts[9])
                      ])
                ])
              ],
            ),
            CupertinoSwitch(
              value: notifications[2],
              thumbColor: CupertinoColors.white,
              trackColor: CupertinoColors.inactiveGray.withOpacity(0.4),
              activeColor: CupertinoColors.systemGreen.withOpacity(0.6),
              onChanged: (bool? value) {
                state('notifications2', !notifications[2]);
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
                        Text(style: subTitleStyle(context), txts[10]),
                        Text(style: descStyle(context), txts[11])
                      ])
                ])
              ],
            ),
            CupertinoSwitch(
              value: notifications[4],
              thumbColor: CupertinoColors.white,
              trackColor: CupertinoColors.inactiveGray.withOpacity(0.4),
              activeColor: CupertinoColors.systemGreen.withOpacity(0.6),
              onChanged: (bool? value) {
                state('notifications4', !notifications[4]);
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
                      CupertinoIcons.chevron_left_slash_chevron_right),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(style: subTitleStyle(context), txts[12]),
                        Text(style: descStyle(context), txts[13]),
                      ]),
                  IconButton(
                    icon: Icon(
                        size: 18,
                        color: Theme.of(context).colorScheme.secondary,
                        CupertinoIcons.info_circle),
                    tooltip: 'Выбор порта и описание',
                    onPressed: () => {
                      if (!Platform.isAndroid && !Platform.isIOS)
                        {_dialogServe(context, state)}
                      else if (Platform.isAndroid || Platform.isIOS)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'В настоящий момент локальный сервер недоступен для мобильных ОС')),
                          )
                        }
                    },
                  )
                ]),
              ],
            ),
            CupertinoSwitch(
              value: server,
              thumbColor: CupertinoColors.white,
              trackColor: CupertinoColors.inactiveGray.withOpacity(0.4),
              activeColor: CupertinoColors.systemGreen.withOpacity(0.6),
              onChanged: (bool? value) {
                if (!Platform.isAndroid && !Platform.isIOS) {
                  state('server', !server);
                  _diagRestart(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Для применения настроек приложение необходимо перезапустить!')),
                  );
                } else if (Platform.isAndroid || Platform.isIOS) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'В настоящий момент локальный сервер недоступен для мобильных ОС')),
                  );
                }
              },
            ),
          ],
        )
        // ---------------------------------------------------------------------
      ]);
}
