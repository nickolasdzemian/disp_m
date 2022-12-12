import 'package:local_notifier/local_notifier.dart';
import 'package:neptun_m/lib/push.dart';
import 'dart:io';

void showErrPush(String txt) {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    LocalNotification notification = LocalNotification(
      title: "Предупреждение системы Neptun",
      body: txt,
    );
    notification.show();
  } else if (Platform.isAndroid || Platform.isIOS) {
    showNotification("Предупреждение системы Neptun", txt);
  }
}
