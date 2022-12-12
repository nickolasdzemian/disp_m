part of '../../settings.dart';

Future<void> _dialogServe(context, state) async {
  int newPort = int.parse(userport);
  String verApi = resp != null ? resp.versionApi : 'v1.0';

  return showDialog<void>(
    context: context,
    builder: (BuildContext contextAbout) {
      return AlertDialog(
        alignment: Alignment.center,
        title: Row(children: [
          Icon(
              color: Theme.of(context).colorScheme.secondary,
              CupertinoIcons.info),
          const Text('  Локальный сервер')
        ]),
        content: SingleChildScrollView(
            child: SizedBox(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Row(children: [
                            Icon(
                                color: Theme.of(context).colorScheme.secondary,
                                CupertinoIcons.desktopcomputer),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      style: subTitleStyle(context),
                                      text: '  $api',
                                    ),
                                  ),
                                  Text(
                                      style: descStyle(context),
                                      '   Адрес локального сервера')
                                ])
                          ])
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
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
                                      text: '  Кол-во обращений: $requestCount',
                                    ),
                                  ),
                                  Text(
                                      style: descStyle(context),
                                      '   Общее кол-во запросов')
                                ])
                          ])
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                      text: '  Выбор порта сервера',
                                    ),
                                  ),
                                  Text(
                                      style: descStyle(context),
                                      '   Настройка произвольного порта')
                                ])
                          ]),
                          SizedBox(
                            width: 210,
                            height: 85,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Порт',
                              ),
                              onChanged: (value) => {
                                newPort =
                                    value.isNotEmpty ? int.parse(value) : 0,
                              },
                              initialValue: newPort.toString(),
                              validator: (String? value) {
                                int va =
                                    value!.isNotEmpty ? int.parse(value) : 0;
                                return (value.length < 5 &&
                                        value.isNotEmpty &&
                                        va > 10)
                                    ? null
                                    : 'Неверное значение';
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    CupertinoIcons.book),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          style: subTitleStyle(context),
                                          text: '  Описание',
                                        ),
                                      ),
                                      Text(
                                          style: descStyle(context),
                                          '   Доступно в коллекции Postman по ссылке:'),
                                      SizedBox(
                                        height: 16,
                                        child: TextButton(
                                          child: Text(
                                              style: descButton(context),
                                              'перейти'),
                                          onPressed: () async {
                                            await launchUrl(Uri.parse(
                                                'http://teploluxe.host/disp/Common/Neptun Disp. $verApi.postman_collection.json'));
                                          },
                                        ),
                                      )
                                    ]),
                              ]),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            ]))),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                'Закрыть'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                'Применить'),
            onPressed: () {
              state('serverPort', newPort);
              _diagRestart(context);
            },
          ),
        ],
      );
    },
  );
}

void _diagRestart(context) async {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text('Вы уверены в своём решении?'),
        content: const Text(
            'Опрос устройств и запись данных будут приостановлены, приложение будет перезапущено!'),
        actions: [
          TextButton(
            child: Text(
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                'Перезапуск'),
            onPressed: () {
              Navigator.of(context).pop();
              emergencyRestart();
            },
          ),
          TextButton(
            child: Text(
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                'Закрыть'),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
