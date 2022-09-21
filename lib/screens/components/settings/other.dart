part of '../../settings.dart';

Column settingsOther(context, autoScan, server, serverPort, notifications,
    reserved, updates, state) {
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
                        Text(
                            style: subTitleStyle(context),
                            '  Автоматический поиск при потере связи:'),
                        Text(
                            style: descStyle(context),
                            '''   Система инициирует автоматический поиск и обновление параметров
   для потерянных устройств. Всего существляется 10 попыток восстановления''')
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
                        Text(
                            style: subTitleStyle(context),
                            '  Уведомления при отсутствии связи с устройством:'),
                        Text(
                            style: descStyle(context),
                            '''   Если устройство потеряно и не отвечает на запросы системы''')
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
                        Text(
                            style: subTitleStyle(context),
                            '  Уведомления по тревоге:'),
                        Text(
                            style: descStyle(context),
                            '''   Если сработал датчик или произошла протечка''')
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
                        Text(
                            style: subTitleStyle(context),
                            '  Уведомления при потере радиодатчика:'),
                        Text(
                            style: descStyle(context),
                            '''   Если нет связи с беспроводным датчиком''')
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
                        Text(
                            style: subTitleStyle(context),
                            '  Уведомления при разряде батареи радиодатчика:'),
                        Text(
                            style: descStyle(context),
                            '''   Если уровень заряда батареи критически низкий
   и необходимо заменить элемент питания (CR123A 3V)''')
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
        )
        // ------------------------------------------------------------------------------------------------
      ]);
}
