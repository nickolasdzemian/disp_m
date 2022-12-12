part of './getters.dart';

/// Stops request periodic timer
/// - global function for resetting without BLOC provider
void globalStopTimer() {
  run = false;
  statusDispTop = '- ОСТАНОВЛЕНА';
  setWindowTitleState();
  _timer?.cancel();
  registersStates = [];
  devicesStates = [];
  devicesStatesNew = [];
  deviceParamsTemp = [];
  SystemSound.play(SystemSoundType.alert);
  DataBase.updateEventList([
    4,
    'Опрос остановлен',
    'Выполнена остановка периодического опроса устройств. Обновление состояния не производится',
  ]);
}

emergencyRestart() async {
  String app = 'neptun_m';
  await closeAllDb();
  if (Platform.isMacOS) {
    await shell.run('bash -c "killall -9 $app && sleep 2 && open -a $app"');
    // await shell.run('sleep 1\nopen -a $app');
    // Process.killPid(pid);
    // await shell.run('killall -9 $app');
  } else if (Platform.isLinux) {
    await shell.run('bash -c "killall -9 $app && sleep 2 && $app"');
    // Process.killPid(pid);
    // await shell.run('killall -9 $app');
  } else if (Platform.isWindows) {
    await shell.run('''delayexec neptun_m.exe 2''');
    Process.killPid(pid);
  } else if (Platform.isAndroid) {
    Restart.restartApp();
  }
}

void errorStopper(e) {
  run = false;
  statusDispTop = '- ОШИБКА';
  setWindowTitleState();
  errr = true;
  showErrPush(
      'Возникла непредвиденная ошибка! Требуется перезапуск!\n${e.toString()}');
  DataBase.updateEventList([
    4,
    'Возникла непредвиденная ошибка, требуется перезапуск',
    e.toString(),
  ]);
  emergencyRestart();
}

void setWindowTitleState() {
  // .........................................................................
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    windowManager
        .setTitle('Система диспетчеризации Neptun Smart $statusDispTop');
  }
  // .........................................................................
}
