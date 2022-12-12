part of '../../settings.dart';

// Platform.isWindows || Platform.isLinux || Platform.isMacOS
final Uri _url = Uri.parse(Platform.isWindows
    ? resp.versionUrlWin
    : Platform.isLinux
        ? resp.versionUrlDeb
        : Platform.isMacOS
            ? resp.versionUrlMac
            : resp.versionUrl);
Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}

Future<void> _dialogAbout(context, update, appName, packageName, version,
    buildNumber, newVersion) async {
  await newVersion();

  AudioInApp audioInApp = AudioInApp();
  AudioPlayer player = AudioPlayer();
  Future playCat() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await player.play(AssetSource('audios/NeptunCat.mp3'));
    } else if (Platform.isLinux) {
      // LINUX ONLY
      // await shell.run(
      //     'ffplay -nodisp -autoexit $appDataDirectory/Sounds/NeptunCat.mp3');
    } else {
      await audioInApp.createNewAudioCache(
          playerId: 'cat',
          route: 'audios/NeptunCat.mp3',
          audioInAppType: AudioInAppType.determined);
      await audioInApp.play(playerId: 'cat');
    }
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext contextAbout) {
      return AlertDialog(
        alignment: Alignment.topRight,
        title: Row(children: [
          Icon(
              color: Theme.of(context).colorScheme.secondary,
              CupertinoIcons.info),
          const Text('  О приложении')
        ]),
        content: SingleChildScrollView(
            child: SizedBox(
                width: 400,
                height: 450,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onDoubleTap: () {
                            playCat();
                          },
                          splashColor: Colors.white10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(AppImages.dashLand),
                          )),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                style: subTitleStyle(context),
                                'Версия приложения:'),
                            Text(
                                'Common ${version == '' ? 'нет данных' : version}'),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                style: subTitleStyle(context), 'Номер сборки:'),
                            Text(
                                buildNumber == '' ? 'нет данных' : buildNumber),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                style: subTitleStyle(context),
                                'Разработчик:\n'),
                            const Text(
                                textAlign: TextAlign.right,
                                'Николай Поздняков'),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                style: subTitleStyle(context),
                                'Расположение\nхранилища:'),
                            Flexible(
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 25),
                                    child: SelectableText(
                                        textAlign: TextAlign.right,
                                        appDataDirectory == ''
                                            ? 'нет данных'
                                            : appDataDirectory))),
                          ])
                    ]))),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Text(
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                    'Сброс и очистка'),
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        duration: const Duration(seconds: 15),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        content: const Text(
                            'Нажмите и удерживайте красную кнопку для сброса всех настроек и удаления всех данных\nЭто действие невозможно отменить! Для возобновления работы системы потребуется повторная настройка и конфигурация!')),
                  );
                },
                // *** RESET AND DELETE ***
                onLongPress: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        duration: const Duration(seconds: 10),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        content: const Text(
                            'Внимание! Все данные удалены!\nДля завершения сброса приложение будет закрыто, дождитесь его остановки или перезапустите для отмены операции')),
                  );
                  Future.delayed(const Duration(seconds: 3), () async {
                    // Avoid closing boxes because of timeout err state
                    // final dir = Directory(appDataDirectory);
                    // dir.deleteSync(recursive: true);
                    await devices.clear();
                    await settings.clear();
                    await events.clear();
                    await climits.clear();
                    await cstats.clear();
                    await plan.clear();

                    // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    // Fix Windows call

                    await Hive.deleteFromDisk();
                    exit(0);
                  });
                },
              ),
              Row(children: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Закрыть'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                MediaQuery.of(context).size.width > 800
                    ? TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: Text(
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                            '$update'),
                        onPressed: () {
                          update != 'Обновлений нет'
                              ? _launchUrl()
                              : Navigator.of(context).pop();
                        },
                      )
                    : const SizedBox()
              ]),
            ],
          )
        ],
      );
    },
  );
}
