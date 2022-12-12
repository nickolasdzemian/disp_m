// ignore_for_file: prefer_typing_uninitialized_variables

part of '../../home.dart';

class ItemWidget extends StatefulWidget {
  const ItemWidget(
      {super.key,
      required this.item,
      required this.itemDb,
      required this.close});
  final item;
  final itemDb;
  final close;

  @override
  ItemWidgetState createState() => ItemWidgetState();
}

class ItemWidgetState extends State<ItemWidget>
    with AutomaticKeepAliveClientMixin {
  var reg0;
  bool sendingState = false;
  String pauseAlarm = '1';
  String sendPauseAlarm = '0';
  var item;
  var name;
  bool state = false;
  String stateTxt = 'загрузка..';
  bool alarmTotal = false;
  bool multiMegaZona = false;
  bool v1 = false;
  bool v2 = false;
  bool warn = false;
  bool counterErr = false;
  bool overlimited = false;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    name = item.name;
    state = item.state;
    stateTxt = state ? 'на связи' : 'связи нет';
    alarmTotal = false;
    if (state) {
      reg0 = item?.registersStates[0];
      String alarmTotal1 = reg0?.value.substring(29, 30);
      String alarmTotal2 = reg0?.value.substring(30, 31);
      multiMegaZona = reg0?.value.substring(21, 22) == '1';
      v1 = reg0?.value.substring(23, 24) == '1';
      v2 = reg0?.value.substring(22, 23) == '1';
      bool sensorIsLost = reg0?.value.substring(27, 28) == '1';
      bool sensorIsDischarged = reg0?.value.substring(28, 29) == '1';
      if (alarmTotal1 == '1' || alarmTotal2 == '1') {
        alarmTotal = true;
      }
      if (sensorIsLost || sensorIsDischarged) {
        warn = true;
      }
      pauseAlarm = reg0?.value.substring(31, 32);
      sendPauseAlarm = pauseAlarm == '0' ? '1' : '0';

      var thisdevice = allDevicesDb()[item.index];
      bool scanCParams =
          thisdevice.cswitch.where((sp) => sp == true).toList().length > 0;
      if (scanCParams) {
        bool counter = false;
        bool overlimit = false;
        for (int cp = 0; cp < item.countersNames.length; cp++) {
          bool cstate = item.countersParams[cp].value.substring(31, 32) == '1';
          counter = item.countersParams[cp].value.substring(28, 30) != '00';
          List cc = item.countersStates[cp].value;
          num litres = cc[0] << 16 | cc[1];
          double cvalue = litres / 1000;
          List<double> limits = climits.get(thisdevice.mac);
          overlimit = limits[cp] > 0 && cvalue > limits[cp];
          if (counter && cstate) {
            counterErr = true;
          }
          if (overlimit && cstate) {
            overlimited = true;
          }
        }
      }
    }
  }

  changeSendingState() async {
    setState(() {
      sendingState = true;
    });
    var updReg = await sendOneRegister(
        reg0.value, 31, sendPauseAlarm, 1, 0, widget.itemDb);
    if (updReg[0] && updReg[1] != null && mounted) {
      setState(() {
        reg0 = updReg[1];
        pauseAlarm = updReg[1].value.substring(31, 32);
        sendPauseAlarm = pauseAlarm == '0' ? '1' : '0';
        // sendingState = false;
      });
      if (devicesStates.length > item.index) {
        devicesStates[item.index].registersStates[updReg[1].adrr] = updReg[1];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              duration: const Duration(seconds: 3),
              backgroundColor: CupertinoColors.systemGreen.withOpacity(0.6),
              content: const Text(
                  'Настройки успешно применены, статус обновится в течение нескольких секунд')),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).colorScheme.error,
            content: const Text('Режим не изменен, попробуйте еще раз')),
      );
      SystemSound.play(SystemSoundType.alert);
    }
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          sendingState = false;
        });
      }
    });
  }

  Future<void> vulgarna(int idx, int len, val) async {
    if (state) {
      var updReg =
          await sendOneRegister(reg0.value, idx, val, len, 0, widget.itemDb);
      if (updReg[0] && updReg[1] != null && mounted) {
        setState(() {
          reg0 = updReg[1];
          v1 = reg0?.value.substring(23, 24) == '1';
          v2 = reg0?.value.substring(22, 23) == '1';
        });
        if (devicesStates.length > item.index) {
          devicesStates[item.index].registersStates[updReg[1].adrr] = updReg[1];
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: CupertinoColors.systemGreen.withOpacity(0.6),
                content: Text(
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    'Настройки успешно применены, статус обновится в течение нескольких секунд')),
          );
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              duration: const Duration(seconds: 2),
              backgroundColor: Theme.of(context).colorScheme.error,
              content: const Text('Состояние не изменено, попробуйте еще раз')),
        );
        SystemSound.play(SystemSoundType.alert);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool wsize = MediaQuery.of(context).size.width > 800;
    return Column(
        key: UniqueKey(),
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.deviceImg,
                      width: 80,
                      height: 65,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: titleStyle(context),
                            text: 'Состояние: ',
                            children: <TextSpan>[
                              TextSpan(
                                  text: stateTxt,
                                  style: TextStyle(
                                      color: state
                                          ? Colors.greenAccent
                                          : Colors.red)),
                            ],
                          ),
                        ),
                        Text(style: subTitleStyle(context), '$name'),
                        Text(
                            style: descStyle(context),
                            'IP-адрес: ${widget.itemDb.ip}'),
                        Text(
                            style: descStyle(context),
                            'Mac-адрес: ${widget.itemDb.mac}'),
                      ],
                    ),
                  ]),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 35,
                        child: IconButton(
                          iconSize: 25,
                          icon: Icon(
                            CupertinoIcons.slider_horizontal_3,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          tooltip: 'Конфигурация',
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/device',
                              arguments: DeviceNavArguments(widget.item,
                                  allDevicesDb()[widget.itemDb.index]),
                            );
                          },
                        )),
                    const SizedBox(height: 8),
                    !sendingState
                        ? SizedBox(
                            height: 33,
                            child: IconButton(
                              iconSize: 23,
                              enableFeedback: true,
                              icon: Icon(
                                pauseAlarm == '0'
                                    ? CupertinoIcons.bell
                                    : CupertinoIcons.bell_slash,
                                color: pauseAlarm == '0'
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).colorScheme.primary,
                              ),
                              tooltip: state && pauseAlarm == '0'
                                  ? 'ВЫКЛючить реагирование по тревоге\nна 30 минут'
                                  : state && pauseAlarm == '1'
                                      ? 'ВКЛючить реагирование по тревоге'
                                      : null,
                              onPressed: () {
                                if (state) {
                                  changeSendingState();
                                }
                              },
                            ))
                        : SizedBox(
                            width: 23,
                            height: 23,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                  ]),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: wsize ? 37 : 17),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      style: subTitleStyle(context),
                      text: 'Тревога: ',
                      children: <TextSpan>[
                        TextSpan(
                            text: state
                                ? (!alarmTotal &&
                                        !warn &&
                                        !counterErr &&
                                        !overlimited
                                    ? 'нет'
                                    : warn || overlimited
                                        ? 'предупреждение'
                                        : 'ТРЕВОГА')
                                : '--',
                            style: TextStyle(
                                color: state
                                    ? (!alarmTotal &&
                                            !warn &&
                                            !counterErr &&
                                            !overlimited
                                        ? Colors.greenAccent
                                        : warn || overlimited
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Colors.red)
                                    : Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                  ),
                  alarmTotal || warn || counterErr || overlimited
                      ? IconButton(
                          icon: Icon(
                            CupertinoIcons.bubble_left,
                            size: 23,
                            color: alarmTotal || counterErr
                                ? Colors.red
                                : Theme.of(context).colorScheme.secondary,
                          ),
                          tooltip: 'Открыть',
                          onPressed: () {
                            stopPlayArlam = true;
                            _alertBuilderAlarm(
                                context, [item], widget.close, true);
                          },
                        )
                      : const SizedBox(),
                ],
              ),
              const SizedBox(height: 10),
              !multiMegaZona
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          style: subTitleStyle(context),
                          'Краны: ',
                        ),
                        Transform.scale(
                            scale: 0.65,
                            child: CupertinoSwitch(
                              value: v1,
                              thumbColor: CupertinoColors.white,
                              trackColor:
                                  CupertinoColors.inactiveGray.withOpacity(0.4),
                              activeColor:
                                  CupertinoColors.systemGreen.withOpacity(0.6),
                              onChanged: (bool? value) {
                                vulgarna(22, 2, v1 ? '00' : '11');
                              },
                            )),
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              style: subTitleStyle(context),
                              'Краны ${item.zones[0]}: ',
                            ),
                            Transform.scale(
                                scale: 0.65,
                                child: CupertinoSwitch(
                                  value: v1,
                                  thumbColor: CupertinoColors.white,
                                  trackColor: CupertinoColors.inactiveGray
                                      .withOpacity(0.4),
                                  activeColor: CupertinoColors.systemGreen
                                      .withOpacity(0.6),
                                  onChanged: (bool? value) {
                                    vulgarna(23, 1, v1 ? '0' : '1');
                                  },
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              style: subTitleStyle(context),
                              'Краны ${item.zones[1]}: ',
                            ),
                            Transform.scale(
                                scale: 0.65,
                                child: CupertinoSwitch(
                                  value: v2,
                                  thumbColor: CupertinoColors.white,
                                  trackColor: CupertinoColors.inactiveGray
                                      .withOpacity(0.4),
                                  activeColor: CupertinoColors.systemGreen
                                      .withOpacity(0.6),
                                  onChanged: (bool? value) {
                                    vulgarna(22, 1, v2 ? '0' : '1');
                                  },
                                )),
                          ],
                        ),
                      ],
                    )
            ],
          ),
        ]);
  }

  @override
  bool get wantKeepAlive => false;
}
