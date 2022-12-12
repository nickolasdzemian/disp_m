// import 'dart:developer';
// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:neptun_m/db/db.dart';
import 'package:neptun_m/lib/models.dart';
import 'package:neptun_m/lib/getters.dart';
import 'package:neptun_m/lib/setters.dart';
import 'package:flutter/services.dart';
import 'package:neptun_m/rebuilder.dart';

part '../screens/components/device/device_bar.dart';
part '../screens/components/device/box_wide.dart';
part 'components/device/base.dart';
part 'components/styles/device.dart';
part 'components/device/edit_functions.dart';
part 'components/device/edit_dialog.dart';
part 'components/device/main.dart';
part 'components/device/lines.dart';
part 'components/device/edit_dialog_lines.dart';
part 'components/device/edit_dialog_relay.dart';
part '../screens/components/device/box_radio.dart';
part 'components/device/radio.dart';
part 'components/device/edit_dialog_radio.dart';
part 'components/device/delete_dialog.dart';
part 'components/device/edit_dialog_cswitch.dart';
part 'components/device/counters.dart';

part 'components/device/alert_info.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  DeviceWidgetState createState() => DeviceWidgetState();
}

class DeviceWidgetState extends State<DeviceScreen> {
  List oneDeviceParams = [];
  List oneDeviceStates = [];
  List oneDeviceCounters = [];
  List oneDeviceCountersParams = [];
  bool setInProgress = false;
  final formKey = GlobalKey<FormState>();
  List isThisFirstRun = settings.get('firstStart');
  bool preventAlert = false;
  var item;

  void updateItemDb() {
    setState(() {});
  }

  void updateOneDeviceStates(ind, v) {
    setState(() {
      oneDeviceStates[ind] = v;
      item.registersStates[ind] = v;
    });
  }

  void updateOneParamStates(ind, v) {
    setState(() {
      oneDeviceParams[ind] = v;
    });
  }

  void updateoneDeviceCounters(ind, v) {
    setState(() {
      oneDeviceCounters[ind] = v;
      item.countersStates[ind] = v;
    });
  }

  void updateoneDeviceCountersParams(ind, v) {
    setState(() {
      oneDeviceCountersParams[ind] = v;
      // item.countersParams[ind] = v;
    });
  }

  void showInfo(state) {
    if (isThisFirstRun[1] && mounted && !preventAlert && state) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        preventAlert = true;
        _alertBuilder(context, state, 1, isThisFirstRun);
      });
    } else if (isThisFirstRun[2] && mounted && !preventAlert && !state) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        preventAlert = true;
        _alertBuilder(context, state, 2, isThisFirstRun);
      });
    }
  }

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool checkedRadio = false;
  void checkRadio() {
    String reg0 = oneDeviceStates[0].value;
    bool addNewRadio = reg0.substring(24, 25) == '1';
    if (!addNewRadio) {
      setState(() {
        checkedRadio = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)!.settings.arguments as DeviceNavArguments;
    var itemDb = data.itemDb;
    item = data.item;
    itemDb = allDevicesDb()[itemDb.index];

    Duration safe = Duration(milliseconds: thisIDX == item.index ? 750 : 1);
    Duration loadable = Duration(
        milliseconds: thisIDX == item.index
            ? 750
            : _timer?.tick != null
                ? 1
                : 1500);

    void getAdditionalParams(bool retouch) async {
      retouch && mounted
          ? setState(() {
              oneDeviceParams = [];
              oneDeviceStates = [];
              oneDeviceCounters = [];
              oneDeviceCountersParams = [];
            })
          : null;
      if (item.state && mounted) {
        Future.delayed(safe, () async {
          var oneDeviceStateLoad = await getOneDevice(data.itemDb);
          if (oneDeviceStateLoad[0]) {
            Future.delayed(loadable, () {
              if (mounted) {
                setState(() {
                  oneDeviceParams = oneDeviceStateLoad[1].radioParams;
                  oneDeviceStates = oneDeviceStateLoad[1].registersStates;
                  oneDeviceCounters = oneDeviceStateLoad[1].countersStates;
                  oneDeviceCountersParams =
                      oneDeviceStateLoad[1].countersParams;
                });
                if (_timer?.tick != null) checkRadio();
              }
            });
          } else {
            Future.delayed(loadable, () {
              getAdditionalParams(false);
            });
          }
        });
      }
    }

    void periodicUpdate(v) {
      _timer?.cancel();
      _timer = Timer.periodic(
        const Duration(seconds: 5),
        (Timer timer) {
          if (!v || checkedRadio) {
            setState(() {
              timer.cancel();
              checkedRadio = false;
            });
          } else {
            getAdditionalParams(false);
          }
        },
      );
    }

    if (oneDeviceParams.isEmpty) {
      getAdditionalParams(false);
    }

    showInfo(item.state);

    return Scaffold(
        appBar: deviceAppBar(context, _timer),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  paramsBoxWide(
                      context,
                      220,
                      settingsBase(
                          context, itemDb, formKey, updateItemDb, item.state)),
                  item.state &&
                          (oneDeviceParams.isEmpty || oneDeviceStates.isEmpty)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              const SizedBox(height: 25),
                              CircularProgressIndicator(
                                  strokeWidth: 5,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              Text(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                '\nИдет загрузка параметров, ожидайте',
                              ),
                            ])
                      : item.state && oneDeviceParams.isNotEmpty
                          ? Column(children: [
                              paramsBoxWide(
                                  context,
                                  300,
                                  settingsMain(
                                      context,
                                      itemDb,
                                      oneDeviceStates,
                                      formKey,
                                      updateOneDeviceStates,
                                      periodicUpdate)),
                              paramsBoxWide(
                                  context,
                                  285,
                                  settingsLines(
                                      context,
                                      itemDb,
                                      oneDeviceStates,
                                      formKey,
                                      updateOneDeviceStates,
                                      updateItemDb,
                                      item.state,
                                      getAdditionalParams)),
                              paramsBoxRadio(
                                  context,
                                  settingsCounters(
                                      context,
                                      itemDb,
                                      oneDeviceCounters,
                                      oneDeviceCountersParams,
                                      formKey,
                                      updateoneDeviceCounters,
                                      updateoneDeviceCountersParams,
                                      updateItemDb,
                                      getAdditionalParams)),
                              paramsBoxRadio(
                                  context,
                                  settingsRadio(
                                      context,
                                      itemDb,
                                      oneDeviceStates,
                                      oneDeviceParams,
                                      formKey,
                                      updateOneParamStates,
                                      updateItemDb,
                                      getAdditionalParams)),
                              const SizedBox(height: 75),
                            ])
                          : Text(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                              '\n\nУстройство не в сети,\nпопробуйте открыть меню конфигурации позже',
                            ),
                ],
              ),
            )));
  }
}

class DeviceNavArguments {
  final DeviceState item;
  final Device itemDb;

  DeviceNavArguments(this.item, this.itemDb);
}
