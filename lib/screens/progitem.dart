import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:neptun_m/db/db.dart';
import 'package:intl/intl.dart';
import 'package:neptun_m/screens/components/prog/prog_bar.dart';
import 'package:neptun_m/screens/components/prog/ui_funcs.dart';
import 'package:neptun_m/screens/components/prog/box_wide.dart';
import 'package:neptun_m/screens/components/prog/box_resize.dart';
import 'package:neptun_m/screens/components/styles/prog.dart';

class ProgItemScreen extends StatefulWidget {
  const ProgItemScreen({super.key});

  @override
  ProgItemState createState() => ProgItemState();
}

class ProgItemState extends State<ProgItemScreen> {
  final formKey = GlobalKey<FormState>();
  List? plans;
  List? totalPlan;
  String key = '';
  bool load = true;
  // ignore: prefer_typing_uninitialized_variables
  var updateEvents;

  String filter = '';
  void setFilter(String f) {
    if (mounted) {
      setState(() {
        filter = f;
        if (f != '') {
          plans = totalPlan!
              .where((d) => d.desc.toLowerCase().contains(filter))
              .toList();
        } else {
          plans = totalPlan;
        }
      });
    }
  }

  int sort = 4;
  void sortThis(int v) {
    if (mounted) {
      setState(() {
        sort = v;
        if (v != 4) {
          plans = totalPlan!.where((d) => d.type == v).toList();
        } else {
          plans = totalPlan;
        }
      });
    }
  }

  void simplePopit() {
    if (mounted) {
      setState(() {
        plans = totalPlan;
      });
    }
  }

  void sortedPopit() {
    if (mounted) {
      setState(() {
        if (sort != 4) {
          totalPlan = plan.get(key);
          plans = plan.get(key)!.where((d) => d.type == sort).toList();
        } else {
          totalPlan = plan.get(key);
          plans = plan.get(key);
        }
      });
    }
  }

  String parceTimeByType(DateTime t, int type) {
    String res = 'Ошибка';
    var once = DateFormat("HH:mm, dd.MM.yy", 'ru');
    var day = DateFormat("HH:mm", 'ru');
    var week = DateFormat("HH:mm, EE", 'ru');
    var month = DateFormat("HH:mm, dd", 'ru');
    List forms = [once, day, week, month];
    List<String> wrds = [
      "Однократно в ",
      "Ежедневно в ",
      "Еженедельно в ",
      "Ежемесячно в "
    ];
    res = wrds[type] + forms[type].format(t).toString();
    return res;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as ProgNavArguments;
    key = data.key;
    updateEvents = data.updateEvents;
    bool wsize = MediaQuery.of(context).size.width > 800;
    if (load) {
      setState(() {
        plans = plan.get(key);
        totalPlan = plan.get(key);
        load = !load;
      });
    }

    return Scaffold(
        appBar: progAppBar(context),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                paramsBoxWide(
                  context,
                  95,
                  sorter(context, sort, sortThis),
                ),
                resizeBox(
                    context,
                    plans!.isNotEmpty
                        ? ListView.builder(
                            primary: false,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: plans?.length,
                            itemExtent: 66,
                            itemBuilder: (context, index) {
                              final item = plans![index];
                              final String desc = item.desc == ''
                                  ? 'Событие ${index + 1}'
                                  : !wsize && item.desc.length > 11
                                      ? '${item.desc.substring(0, 11)}..'
                                      : item.desc;
                              return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .shadow,
                                        spreadRadius: -1,
                                        blurRadius: 2,
                                        blurStyle: BlurStyle.outer,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            item.state != 0
                                                ? Icon(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    CupertinoIcons.bolt_badge_a)
                                                : Icon(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    CupertinoIcons.bolt_slash),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      style: subTitleStyle(
                                                          context),
                                                      ' $desc'),
                                                  Text(
                                                      style: descStyle(context),
                                                      '  ${parceTimeByType(item.date, item.type)}')
                                                ]),
                                          ]),
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  parceActions(
                                                      context, item.todo)
                                                ]),
                                            IconButton(
                                              icon: Icon(
                                                CupertinoIcons.right_chevron,
                                                size: 22,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                              onPressed: () {
                                                addNew(
                                                    context,
                                                    key,
                                                    sortedPopit,
                                                    updateEvents,
                                                    item,
                                                    totalPlan?.length,
                                                    sort);
                                              },
                                            ),
                                          ]),
                                    ],
                                  ));
                            },
                          )
                        : Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontSize: 12),
                                    'Нет настроенных событий расписания',
                                  ),
                                ]),
                          )),
                const SizedBox(height: 90),
              ],
            ),
          ),
        ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            heroTag: "btn_desc_search",
            onPressed: () {
              popupSearch(context, setFilter);
            },
            tooltip: 'Поиск по описанию',
            child: const Icon(CupertinoIcons.search),
          ),
          const SizedBox(height: 15, width: 15),
          FloatingActionButton(
            heroTag: "btn_prog_add",
            onPressed: () {
              addNew(context, key, sortedPopit, updateEvents, null,
                  totalPlan?.length, sort);
            },
            tooltip: 'Добавить событие',
            child: const Icon(CupertinoIcons.calendar_badge_plus),
          ),
        ]));
  }
}
