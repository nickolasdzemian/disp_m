part of '../../settings.dart';

Column settingsBoxAdd(context, bigValue, addDevices, adding, addDevice,
    helpTitle, help, dialogHelp) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                style: titleStyle(context),
                textAlign: TextAlign.start,
                'Добавление устройств'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(style: subTitleStyle(context), 'Кол-во подключенных:'),
                adding
                    ? SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                            strokeWidth: 3.5,
                            color: Theme.of(context).colorScheme.secondary))
                    : Text(style: bigValueStyle(context), '$bigValue'),
              ],
            ),
          ]),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(style: descStyle(context), 'Описание режимов добавления:\n'),
          TextButton(
            onPressed: () {
              dialogHelp(context, helpTitle, help);
            },
            child: Text(style: descButton(context), 'открыть\n'),
          ),
        ],
      ),
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  addDevices();
                },
                child: Row(children: [
                  const Icon(
                    CupertinoIcons.memories_badge_plus,
                    size: 18,
                  ),
                  Text(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                      adding ? ' Добавление..' : '  Авто-режим'),
                ]),
              ),
              ElevatedButton(
                onPressed: () {
                  addDevice();
                },
                child: Row(children: [
                  const Icon(
                    CupertinoIcons.pencil_ellipsis_rectangle,
                    size: 18,
                  ),
                  Text(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                      '  Ручной'),
                ]),
              )
            ],
          ),
        ],
      ),
    ],
  );
}
