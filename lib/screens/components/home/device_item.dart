part of '../../home.dart';

class ItemWidget extends StatefulWidget {
  const ItemWidget(
      {super.key,
      required this.item,
      required this.itemDb,
      required this.close});
  // ignore: prefer_typing_uninitialized_variables
  final item;
  final itemDb;
  final close;

  @override
  ItemWidgetState createState() => ItemWidgetState();
}

class ItemWidgetState extends State<ItemWidget>
    with AutomaticKeepAliveClientMixin {
  // ignore: prefer_typing_uninitialized_variables
  var reg0;
  bool sendingState = false;
  String pauseAlarm = '1';
  String sendPauseAlarm = '0';
  var item;
  var name;
  bool state = false;
  String stateTxt = 'загрузка..';
  bool alarmTotal = false;

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
      if (alarmTotal1 == '1' || alarmTotal2 == '1') {
        alarmTotal = true;
      }
      pauseAlarm = reg0?.value.substring(31, 32);
      sendPauseAlarm = pauseAlarm == '0' ? '1' : '0';
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
        key: UniqueKey(),
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                AppImages.deviceImg,
                width: 80,
                height: 65,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.slider_horizontal_3,
                        size: 25,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      tooltip: 'Конфигурация',
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/device',
                          arguments: DeviceNavArguments(
                              widget.item, allDevicesDb()[widget.itemDb.index]),
                        );
                      },
                    ),
                    !sendingState
                        ? IconButton(
                            icon: Icon(
                              pauseAlarm == '0'
                                  ? CupertinoIcons.bell
                                  : CupertinoIcons.bell_slash,
                              size: 20,
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
                          )
                        : SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                  ]),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  style: titleStyle(context),
                  text: '\nСостояние: ',
                  children: <TextSpan>[
                    TextSpan(
                        text: stateTxt,
                        style: TextStyle(
                            color: state ? Colors.greenAccent : Colors.red)),
                  ],
                ),
              ),
              Text(style: subTitleStyle(context), '$name'),
              Text(style: descStyle(context), 'IP-адрес: ${widget.itemDb.ip}'),
              Text(
                  style: descStyle(context), 'Mac-адрес: ${widget.itemDb.mac}'),
              Text(
                  style: descStyle(context),
                  'Радиодатчики: ${state ? item?.registersStates[6]?.value : '--'}'),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      style: subTitleStyle(context),
                      text: 'Тревога: ',
                      children: <TextSpan>[
                        TextSpan(
                            text: state
                                ? (!alarmTotal ? 'нет' : 'ТРЕВОГА')
                                : '--',
                            style: TextStyle(
                                color: state
                                    ? (!alarmTotal
                                        ? Colors.greenAccent
                                        : Colors.red)
                                    : Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                  ),
                  alarmTotal
                      ? IconButton(
                          icon: const Icon(
                            CupertinoIcons.bubble_left,
                            size: 14,
                            color: Colors.red,
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
              )
            ],
          ),
        ]);
  }

  @override
  bool get wantKeepAlive => false;
}
