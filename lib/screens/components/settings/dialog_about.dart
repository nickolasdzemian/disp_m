part of '../../settings.dart';

String appName = '';
String packageName = '';
String version = '';
String buildNumber = '';
aboutInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  appName = packageInfo.appName;
  packageName = packageInfo.packageName;
  version = packageInfo.version;
  buildNumber = packageInfo.buildNumber;
}

Future<void> _dialogAbout(context) async {
  await aboutInfo();
  Future<AudioPlayer> playCat() async {
    AudioCache cache = AudioCache();
    return await cache.play("/audios/Cat.mp3");
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
        content: SizedBox(
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
                        Text('ZP ${version == '' ? 'нет данных' : version}'),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(style: subTitleStyle(context), 'Номер сборки:'),
                        Text(buildNumber == '' ? 'нет данных' : buildNumber),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(style: subTitleStyle(context), 'Разработчик:\n'),
                        const Text(
                            textAlign: TextAlign.right,
                            'Николай Поздняков\nГруппа Теплолюкс'),
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
                ])),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Закрыть'),
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
                'Проверить обновления'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
