part of '../../device.dart';

StatefulBuilder settingsCounters(
    context,
    itemDb,
    oneDeviceCounters,
    oneDeviceCountersParams,
    formKey,
    updateoneDeviceCounters,
    updateoneDeviceCountersParams,
    updateItemDb,
    getAdditionalParams) {
  int activated = 0;

  // StateSetter _setState;

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    // _setState = setState;
    bool wsize = MediaQuery.of(context).size.width > 800;

    List countersItems = [];

    double toM3(v) {
      num litres = v[0] << 16 | v[1];
      double res = litres / 1000;
      return res;
    }

    String errParce(s) {
      int e = int.parse(s, radix: 2);
      String res = '';
      switch (e) {
        case 2: // Wrong official registers map (inverted)
          res = wsize ? 'Короткое замыкание' : 'Замыкание';
          break;
        case 1:
          res = wsize ? 'Обрыв линии' : 'Обрыв';
          break;
      }
      return res;
    }

    String parcePos(s, step, err) {
      String res = '';
      String nameslot = 'Слот #';
      String nameslotpos = ', Счетчик #';
      bool nope = step == '00000000';
      String nopetxt = wsize
          ? 'Модуль расширения счётчиков не установлен в слот'
          : 'Модуль расширения \n  не установлен в слот';

      switch (s) {
        case 0:
          res = nope ? '$nopetxt 1' : '${nameslot}1${nameslotpos}1 $err';
          break;
        case 1:
          res = nope ? '$nopetxt 1' : '${nameslot}1${nameslotpos}2 $err';
          break;
        case 2:
          res = nope ? '$nopetxt 2' : '${nameslot}2${nameslotpos}1 $err';
          break;
        case 3:
          res = nope ? '$nopetxt 2' : '${nameslot}2${nameslotpos}2 $err';
          break;
        case 4:
          res = nope ? '$nopetxt 3' : '${nameslot}3${nameslotpos}1 $err';
          break;
        case 5:
          res = nope ? '$nopetxt 3' : '${nameslot}3${nameslotpos}2 $err';
          break;
        case 6:
          res = nope ? '$nopetxt 4' : '${nameslot}4${nameslotpos}1 $err';
          break;
        case 7:
          res = nope ? '$nopetxt 4' : '${nameslot}4${nameslotpos}2 $err';
          break;
      }
      return res;
    }

    void genCountersList() {
      activated = itemDb.cswitch.where((i) => i == true).toList().length;
      List<double> limits = climits.get(itemDb.mac);
      for (int i = 0; i < itemDb.cswitch.length; i++) {
        if (itemDb.cswitch[i]) {
          String params = oneDeviceCountersParams[i].value;
          double value = toM3(oneDeviceCounters[i].value);
          bool state = params.substring(31, 32) == '1';
          bool type = params.substring(30, 31) == '1';
          String err = errParce(params.substring(28, 30));
          String step = params.substring(16, 24);
          String position = parcePos(i, step, err);
          double limit = limits[i];
          String reg = params;
          countersItems.add(CounterFinal(i, itemDb.counters[i], value, state,
              type, err, step, position, limit, reg));
        }
      }
    }

    margintotoo() {
      return const SizedBox(
        width: 8,
      );
    }

    gogogo(context, item) {
      Navigator.pushNamed(context, '/counter',
              arguments: CounterNavArguments(item.name, itemDb, item,
                  updateoneDeviceCounters, updateoneDeviceCountersParams))
          .then((_) {
        genCountersList();
        updateItemDb();
      });
    }

    genCountersList();

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(style: titleStyle(context), 'Счётчики'),
            Text.rich(
              TextSpan(
                style: titleStyle(context),
                text: 'Кол-во активированных: ',
                children: <TextSpan>[
                  TextSpan(
                      text: '$activated    ',
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
          activated > 0
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: countersItems.length,
                  itemBuilder: (context, index) {
                    final item = countersItems[index];
                    final bool nope = item.step == '00000000';
                    final bool overlimit =
                        item.limit > 0.0 && item.value > item.limit;
                    final String name = !wsize && item.name.length > 13
                        ? '${item.name.substring(0, 13)}..'
                        : item.name;

                    return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, left: 6),
                        decoration: BoxDecoration(
                          border: item.err != ''
                              ? Border.all(
                                  width: 2,
                                  color: Theme.of(context).colorScheme.error)
                              : overlimit
                                  ? Border.all(width: 1, color: Colors.yellow)
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
                                  CupertinoIcons.drop),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        style: subTitleStyle(context),
                                        ' $name'),
                                    Text(
                                        style: nope || item.err != ''
                                            ? descStyleErr(context)
                                            : descStyle(context),
                                        '  ${item.position}')
                                  ]),
                            ]),
                            Row(children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        style:
                                            bigValueStyle(context, item.value),
                                        '${item.value}м³')
                                  ]),
                              margintotoo(),
                              IconButton(
                                icon: Icon(
                                  CupertinoIcons.right_chevron,
                                  size: 22,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  nope ? null : gogogo(context, item);
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
                          'Нет активированных счётчиков воды',
                        ),
                      ]),
                ),
        ]);
  });
}
