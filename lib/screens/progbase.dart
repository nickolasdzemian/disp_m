import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:neptun_m/db/db.dart';
import 'package:neptun_m/screens/components/prog/prog_bar.dart';
import 'package:neptun_m/screens/components/prog/ui_funcs.dart';
import 'package:neptun_m/screens/components/prog/box_wide.dart';
import 'package:neptun_m/screens/components/prog/box_resize.dart';
import 'package:neptun_m/screens/components/styles/prog.dart';

class ProgBaseScreen extends StatefulWidget {
  const ProgBaseScreen({super.key});

  @override
  ProgBaseState createState() => ProgBaseState();
}

class ProgBaseState extends State<ProgBaseScreen> {
  int repeat = settings.get('repeatProg');
  List devices = allDevicesDb();

  void updateItemDb(v) {
    setState(() {
      repeat = v;
    });
  }

  String filter = '';
  void setFilter(String f) {
    if (mounted) {
      setState(() {
        filter = f;
        if (f != '') {
          devices = allDevicesDb()
              .where((d) => d.name.toLowerCase().contains(filter))
              .toList();
        } else {
          devices = allDevicesDb();
        }
      });
    }
  }

  void updateEvents() {
    if (mounted) {
      setState(() {
        devices = allDevicesDb();
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bool wsize = MediaQuery.of(context).size.width > 800;

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
                  stepper(context, repeat, updateItemDb, settings),
                ),
                resizeBox(
                    context,
                    devices.isNotEmpty
                        ? ListView.builder(
                            primary: false,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: devices.length,
                            itemExtent: 66,
                            itemBuilder: (context, index) {
                              final item = devices[index];
                              List plans = [];
                              plans = plan.get(devices[index].mac)!;

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
                                      Row(children: [
                                        Icon(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            CupertinoIcons.sidebar_left),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  style: subTitleStyle(context),
                                                  ' ${item.name}'),
                                              Text(
                                                  style: descStyle(context),
                                                  '  Кол-во событий устройства')
                                            ]),
                                      ]),
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      style: bigValueStyle(
                                                          context),
                                                      '${plans.length}')
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
                                                Navigator.pushNamed(
                                                    context, '/progitem',
                                                    arguments: ProgNavArguments(
                                                        item,
                                                        updateEvents,
                                                        devices[index].mac));
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
                                    'Нет добавленных устройств',
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
            heroTag: "btn_prog_search",
            onPressed: () {
              popupSearch(context, setFilter);
            },
            tooltip: 'Поиск по имени',
            child: const Icon(CupertinoIcons.search),
          ),
        ]));
  }
}
