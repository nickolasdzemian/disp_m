import 'dart:developer';
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

part 'components/device/alert_info.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  DeviceWidgetState createState() => DeviceWidgetState();
}

class DeviceWidgetState extends State<DeviceScreen> {
  List oneDeviceParams = [];
  List oneDeviceStates = [];
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

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)!.settings.arguments as DeviceNavArguments;
    var itemDb = data.itemDb;
    item = data.item;
    itemDb = allDevicesDb()[itemDb.index];

    void getAdditionalParams() async {
      if (item.state && mounted) {
        var oneDeviceParamsLoad = await getParams(data.itemDb);
        if (oneDeviceParamsLoad[0]) {
          setState(() {
            oneDeviceParams = oneDeviceParamsLoad[1];
            oneDeviceStates = item.registersStates;
          });
        } else {
          getAdditionalParams();
        }
      }
    }

    if (oneDeviceParams.isEmpty) {
      getAdditionalParams();
    }

    showInfo(item.state);

    return Scaffold(
        appBar: deviceAppBar(context),
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
                  item.state && oneDeviceParams.isEmpty
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
                                  settingsMain(context, itemDb, oneDeviceStates,
                                      formKey, updateOneDeviceStates)),
                              paramsBoxWide(
                                  context,
                                  222,
                                  settingsLines(
                                      context,
                                      itemDb,
                                      oneDeviceStates,
                                      formKey,
                                      updateOneDeviceStates,
                                      updateItemDb,
                                      item.state)),
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

class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}
