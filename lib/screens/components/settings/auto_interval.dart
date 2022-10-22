part of '../../settings.dart';

Column settingsAutoInterval(
    context, bigValue, setInterval, adding, state, scanMode) {
  String modeScanner = !scanMode ? '\n  рекурсивный\n' : '\n\n  интервальный';
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
                'Настройки опроса'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(style: subTitleStyle(context), 'Интервал опроса:'),
                adding
                    ? SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                            strokeWidth: 3.5,
                            color: Theme.of(context).colorScheme.secondary))
                    : Text(
                        style: bigValueIntStyle(context, bigValue),
                        '$bigValue сек'),
              ],
            ),
          ]),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              style: descStyle(context),
              'Режим опроса устройств:\nожидание ответа (рекурсивный)\nслепой опрос (интервальный)'),
          TextButton(
            onPressed: () {
              state('scanMode', !scanMode);
            },
            child: Text(
                textAlign: TextAlign.end,
                style: descButton(context),
                modeScanner),
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
                  setInterval('min');
                },
                child: Row(children: [
                  const Icon(
                    // CupertinoIcons.minus_rectangle,
                    CupertinoIcons.hare,
                    size: 18,
                  ),
                  Text(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                      '  Уменьшить'),
                ]),
              ),
              ElevatedButton(
                onPressed: () {
                  setInterval('plus');
                },
                child: Row(children: [
                  const Icon(
                    // CupertinoIcons.plus_rectangle,
                    CupertinoIcons.tortoise,
                    size: 18,
                  ),
                  Text(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                      '  Увеличить'),
                ]),
              )
            ],
          ),
        ],
      ),
    ],
  );
}
