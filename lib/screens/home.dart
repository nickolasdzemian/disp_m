import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neptun_m/screens/assets.dart';
import 'package:neptun_m/lib/getters.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderable_grid/reorderable_grid.dart';
import 'package:neptun_m/db/db.dart';
import 'package:neptun_m/lib/remote_config.dart';
import 'package:neptun_m/rebuilder.dart';
import 'package:neptun_m/lib/setters.dart';
import 'package:neptun_m/screens/device.dart';
import 'package:badges/badges.dart';

import 'dart:io';
// import 'package:just_audio/just_audio.dart';
import 'package:audio_in_app/audio_in_app.dart';

import 'package:blinking_text/blinking_text.dart';
import 'package:local_notifier/local_notifier.dart';

part 'components/home_appbar.dart';
part 'components/home/box.dart';
part 'components/home/box_reorder.dart';
part 'components/home/device_item.dart';
part 'components/home/device_item_reorder.dart';
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

class _HomePage extends State<HomePage> {
  Key key = UniqueKey();
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
    await DataBase.reorder(items);
    return setState(() {
      items = allDevicesDb();
      reorderTriggered = true;
    });
  }

  @override
  void initState() {
    super.initState();
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
  }

  void started() {
    if (allDevicesDb().isNotEmpty && !run) {
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatesModel, List>(
      buildWhen: (previousState, state) {
        return previousState != state || run;
      },
      builder: (context, devicesStatesNewHome) {
        void closeThisAlert() {
          Navigator.of(context).pop();
        }

        // inspect(devicesStatesNewHome);

        checkAlarms(devicesStatesNewHome, context, setAlarmsArrState, alarms,
            alarmsLength, closeThisAlert, setThisHistory);

        return Scaffold(
            appBar: homeAppBar(
                context, started, initHistory, thisHistory, resetThisHistory),
            body: allDevicesDb().isNotEmpty && reorderMe
                ? ReorderableGridView.extent(
                    onReorder: (oldIndex, newIndex) =>
                        {onReorder(oldIndex, newIndex)},
                    maxCrossAxisExtent: 350,
                    semanticChildCount: items.length,
                    children: allDevicesDb().map((item) {
                      return deviceReorderBoxView(
                          context, item, deviceItemReorder(context, item));
                    }).toList())
                : allDevicesDb().isNotEmpty &&
                        devicesStatesNewHome.isNotEmpty &&
                        !reorderMe
                    ? GridView.extent(
                        maxCrossAxisExtent: 350,
                        children: devicesStatesNewHome.map((item) {
                          return deviceItemBoxView(
                              context,
                              item,
                              ItemWidget(
                                  item: item,
                                  itemDb: items[item.index],
                                  close: closeThisAlert));
                        }).toList())
                    : allDevicesDb().isNotEmpty && devicesStatesNewHome.isEmpty
                        ? Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                      strokeWidth: 5,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  Text(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    '\nИдет загрузка и первичный опрос, ожидайте\nИнициализация займет примерно $firstTimerInfo сек',
                                  ),
                                ]),
                          )
                        : error
                            ? Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                        'Возникла непредвиденная ошибка, необходимо перезапустить приложение',
                                      ),
                                    ]),
                              )
                            : Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                        'Нет добавленных устройств',
                                      ),
                                    ]),
                              ),
            floatingActionButton:
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              FloatingActionButton(
                heroTag: "btn2",
                onPressed: () async {
                  stopPlayArlam = true;
                  await alertInApp.stop(playerId: 'alarm');
                  await alertInApp.removeAudio('alarm');
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
                tooltip: reorderMe
                    ? 'Применить и вернуться'
                    : 'Изменить порядок отображения',
                child: Icon(reorderMe
                    ? CupertinoIcons.arrow_merge
                    : CupertinoIcons.arrow_left_right),
              ),
            ]));
      },
    );
  }
}
