import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:neptun_m/connect/scan.dart';
import 'package:neptun_m/lib/getters.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:neptun_m/db/db.dart';
import 'package:neptun_m/info/help.dart';
import 'package:neptun_m/screens/assets.dart';
import 'package:neptun_m/lib/remote_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:neptun_m/rebuilder.dart';

import 'package:flutter/services.dart';
import 'dart:io';
// import 'package:just_audio/just_audio.dart';
import 'package:audio_in_app/audio_in_app.dart';

part 'components/settings/appbar.dart';
part 'components/dialog_help.dart';
part 'components/settings/box.dart';
part 'components/settings/add.dart';
part 'components/settings/add_dialog.dart';
part 'components/settings/auto_interval.dart';
part 'components/settings/box_wide.dart';
part 'components/settings/other.dart';
part 'components/settings/dialog_about.dart';
part 'components/styles/settings.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key, required this.setMode});

  final Function setMode;

  @override
  State createState() => _Settings();
}

class _Settings extends State<AppSettingsPage> {
  var all = allDevicesDb();
  var set = allSettingsDb();
  var jou = allEventsDb();

  String helpTitle = 'Информация';

  int found = devices.values.toList().length;
  bool _adding = false;
  final formKey = GlobalKey<FormState>();
  String update = 'Обновлений нет';

  bool scanMode = settings.get('scanMode');
  int interval = settings.get('interval');
  bool autoScan = settings.get('autoScan');
  bool server = settings.get('server');
  int serverPort = settings.get('serverPort');
  List notifications = settings.get('notifications');
  List reserved = settings.get('reserved');
  String updates = settings.get('updates');
  bool themeMode = settings.get('themeMode');

  void setCount() {
    var newall = allDevicesDb();
    if (mounted) {
      setState(() {
        found = newall.length;
      });
    }
  }

  void stopTimer() {
    context.read<StatesModel>().stopTimer();
  }

  void addDevices() async {
    if (!_adding) {
      setState(() {
        _adding = true;
      });
      stopTimer();
      await Scan.getAllDevices([], setCount);
      if (mounted) {
        setState(() {
          _adding = false;
        });
      }
    }
  }

  void addDevice() async {
    _dialogBuilder(context, all, formKey, setCount, stopTimer);
  }

  setInterval(a) async {
    switch (a) {
      case 'min':
        if (interval > 1 && interval <= 300) {
          setState(() {
            interval--;
          });
          await DataBase.updateOnlySetting('interval', interval);
        }
        break;
      case 'plus':
        if (interval > 0 && interval < 300) {
          setState(() {
            interval++;
          });
          await DataBase.updateOnlySetting('interval', interval);
        }
        break;
    }
  }

  void state(k, v) async {
    switch (k) {
      case 'scanMode':
        // context.read<StatesModel>().stopTimer();
        setState(() {
          scanMode = v;
        });
        break;
      case 'autoScan':
        setState(() {
          autoScan = v;
        });
        break;
      case 'server':
        setState(() {
          server = v;
        });
        break;
      case 'serverPort':
        setState(() {
          serverPort = v;
        });
        break;
      case 'notifications0':
        setState(() {
          notifications[0] = v;
        });
        k = 'notifications';
        v = notifications;
        break;
      case 'notifications1':
        setState(() {
          notifications[1] = v;
        });
        k = 'notifications';
        v = notifications;
        break;
      case 'notifications2':
        setState(() {
          notifications[2] = v;
        });
        k = 'notifications';
        v = notifications;
        break;
      case 'notifications3':
        setState(() {
          notifications[3] = v;
        });
        k = 'notifications';
        v = notifications;
        break;
      case 'reserved':
        setState(() {
          reserved = v;
        });
        break;
      case 'updates':
        setState(() {
          updates = v;
        });
        break;
    }
    await DataBase.updateOnlySetting(k, v);
  }

  void changeTheme(t) async {
    widget.setMode(t);
    setState(() {
      themeMode = t;
    });
  }

  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';
  aboutInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  newVersion() {
    aboutInfo().then((packageInfo) => {
          appName = packageInfo.appName,
          packageName = packageInfo.packageName,
          version = packageInfo.version,
          buildNumber = packageInfo.buildNumber,
          setState(() {
            if (resp != null && resp.version != version) {
              update = 'Доступна новая версия:\nнажать для загрузки';
            } else {
              update = 'Обновлений нет';
            }
          })
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => newVersion());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatesModel, List>(
        buildWhen: (previousState, state) {
          return previousState != state;
        },
        builder: (context, devicesStatesNew) => Scaffold(
              appBar: settingsAppBar(context, themeMode, changeTheme, update,
                  appName, packageName, version, buildNumber, newVersion),
              body: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Wrap(
                        children: [
                          settingsBoxView(
                              context,
                              settingsBoxAdd(
                                  context,
                                  found,
                                  addDevices,
                                  _adding,
                                  addDevice,
                                  helpTitle,
                                  connectHelp,
                                  _dialogHelp)),
                          settingsBoxView(
                              context,
                              settingsAutoInterval(context, interval,
                                  setInterval, _adding, state, scanMode)),
                        ],
                      ),
                      settingsBoxWide(
                          context,
                          settingsOther(context, autoScan, server, serverPort,
                              notifications, reserved, updates, state)),
                    ]),
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: "btn3",
                onPressed: (() {
                  run = false;
                  stopTimer();
                  Rebuilder.of(context)?.rebuild();
                  // int delay = interval + allDevicesDb().length;
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //       duration: Duration(seconds: delay),
                  //       backgroundColor: Theme.of(context).colorScheme.primary,
                  //       content: Text(
                  //           'Ожидайте, Перезапуск будет совершен через $delay сек')),
                  // );
                  // Future.delayed(Duration(seconds: delay), () {
                  //   Rebuilder.of(context)?.rebuild();
                  // });
                }),
                tooltip: 'Перезапустить опрос устройств и\nоболочку приложения',
                child: Icon(
                    color: Theme.of(context).colorScheme.error,
                    CupertinoIcons.restart),
              ),
            ));
  }
}
