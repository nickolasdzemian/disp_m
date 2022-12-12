part of '../../device.dart';

StatefulBuilder settingsRadio(context, itemDb, oneDeviceStates, oneDeviceParams,
    formKey, updateOneParamStates, updateItemDb, getAdditionalParams) {
  bool wsize = MediaQuery.of(context).size.width > 800;
  int radioCount = oneDeviceStates[6].value;
  // StateSetter _setState;

  return StatefulBuilder(// You need this, notice the parameters below:
      builder: (BuildContext context, StateSetter setState) {
    // _setState = setState;

    void updateNewRegister(ind, res) {
      if (res[0]) {
        updateOneParamStates(ind - 7, res[1]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: const Text('Произошла ошибка, попробуйте снова')),
        );
        SystemSound.play(SystemSoundType.alert);
      }
    }

    String parceToTxt(v) {
      String res = 'Ошибка';
      String fg = itemDb.zones[0] != '' ? ': ${itemDb.zones[0]}' : '';
      String sg = itemDb.zones[1] != '' ? ': ${itemDb.zones[1]}' : '';
      String bg = (itemDb.zones[0] != '' || itemDb.zones[1] != '') && wsize
          ? ': ${itemDb.zones[0]} и ${itemDb.zones[1]}'
          : (itemDb.zones[0] != '' || itemDb.zones[1] != '') && !wsize
              ? '  ${itemDb.zones[0]}\n  ${itemDb.zones[1]}'
              : '';
      switch (v) {
        case '01':
          res = wsize ? 'I группа$fg' : 'I группа\n$fg';
          break;
        case '10':
          res = wsize ? 'II группа$sg' : 'II группа\n$sg';
          break;
        case '11':
          res = wsize ? 'I и II группа$bg' : 'I и II группа\n$bg';
          break;
      }
      return res;
    }

    List radioStateItems = [];
    // ---------------------------------------------------------------------------
    // ------------------------------ Test data-----------------------------------
    // radioCount = 8;
    // radioStateItems = [
    //   RadioFinal('Датчика', '11', 100, 4, false, false, false),
    //   RadioFinal('Датчика', '00', 80, 3, true, false, false),
    //   RadioFinal('Датчика', '10', 70, 2, false, true, false),
    //   RadioFinal('Датчика', '01', 30, 1, false, false, true),
    //   RadioFinal('Датчика', '11', 15, 0, true, true, false),
    //   RadioFinal('Датчика', '11', 5, 4, false, true, true),
    //   RadioFinal('ДатчикаДатчикаДатчика', '11', 100, 4, true, false, true),
    //   RadioFinal('Датчика', '11', 100, 4, true, true, true),
    // ];
    // ---------------------------------------------------------------------------
    void genRadioList() {
      List sortedRadioStates =
          oneDeviceParams.where((i) => i.adrr >= 7 && i.adrr <= 56).toList();
      for (int i = 0; i < radioCount; i++) {
        String radioParam = sortedRadioStates[i].value.substring(30, 32);
        var oneRadioState = oneDeviceStates[i + 7].value;
        int battery = int.parse(oneRadioState.substring(16, 24), radix: 2);
        int sig = int.parse(oneRadioState.substring(26, 29), radix: 2);
        bool lost = oneRadioState.substring(29, 30) == '1';
        bool discharged = oneRadioState.substring(30, 31) == '1';
        bool alarma = oneRadioState.substring(31, 32) == '1';
        radioStateItems.add(RadioFinal(itemDb.sensors[i], radioParam, battery,
            sig, lost, discharged, alarma));
      }
    }

    margintotoo() {
      return const SizedBox(
        width: 8,
      );
    }

    genBattery(v) {
      if (v >= 80) {
        return Icon(
            color: Theme.of(context).colorScheme.secondary,
            CupertinoIcons.battery_full);
      } else if (v > 40 && v < 80) {
        return Icon(
            color: Theme.of(context).colorScheme.primary,
            CupertinoIcons.battery_full);
      } else if (v > 20 && v <= 40) {
        return Icon(
            color: Theme.of(context).colorScheme.primary,
            CupertinoIcons.battery_25);
      } else if (v > 10 && v <= 20) {
        return const Icon(color: Colors.orange, CupertinoIcons.battery_25);
      } else if (v <= 10) {
        return Icon(
            color: Theme.of(context).colorScheme.error,
            CupertinoIcons.battery_empty);
      } else {
        return Icon(
            color: Theme.of(context).colorScheme.primary,
            CupertinoIcons.battery_empty);
      }
    }

    genSignal(v) {
      if (v == 4) {
        return Icon(
            color: Theme.of(context).colorScheme.secondary,
            CupertinoIcons.chart_bar_fill);
      } else if (v == 3) {
        return Icon(
            color: Theme.of(context).colorScheme.primary,
            CupertinoIcons.chart_bar_fill);
      } else if (v == 2) {
        return Icon(
            color: Theme.of(context).colorScheme.primary,
            CupertinoIcons.chart_bar);
      } else if (v == 1) {
        return const Icon(color: Colors.orange, CupertinoIcons.chart_bar);
      } else if (v == 0) {
        return Icon(
            color: Theme.of(context).colorScheme.error,
            CupertinoIcons.chart_bar);
      } else {
        return Icon(
            color: Theme.of(context).colorScheme.error,
            CupertinoIcons.battery_empty);
      }
    }

    genRadioList();
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(style: titleStyle(context), 'Радиодатчики'),
            Text.rich(
              TextSpan(
                style: titleStyle(context),
                text: 'Кол-во подключенных: ',
                children: <TextSpan>[
                  TextSpan(
                      text: '$radioCount    ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      )),
                ],
              ),
            ),
          ]),
          const SizedBox(
            height: 20,
          ),
          // ---------------------------------------------------------------------
          radioCount > 0
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: radioStateItems.length,
                  itemBuilder: (context, index) {
                    final item = radioStateItems[index];
                    final String name = !wsize && item.name.length > 13
                        ? '${item.name.substring(0, 13)}..'
                        : item.name;

                    return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, left: 6),
                        decoration: BoxDecoration(
                          border: item.alarm || item.isLost
                              ? Border.all(
                                  width: 2,
                                  color: Theme.of(context).colorScheme.error)
                              : item.isDischarged
                                  ? Border.all(width: 1, color: Colors.orange)
                                  : null,
                          color: Theme.of(context).colorScheme.background,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.shadow,
                              spreadRadius: -1,
                              blurRadius: 2,
                              blurStyle: BlurStyle.outer,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Icon(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  CupertinoIcons.radiowaves_right),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        style: subTitleStyle(context),
                                        ' $name'),
                                    Text(
                                        style: descStyle(context),
                                        '  ${parceToTxt(item.param)}')
                                  ]),
                            ]),
                            Row(children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    genSignal(item.signal),
                                    Text(
                                        style: descStyle(context),
                                        '${item.signal}/4')
                                  ]),
                              margintotoo(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    genBattery(item.battery),
                                    Text(
                                        style: descStyle(context),
                                        '${item.battery}%')
                                  ]),
                              margintotoo(),
                              item.alarm || item.isLost || item.isDischarged
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                          Icon(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              CupertinoIcons
                                                  .exclamationmark_triangle),
                                          Text(
                                              style: descStyle(context),
                                              item.alarm
                                                  ? 'Тревога'
                                                  : item.isLost
                                                      ? 'Потерян'
                                                      : item.isDischarged
                                                          ? 'Разряжен'
                                                          : '')
                                        ])
                                  : const SizedBox(),
                              IconButton(
                                icon: Icon(
                                  CupertinoIcons.right_chevron,
                                  size: 22,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  _dialogBuilderRadio(
                                      context,
                                      itemDb,
                                      index,
                                      item,
                                      oneDeviceParams[index + 1],
                                      formKey,
                                      updateItemDb,
                                      oneDeviceStates,
                                      updateNewRegister,
                                      getAdditionalParams);
                                },
                              ),
                            ]),
                          ],
                        ));
                  },
                )
              // -----------------------------------------------------------------
              : Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12),
                          'Нет добавленных беспроводных датчиков',
                        ),
                      ]),
                ),
        ]);
  });
}
