import 'package:local_notifier/local_notifier.dart';
import 'dart:io';

void showErrPush(String txt) {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    LocalNotification notification = LocalNotification(
      title: "Предупреждение системы Neptun",
      body: txt,
    );
    notification.show();
  }
}
