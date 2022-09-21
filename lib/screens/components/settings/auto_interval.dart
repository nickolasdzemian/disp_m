part of '../../settings.dart';

Column settingsAutoInterval(context, bigValue, setInterval, adding) {
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
              'Частота опроса устройств в секундах.\nПоддерживаемый диапазон от 1 до 100'),
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
