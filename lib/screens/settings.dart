import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:neptun_m/connect/scan.dart';
import 'package:neptun_m/lib/getters.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:neptun_m/db/db.dart';
import 'package:neptun_m/info/help.dart';
import 'package:neptun_m/screens/assets.dart';
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
    setState(() {
      found = newall.length;
    });
  }

  void addDevices() async {
    if (!_adding) {
      setState(() {
        _adding = true;
      });
      stopTimer();
      await Scan.getAllDevices([], setCount);
      setState(() {
        _adding = false;
      });
    }
  }

  void addDevice() async {
    _dialogBuilder(context, all, formKey, setCount);
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatesModel, List>(
        buildWhen: (previousState, state) {
          return previousState != state;
        },
        builder: (context, devicesStatesNew) => Center(
                child: Scaffold(
              appBar: settingsAppBar(context, themeMode, changeTheme),
              body: Column(children: [
                Wrap(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  children: [
                    settingsBoxView(
                        context,
                        settingsBoxAdd(context, found, addDevices, _adding,
                            addDevice, helpTitle, connectHelp, _dialogHelp)),
                    settingsBoxView(
                        context,
                        settingsAutoInterval(
                            context, interval, setInterval, _adding)),
                  ],
                ),
                settingsBoxWide(
                    context,
                    settingsOther(context, autoScan, server, serverPort,
                        notifications, reserved, updates, state)),
              ]),
              floatingActionButton: FloatingActionButton(
                onPressed: (() {
                  // _increment();
                }),
                tooltip: 'Increment',
                child: const Icon(Icons.account_tree_rounded),
              ),
            )));
  }
}
