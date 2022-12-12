// import 'dart:developer';
// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neptun_m/screens/assets.dart';
import 'package:neptun_m/lib/getters.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neptun_m/db/db.dart';
import 'package:neptun_m/lib/remote_config.dart';
import 'package:neptun_m/rebuilder.dart';
import 'package:neptun_m/lib/setters.dart';
import 'package:neptun_m/screens/device.dart';
import 'package:badges/badges.dart';
import 'package:neptun_m/che_guevara.dart';
import 'package:reorderables/reorderables.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:neptun_m/lib/push.dart';

import 'dart:io';
import 'package:audio_in_app/audio_in_app.dart';
import 'package:audioplayers/audioplayers.dart';
// LINUX ONLY
// import 'package:process_run/shell_run.dart' as shell;

import 'package:blinking_text/blinking_text.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:window_manager/window_manager.dart';
import 'package:permission_handler/permission_handler.dart';

part 'components/home_appbar.dart';
part 'components/home/box.dart';
part 'components/home/box_reorder.dart';
part 'components/home/device_item.dart';
part 'components/home/device_item_reorder.dart';
part 'components/home/ui_functions.dart';
part 'components/styles/home.dart';

part 'components/home/alert.dart';
part 'components/home/alert_functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_HomePage>()?.restartHome();
  }

  @override
  State createState() => _HomePage();
}

class _HomePage extends State<HomePage>
    with WindowListener, WidgetsBindingObserver {
  Key key = UniqueKey();

  Future<void> methodHandler(MethodCall call) async {
    switch (call.method) {
      case "zaloop":
        context.read<StatesModel>().slave();
        break;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    setState(() {});
    if (Platform.isAndroid) {
      const platform = MethodChannel('com.example.neptun_m/common');
      platform.setMethodCallHandler((call) => methodHandler(call));
      switch (state) {
        case AppLifecycleState.resumed:
          platform.invokeMethod('stopBackground');
          break;
        case AppLifecycleState.inactive:
          // print("app in inactive");
          break;
        case AppLifecycleState.paused:
          platform.invokeMethod(
              'startBackground', {'dura': await settings.get('interval')});
          break;
        case AppLifecycleState.detached:
          platform.invokeMethod('stopBackground');
          platform.invokeMethod('stopService');
          break;
      }
    }
  }

  void restartHome() {
    setState(() {
      key = UniqueKey();
    });
  }

  bool running = false;
  bool error = errr;

  int firstTimerInfo =
      (settings.get('interval') + (allDevicesDb().length * 3)) * 2;
  bool reorderMe = false;
  bool reorderTriggered = false;
  void reorderSwitch(context) {
    setState(() {
      reorderMe = !reorderMe;
    });
    if (!reorderMe && reorderTriggered) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            content: const Text(
                'Изменения будут применены после завершения очередного цикла опроса')),
      );
    }
  }

  var items = allDevicesDb();
  Future onReorder(int oldIndex, int newIndex) async {
    // if (oldIndex < newIndex) {
    //   newIndex -= 1;
    // }
    setState(() {
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
    equalal0 = [];
    equalal1 = [];
    await DataBase.reorder(items);
    return setState(() {
      items = allDevicesDb();
      reorderTriggered = true;
    });
  }

  Future<void> sendStartInfo() async {
    DateTime now = DateTime.now().toLocal();
    await Sentry.captureMessage(
      level: SentryLevel.info,
      'Started by User at $now',
    );
  }

  Future<void> permissions() async {
    await Permission.criticalAlerts.request();
    await Permission.ignoreBatteryOptimizations.request();
    await Permission.nearbyWifiDevices.request();
    await Permission.notification.request();
    await Permission.storage.request();
  }

  @override
  void initState() {
    windowManager.addListener(this);
    if (!Platform.isAndroid && !Platform.isIOS) {
      _init();
    }
    // sendStartInfo();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (allDevicesDb().isNotEmpty && !run) {
      equalal0 = [];
      equalal1 = [];
      run = true;
      context.read<StatesModel>().zaloop();
    }
    if (mounted) {
      setState(() {
        initHistory = allEventsDb().length;
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSmallScreen(context);
    });
    if (Platform.isAndroid) {
      permissions();
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    if (Platform.isAndroid || Platform.isIOS) {
      didReceiveLocalNotificationStream.close();
      selectNotificationStream.close();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _init() async {
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  void started() {
    if (allDevicesDb().isNotEmpty && !run) {
      equalal0 = [];
      equalal1 = [];
      run = true;
      context.read<StatesModel>().zaloop();
    }
  }

  List alarms = [];
  int alarmsLength = 0;
  void setAlarmsArrState(a, al) {
    setState(() {
      alarms = a;
      alarmsLength = al;
    });
  }

  int initHistory = 0;
  int thisHistory = 0;
  void setThisHistory() {
    if (mounted) {
      setState(() {
        thisHistory++;
      });
    }
  }

  void resetThisHistory() {
    if (mounted) {
      setState(() {
        initHistory = allEventsDb().length;
        thisHistory = 0;
      });
    }
  }

  List dialogFirstData = settings.get('firstStart');
  String filter = '';
  int filtered = 0;
  void setFilter(String f) {
    if (mounted) {
      setState(() {
        filter = f;
      });
    }
  }

  void setFiltered(v) {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          filtered = filter == '' ? 0 : v;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatesModel, List>(
      buildWhen: (previousState, state) {
        return previousState != state || run;
      },
      builder: (context, devicesStatesNewHome) {
        void closeThisAlert(bool t) {
          if (t && mounted) {
            Navigator.of(context).pop();
          } else if (mounted) {
            for (int a = 1; a < alarmTotalCount; a++) {
              Navigator.of(context).pop();
            }
          }
          alarmTotalCount = 0;
        }

        checkAlarms(devicesStatesNewHome, context, setAlarmsArrState, alarms,
            alarmsLength, closeThisAlert, setThisHistory, reorderMe);

        if (filter != '') {
          devicesStatesNewHome = devicesStatesNewHome
              .where((d) => d.name.toLowerCase().contains(filter))
              .toList();
          setFiltered(devicesStatesNewHome.length);
        }
        // inspect(devicesStatesNewHome);

        return Scaffold(
            appBar: homeAppBar(
                context, started, initHistory, thisHistory, resetThisHistory),
            body: allDevicesDb().isNotEmpty && reorderMe
                ? ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: ReorderableWrap(
                        spacing: 35,
                        runSpacing: 25,
                        padding: const EdgeInsets.all(8),
                        onReorder: (oldIndex, newIndex) =>
                            {onReorder(oldIndex, newIndex)},
                        children: allDevicesDb().map((item) {
                          return deviceReorderBoxView(
                              context, item, deviceItemReorder(context, item));
                        }).toList()))
                : allDevicesDb().isNotEmpty &&
                        devicesStatesNewHome.isNotEmpty &&
                        !reorderMe
                    ? ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                            child: Wrap(
                                spacing: 8,
                                runSpacing: 5,
                                children: devicesStatesNewHome.map((item) {
                                  return deviceItemBoxView(
                                      context,
                                      item,
                                      ItemWidget(
                                          item: item,
                                          itemDb: allDevicesDb()[item.index],
                                          close: closeThisAlert));
                                }).toList())))
                    : allDevicesDb().isNotEmpty &&
                            devicesStatesNewHome.isEmpty &&
                            filter == ''
                        ? _countdown(
                            firstTimerInfo, context, devicesStatesNewHome)
                        : error
                            ? errmsg(context)
                            : nodevs(context, filter),
            floatingActionButton: floatingActionBtns(reorderSwitch, context,
                reorderMe, setFilter, filtered, filter));
      },
    );
  }

  @override
  void onWindowClose() async {
    // ignore: no_leading_underscores_for_local_identifiers
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Вы уверены в своём решении закрыть программу?'),
            content: const Text(
                'Опрос устройств и запись данных будут остановлены, вы перестанете получать уведомления!'),
            actions: [
              TextButton(
                child: Text(
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    'Отмена'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                    'Закрыть'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  // DateTime now = DateTime.now().toLocal();
                  // await Sentry.captureMessage(
                  //   level: SentryLevel.info,
                  //   'Closed by User at $now',
                  // );
                  await closeAllDb();
                  windowManager.destroy();
                  exit(0);
                },
              ),
            ],
          );
        },
      );
    }
  }

  showSmallScreen(context) {
    bool small = MediaQuery.of(context).size.width < 801;
    bool mobile = Platform.isAndroid || Platform.isIOS;
    String smalltxt =
        'Поддержка смартфонов находится на стадии бета-тестирования. Некоторый контент может отображаться некорректно.';
    String mobiletxt =
        'Из-за ряда ограничений мобильных операционных систем для предотвращения остановки работы системы рекомендуется не сворачивать на длительное время и не закрывать приложение ';
    String text = small && mobile
        ? '$smalltxt\n$mobiletxt'
        : small
            ? smalltxt
            : mobile
                ? mobiletxt
                : '';
    if ((small || Platform.isAndroid || Platform.isIOS) && dialogFirstData[3]) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('!   Информация'),
            content: Text(text),
            actions: [
              TextButton(
                child: Text(
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    'Больше не показывать'),
                onPressed: () async {
                  dialogFirstData[3] = false;
                  DataBase.updateOnlySetting('firstStart', dialogFirstData);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                    'Закрыть'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
            ],
          );
        },
      );
    }
  }
}
