part of '../../home.dart';

Center _countdown(firstTimerInfo, context, devicesStatesNewHome) {
  return Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CircularCountDownTimer(
        duration: firstTimerInfo * 2,
        initialDuration: 0,
        controller: CountDownController(),
        width: 90,
        height: 90,
        ringColor: Theme.of(context).colorScheme.background,
        fillColor: Theme.of(context).colorScheme.secondary,
        strokeWidth: 10.0,
        strokeCap: StrokeCap.round,
        textStyle: TextStyle(
            fontSize: (firstTimerInfo * 2) > 99 ? 20 : 30,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold),
        textFormat: CountdownTextFormat.S,
        isReverse: true,
        isReverseAnimation: true,
        isTimerTextShown: true,
        autoStart: true,
        onComplete: () async {
          if (allDevicesDb().isNotEmpty && devicesStatesNewHome.isEmpty) {
            stopPlayArlam = true;
            await alertInApp.stop(playerId: 'alarm');
            await alertInApp.removeAudio('alarm');
            // LINUX ONLY
            // await shell.run('killall ffplay');
            globalStopTimer();
            Rebuilder.of(context)?.rebuild();
          }
        },
      ),
      // CircularProgressIndicator(
      //     strokeWidth: 5,
      //     color: Theme.of(context)
      //         .colorScheme
      //         .secondary),
      Text(
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        '\nИдет загрузка и первичный опрос, ожидайте',
      ),
    ]),
  );
}

Future<void> popupSearch(context, setFilter) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext contextBase) {
      return AlertDialog(
        alignment: Alignment.bottomCenter,
        content: SizedBox(
            width: 275,
            height: 80,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Начните вводить имя',
              ),
              onChanged: (value) => {setFilter(value.toLowerCase())},
              initialValue: '',
            )),
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
            onPressed: () {
              setFilter('');
              Navigator.of(context).pop();
            },
            child: const Text('Сбросить'),
          ),
        ],
      );
    },
  );
}

Row floatingActionBtns(
    reorderSwitch, context, reorderMe, setFilter, filtered, filter) {
  return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
    Badge(
        badgeContent: Text(
            style: TextStyle(
                color: Theme.of(context).colorScheme.onError, fontSize: 20),
            '$filtered'),
        badgeColor: Theme.of(context).colorScheme.tertiary,
        position: BadgePosition.topStart(),
        showBadge: filter != '',
        child: FloatingActionButton(
          heroTag: "btnSearch",
          onPressed: () {
            popupSearch(context, setFilter);
          },
          isExtended: true,
          tooltip: 'Поиск по имени устройства',
          child: Icon(
              color: Theme.of(context).colorScheme.secondary,
              CupertinoIcons.search),
        )),
    const SizedBox(height: 15, width: 20),
    FloatingActionButton(
      heroTag: "btn2",
      onPressed: () async {
        stopPlayArlam = true;
        await alertInApp.stop(playerId: 'alarm');
        await alertInApp.removeAudio('alarm');
        await alertPlayer.stop();
        // LINUX ONLY
        // await shell.run('killall ffplay');
      },
      isExtended: true,
      tooltip: 'Принудительно отключить звук тревоги',
      child: const Icon(CupertinoIcons.volume_mute),
    ),
    const SizedBox(height: 15, width: 15),
    FloatingActionButton(
      heroTag: "btn1",
      onPressed: () {
        reorderSwitch(context);
      },
      isExtended: true,
      tooltip:
          reorderMe ? 'Применить и вернуться' : 'Изменить порядок отображения',
      child: Icon(reorderMe
          ? CupertinoIcons.arrow_merge
          : CupertinoIcons.arrow_left_right),
    ),
    const SizedBox(height: 15, width: 15),
    FloatingActionButton(
      heroTag: "btn3",
      onPressed: (() async {
        stopPlayArlam = true;
        await alertInApp.stop(playerId: 'alarm');
        await alertInApp.removeAudio('alarm');
        // LINUX ONLY
        // await shell.run('killall ffplay');
        run = false;
        globalStopTimer();
        Rebuilder.of(context)?.rebuild();
      }),
      tooltip: 'Перезапустить опрос устройств и\nоболочку приложения',
      child: Icon(
          color: Theme.of(context).colorScheme.error, CupertinoIcons.restart),
    ),
  ]);
}

Center errmsg(context) {
  return Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
        'Возникла непредвиденная ошибка, необходимо перезапустить приложение',
      ),
    ]),
  );
}

Center nodevs(context, filter) {
  return Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
        filter == ''
            ? 'Нет добавленных устройств'
            : 'Нет результатов\nпо заданным критериям поиска',
      ),
    ]),
  );
}
