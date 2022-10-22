import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:neptun_m/lib/err_push.dart';

class Meta {
  final String notification;
  final String support;
  final String version;
  final String versionUrl;

  const Meta({
    required this.notification,
    required this.support,
    required this.version,
    required this.versionUrl,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      notification: json['notification'],
      support: json['support'],
      version: json['version'],
      versionUrl: json['versionUrl'],
    );
  }
}

var resp;

Future getRemoteConfig() async {
  final bool result = await InternetConnectionChecker().hasConnection;
  if (result == true) {
    try {
      final response =
          await http.get(Uri.parse('http://teploluxe.host/disp/ZA/check.json'));
      resp = Meta.fromJson(jsonDecode(response.body));
      // inspect(resp);
    } catch (e) {
      showErrPush('Ошибка проверки обновлений\n${e.toString()}');
    }
  } else {
    showErrPush(
        'Отсутствует подключение к сети Интернет для проверки обновлений');
  }
}
