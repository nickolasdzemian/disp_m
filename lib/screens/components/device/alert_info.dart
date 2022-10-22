part of '../../device.dart';

const type1txt =
    '''Обратите внимание, что после переключения настройки рекомендуется немного подождать, т.к. система будет ожидать результата применения новой конфигурации и обновления параметров.
Большинство параметров и настроек применяются на устройстве сразу.
Система диспетчеризации осуществляет связь с приборами в режиме реального времени для исключения ошибок и дезинформации оператора.
Незначительные задержки при обмене данными допустимы, а время ожидания, как правило, зависит от нагруженности сети.
Для отображения актуальной информации после выхода из текущего меню необходимо дождаться завершения цикла опроса!''';
const type2txt =
    '''Обратите внимание, что в настоящий момент устройство не на связи. Конфигурация такого устройства ограничена.
Для возможности полноценной настройки и конфигурирования, статус устройства на главном экране при входе в данное меню должен отображаться как 'на связи' ''';

Future<void> _alertBuilder(context, state, type, isThisFirstRun) {
  String title = 'Важная информация';
  SystemSound.play(SystemSoundType.alert);

  return showDialog<void>(
    context: context,
    builder: (BuildContext contextBase) {
      return AlertDialog(
        alignment: Alignment.center,
        title: Row(children: [
          Icon(
              color: Theme.of(context).colorScheme.error,
              CupertinoIcons.bookmark),
          Text('   $title')
        ]),
        content: SizedBox(
            width: 450, child: Text(type == 1 && state ? type1txt : type2txt)),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Больше не показывать'),
            onPressed: () async {
              if (type == 1) {
                isThisFirstRun[1] = false;
                await settings.put('firstStart', isThisFirstRun);
              } else if (type == 2) {
                isThisFirstRun[2] = false;
                await settings.put('firstStart', isThisFirstRun);
              }
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                'ОК'),
          ),
        ],
      );
    },
  );
}
