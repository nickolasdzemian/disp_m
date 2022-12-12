import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:neptun_m/screens/components/styles/prog.dart';
import 'package:neptun_m/db/db.dart';

Row stepper(context, itemDb, updateItemDb, settings) {
  List<String> list = <String>['x2', 'x5', 'x10'];

  String dropdownValue = 'x$itemDb';
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Row(children: [
              Icon(
                  color: Theme.of(context).colorScheme.secondary,
                  CupertinoIcons.refresh),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text.rich(
                  TextSpan(
                    style: subTitleStyle(context),
                    text: '  Интервал выполнения',
                  ),
                ),
                Text(
                    style: descStyle(context),
                    '   Смещение от заданного времени\n   ± от прохождения опроса')
              ])
            ])
          ],
        ),
        DropdownButton<String>(
          key: UniqueKey(),
          value: dropdownValue,
          icon: const Icon(CupertinoIcons.chevron_down),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          hint: null,
          onChanged: (String? value) async {
            int v = int.parse(value!.substring(1));
            await settings.put('repeatProg', v);
            updateItemDb(v);
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              alignment: AlignmentDirectional.center,
              value: value,
              child: Text(style: bigValueStyle(context), value),
            );
          }).toList(),
        )
      ]);
}

Row sorter(context, int val, sortThis) {
  List<String> list = <String>[
    'Разовые  ',
    'Ежедневные  ',
    'Еженедельные  ',
    'Ежемесячные  ',
    'Показать все  '
  ];

  String dropdownValue = list[val];
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Row(children: [
              Icon(
                  color: Theme.of(context).colorScheme.secondary,
                  CupertinoIcons.square_list),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text.rich(
                  TextSpan(
                    style: subTitleStyle(context),
                    text: '  Фильтр событий',
                  ),
                ),
                Text(
                    style: descStyle(context),
                    '   Сортировка событий\n   по типу регулярности')
              ])
            ])
          ],
        ),
        DropdownButton<String>(
          key: UniqueKey(),
          value: dropdownValue,
          iconSize: 20,
          icon: const Icon(CupertinoIcons.chevron_down),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          hint: null,
          onChanged: (String? value) async {
            int idx = list.indexOf(value!);
            sortThis(idx);
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              alignment: AlignmentDirectional.center,
              value: value,
              child: Text(style: subTitleStyle(context), value),
            );
          }).toList(),
        )
      ]);
}

Future<void> popupSearch(context, setFilter) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext contextBase) {
      return AlertDialog(
        alignment: Alignment.bottomCenter,
        content: SizedBox(
            width: 275,
            height: 80,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Имя или описание',
              ),
              onChanged: (value) => {setFilter(value.toLowerCase())},
              initialValue: '',
            )),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Закрыть'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () {
              setFilter('');
              Navigator.of(context).pop();
            },
            child: const Text('Сбросить'),
          ),
        ],
      );
    },
  );
}

Future<void> addNew(
    context, key, sortedPopit, updateEvents, item, idxxx, sort) {
  bool wsize = MediaQuery.of(context).size.width > 800;
  Duration hell = const Duration(hours: 1);
  ValueNotifier<PlanItem> temp = item == null
      ? ValueNotifier<PlanItem>(PlanItem(
          idxxx,
          sort < 4 ? sort : 0,
          DateTime.now().toLocal(),
          '',
          1,
          [0, 0, 0, 0],
          DateTime.now().toLocal().subtract(hell)))
      : ValueNotifier<PlanItem>(PlanItem(
          item.index,
          item.type,
          item.date,
          item.desc,
          item.state,
          item.todo,
          DateTime.now().toLocal().subtract(hell)));
  List? plans = [...plan.get(key)!];
  SizedBox divider() {
    double v = 10;
    return SizedBox(width: v, height: v);
  }

  ValueListenableBuilder evamaria() {
    List<String> rep = <String>[
      'Однократно  ',
      'Ежедневно  ',
      'Еженедельно  ',
      'Ежемесячно  ',
    ];
    List<String> onof = <String>[
      '--  ',
      'Выключить  ',
      'Включить  ',
    ];
    List<String> opcl = <String>[
      '--  ',
      'Закрыть  ',
      'Открыть  ',
    ];
    return ValueListenableBuilder(
      valueListenable: temp,
      builder: (context, value, child) {
        return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      style: subTitleStyle(context),
                      'Состояние события: ',
                    ),
                    Transform.scale(
                      scale: 0.75,
                      child: CupertinoSwitch(
                        value: temp.value.state != 0,
                        thumbColor: CupertinoColors.white,
                        trackColor:
                            CupertinoColors.inactiveGray.withOpacity(0.4),
                        activeColor: temp.value.state == 2
                            ? CupertinoColors.systemRed.withOpacity(0.6)
                            : temp.value.state == 3
                                ? Theme.of(context).colorScheme.secondary
                                : CupertinoColors.systemGreen.withOpacity(0.6),
                        onChanged: (bool? value) {
                          temp.value = PlanItem(
                              temp.value.index,
                              temp.value.type,
                              temp.value.date,
                              temp.value.desc,
                              value! ? 1 : 0,
                              [
                                temp.value.todo[0],
                                temp.value.todo[1],
                                temp.value.todo[2],
                                temp.value.todo[3]
                              ],
                              temp.value.resact);
                        },
                      ),
                    ),
                  ],
                ),
                divider(),
                DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  locale: const Locale('ru', 'RU'),
                  dateMask: 'EE, dd MMM',
                  useRootNavigator: true,
                  initialValue: temp.value.date.toString(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  dateLabelText: 'Дата',
                  timeLabelText: "Время",
                  onChanged: (val) => {
                    temp.value = PlanItem(
                        temp.value.index,
                        temp.value.type,
                        DateTime.parse(val).toLocal(),
                        temp.value.desc,
                        temp.value.state,
                        [
                          temp.value.todo[0],
                          temp.value.todo[1],
                          temp.value.todo[2],
                          temp.value.todo[3]
                        ],
                        temp.value.resact),
                  },
                ),
                divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: subTitleStyle(context),
                          text: 'Повторять:',
                        ),
                      ),
                      DropdownButton<String>(
                        key: UniqueKey(),
                        value: item != null
                            ? rep[temp.value.type]
                            : sort < 4
                                ? rep[sort]
                                : rep[0],
                        elevation: 50,
                        iconSize: 15,
                        icon: const Icon(CupertinoIcons.chevron_down),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        hint: null,
                        onChanged: (String? value) {
                          int idx = rep.indexOf(value!);
                          temp.value = PlanItem(
                              temp.value.index,
                              idx,
                              temp.value.date,
                              temp.value.desc,
                              temp.value.state,
                              [
                                temp.value.todo[0],
                                temp.value.todo[1],
                                temp.value.todo[2],
                                temp.value.todo[3]
                              ],
                              temp.value.resact);
                        },
                        items:
                            rep.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: value,
                            child: Text(style: subTitleStyle(context), value),
                          );
                        }).toList(),
                      )
                    ]),
                divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: subTitleStyle(context),
                          text: 'Блокировка:',
                        ),
                      ),
                      DropdownButton<String>(
                        key: UniqueKey(),
                        value: onof[temp.value.todo[0]],
                        iconSize: 15,
                        icon: const Icon(CupertinoIcons.chevron_down),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        hint: null,
                        onChanged: (String? value) {
                          int idx = onof.indexOf(value!);
                          temp.value = PlanItem(
                              temp.value.index,
                              temp.value.type,
                              temp.value.date,
                              temp.value.desc,
                              temp.value.state,
                              [
                                idx,
                                temp.value.todo[1],
                                temp.value.todo[2],
                                temp.value.todo[3]
                              ],
                              temp.value.resact);
                        },
                        items:
                            onof.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: value,
                            child: Text(style: subTitleStyle(context), value),
                          );
                        }).toList(),
                      )
                    ]),
                divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: subTitleStyle(context),
                          text: 'Краны I группы:',
                        ),
                      ),
                      DropdownButton<String>(
                        key: UniqueKey(),
                        value: opcl[temp.value.todo[1]],
                        iconSize: 15,
                        icon: const Icon(CupertinoIcons.chevron_down),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        hint: null,
                        onChanged: (String? value) {
                          int idx = opcl.indexOf(value!);
                          temp.value = PlanItem(
                              temp.value.index,
                              temp.value.type,
                              temp.value.date,
                              temp.value.desc,
                              temp.value.state,
                              [
                                temp.value.todo[0],
                                idx,
                                temp.value.todo[2],
                                temp.value.todo[3]
                              ],
                              temp.value.resact);
                        },
                        items:
                            opcl.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: value,
                            child: Text(style: subTitleStyle(context), value),
                          );
                        }).toList(),
                      )
                    ]),
                divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: subTitleStyle(context),
                          text: 'Краны II группы:',
                        ),
                      ),
                      DropdownButton<String>(
                        key: UniqueKey(),
                        value: opcl[temp.value.todo[2]],
                        iconSize: 15,
                        icon: const Icon(CupertinoIcons.chevron_down),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        hint: null,
                        onChanged: (String? value) {
                          int idx = opcl.indexOf(value!);
                          temp.value = PlanItem(
                              temp.value.index,
                              temp.value.type,
                              temp.value.date,
                              temp.value.desc,
                              temp.value.state,
                              [
                                temp.value.todo[0],
                                temp.value.todo[1],
                                idx,
                                temp.value.todo[3]
                              ],
                              temp.value.resact);
                        },
                        items:
                            opcl.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: value,
                            child: Text(style: subTitleStyle(context), value),
                          );
                        }).toList(),
                      )
                    ]),
                divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: subTitleStyle(context),
                          text: 'Режим мойки:',
                        ),
                      ),
                      DropdownButton<String>(
                        key: UniqueKey(),
                        value: onof[temp.value.todo[3]],
                        iconSize: 15,
                        icon: const Icon(CupertinoIcons.chevron_down),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        hint: null,
                        onChanged: (String? value) {
                          int idx = onof.indexOf(value!);
                          temp.value = PlanItem(
                              temp.value.index,
                              temp.value.type,
                              temp.value.date,
                              temp.value.desc,
                              temp.value.state,
                              [
                                temp.value.todo[0],
                                temp.value.todo[1],
                                temp.value.todo[2],
                                idx
                              ],
                              temp.value.resact);
                        },
                        items:
                            onof.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: value,
                            child: Text(style: subTitleStyle(context), value),
                          );
                        }).toList(),
                      )
                    ]),
                divider(),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Описание события',
                  ),
                  onChanged: (value) => {
                    temp.value = PlanItem(
                        temp.value.index,
                        temp.value.type,
                        temp.value.date,
                        value,
                        temp.value.state,
                        [
                          temp.value.todo[0],
                          temp.value.todo[1],
                          temp.value.todo[2],
                          temp.value.todo[3]
                        ],
                        temp.value.resact),
                  },
                  initialValue: temp.value.desc,
                  validator: (String? value) {
                    return (value != null && value.length < 22)
                        ? null
                        : 'Максимальная длина - 22 символа ';
                  },
                ),
                divider(),
                divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: wsize
                        ? [
                            Icon(
                                color: Theme.of(context).colorScheme.primary,
                                CupertinoIcons.book),
                            Text.rich(
                              textAlign: TextAlign.left,
                              softWrap: true,
                              TextSpan(
                                style: titleStyle(context),
                                text:
                                    '   При выборе типа "ежедневно" -\n   событие исполняется по времени\n   "еженедельно" - по времени и дню недели\n   "ежемесячно" - по времени и числу.\n   Выбранные параметры интерпретируются\n   автоматически.',
                              ),
                            ),
                          ]
                        : []),
                divider(),
              ],
            ));
      },
    );
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext contextBase) {
      return AlertDialog(
        alignment: Alignment.center,
        title: Row(children: [
          Icon(
              color: Theme.of(context).colorScheme.secondary,
              CupertinoIcons.calendar_badge_plus),
          const Text('   Новое событие'),
        ]),
        content: SizedBox(
          width: 355,
          child: evamaria(),
        ),
        actions: <Widget>[
          item != null
              ? TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                      'Удалить'),
                  onPressed: () async {
                    plans.removeAt(item.index);
                    for (int i = 0; i < plans.length; i++) {
                      plans[i].index = i;
                    }
                    await plan.put(key, plans);
                    sortedPopit();
                    updateEvents();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          content: const Text('Событие удалено')),
                    );
                    Navigator.of(context).pop();
                  },
                )
              : const SizedBox(),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Закрыть'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () async {
              if (!temp.value.todo.every((item) => item == 0) && item == null) {
                plans.add(PlanItem(
                    temp.value.index,
                    temp.value.type,
                    temp.value.date,
                    temp.value.desc,
                    temp.value.state,
                    [
                      temp.value.todo[0],
                      temp.value.todo[1],
                      temp.value.todo[2],
                      temp.value.todo[3]
                    ],
                    temp.value.resact));
                await plan.put(key, plans);
                sortedPopit();
                updateEvents();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor:
                          CupertinoColors.systemGreen.withOpacity(0.8),
                      content: const Text('Событие сохранено')),
                );
              } else if (!temp.value.todo.every((item) => item == 0) &&
                  item != null) {
                plans.removeAt(item.index);
                plans.insert(
                    item.index,
                    PlanItem(
                        item.index,
                        temp.value.type,
                        temp.value.date,
                        temp.value.desc,
                        temp.value.state,
                        [
                          temp.value.todo[0],
                          temp.value.todo[1],
                          temp.value.todo[2],
                          temp.value.todo[3]
                        ],
                        temp.value.resact));
                await plan.put(key, plans);
                sortedPopit();
                updateEvents();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor:
                          CupertinoColors.systemGreen.withOpacity(0.8),
                      content: const Text('Событие сохранено')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: const Text(
                          'Невозможно сохранить событие с отсутствующими действиями')),
                );
              }
              Navigator.of(context).pop();
            },
            child: Text(
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                'Сохранить'),
          ),
        ],
      );
    },
  );
}

SingleChildScrollView parceActions(context, List a) {
  bool wsize = MediaQuery.of(context).size.width > 800;
  SizedBox divider() {
    double v = 5;
    return SizedBox(width: v, height: 5);
  }

  return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        a[0] != 0
            ? Column(
                children: a[0] == 1
                    ? [
                        Icon(
                            color: Theme.of(context).colorScheme.primary,
                            CupertinoIcons.lock_open),
                        wsize
                            ? Text(style: descStyle(context), 'Выкл. блок.')
                            : const SizedBox()
                      ]
                    : [
                        Icon(
                            color: Theme.of(context).colorScheme.secondary,
                            CupertinoIcons.padlock),
                        wsize
                            ? Text(style: descStyle(context), 'Вкл. блок.')
                            : const SizedBox()
                      ])
            : const SizedBox(),
        divider(),
        a[1] != 0
            ? Column(
                children: a[1] == 1
                    ? [
                        Icon(
                            color: Theme.of(context).colorScheme.primary,
                            CupertinoIcons.drop),
                        wsize
                            ? Text(style: descStyle(context), 'Закр. I груп.')
                            : const SizedBox()
                      ]
                    : [
                        Icon(
                            color: Theme.of(context).colorScheme.secondary,
                            CupertinoIcons.drop),
                        wsize
                            ? Text(style: descStyle(context), 'Откр. I груп.')
                            : const SizedBox()
                      ])
            : const SizedBox(),
        divider(),
        a[2] != 0
            ? Column(
                children: a[2] == 1
                    ? [
                        Icon(
                            color: Theme.of(context).colorScheme.primary,
                            CupertinoIcons.drop),
                        wsize
                            ? Text(style: descStyle(context), 'Закр. II груп.')
                            : const SizedBox()
                      ]
                    : [
                        Icon(
                            color: Theme.of(context).colorScheme.secondary,
                            CupertinoIcons.drop),
                        wsize
                            ? Text(style: descStyle(context), 'Откр. II груп.')
                            : const SizedBox()
                      ])
            : const SizedBox(),
        divider(),
        a[3] != 0
            ? Column(
                children: a[3] == 1
                    ? [
                        Icon(
                            color: Theme.of(context).colorScheme.primary,
                            CupertinoIcons.volume_off),
                        wsize
                            ? Text(style: descStyle(context), 'Выкл. мойку')
                            : const SizedBox()
                      ]
                    : [
                        Icon(
                            color: Theme.of(context).colorScheme.secondary,
                            CupertinoIcons.volume_down),
                        wsize
                            ? Text(style: descStyle(context), 'Вкл. мойку')
                            : const SizedBox()
                      ])
            : const SizedBox(),
        divider(),
      ]));
}
