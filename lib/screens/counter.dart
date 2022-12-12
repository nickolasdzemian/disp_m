// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:neptun_m/db/db.dart';
import 'package:neptun_m/lib/getters.dart';
import 'package:neptun_m/lib/setters.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter_excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

part '../screens/components/counter/counter_bar.dart';
part '../screens/components/counter/box_wide.dart';
part '../screens/components/counter/edit_dialog.dart';
part '../screens/components/counter/edit_functions.dart';
part '../screens/components/counter/settings.dart';
part '../screens/components/counter/calendar.dart';
part '../screens/components/counter/export_xls.dart';
part '../screens/components/counter/clear.dart';
part '../screens/components/styles/counter.dart';

// List<CounterSItem> genTestData() {
//   List<CounterSItem> testDATA = <CounterSItem>[
//     CounterSItem(date: DateTime.now(), value: 0),
//   ];
//   var today = DateTime.now();
//   // Make list
//   for (int t = 0; t < 3; t++) {
//     var date = today.add(Duration(days: t + 1));
//     var rng = Random();
//     double newvalue = rng.nextInt(100).toDouble();
//     // testDATA.add(CounterSItem(date: date, value: newvalue));
//   }
//   testDATA
//       .add(CounterSItem(date: today.add(const Duration(days: 1)), value: 10));
//   testDATA
//       .add(CounterSItem(date: today.add(const Duration(days: 1)), value: 1000));
//   testDATA
//       .add(CounterSItem(date: today.add(const Duration(days: 1)), value: 5));
//   // Get diff
//   List<CounterSItem> testCHART = <CounterSItem>[
//     CounterSItem(date: DateTime.now(), value: 0),
//   ];
//   for (int t = 0; t < testDATA.length; t++) {
//     if (t == 0) {
//       t++;
//     } else {
//       double prevvalue = testDATA[t - 1].value;
//       double thisvalue = testDATA[t].value;
//       double newvalue = thisvalue - prevvalue;
//       testCHART.add(CounterSItem(date: testDATA[t].date, value: newvalue));
//     }
//   }
//   return testCHART;
// }

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  CounterWidgetState createState() => CounterWidgetState();
}

class CounterWidgetState extends State<CounterScreen> {
  final formKey = GlobalKey<FormState>();
  var item;
  String key = '';
  List<CounterSItem>? stat;
  bool load = true;

  void updateItemDb() {
    setState(() {});
  }

  List<CounterSItem> genChartData(inistat) {
    List chartData = <CounterSItem>[
      CounterSItem(date: DateTime.now(), value: 0),
    ];
    if (inistat != null) {
      for (int t = 0; t < inistat.length; t++) {
        if (t == 0) {
          chartData.add(
              CounterSItem(date: inistat[t].date, value: inistat[t].value));
        } else {
          double prevvalue = inistat[t - 1].value;
          double thisvalue = inistat[t].value;
          double newvalue = thisvalue - prevvalue;
          chartData.add(CounterSItem(date: inistat[t].date, value: newvalue));
        }
      }
    }
    return chartData.cast<CounterSItem>();
  }

  String parceDate(DateTime v) {
    String dd = v.day < 10 ? '0${v.day.toString()}' : v.day.toString();
    String mm = v.month < 10 ? '0${v.month.toString()}' : v.month.toString();
    return '$dd.$mm';
  }

  void updateRange(sd, ed) {
    List chartData = cstats.get(key)!;
    // chartData = genTestData(); // DEBUG
    chartData = chartData
        .where((e) => (e.date.isAfter(sd) && e.date.isBefore(ed)))
        .toList();
    setState(() {
      stat = chartData.cast<CounterSItem>();
    });
  }

  void updateState() {
    List restat = cstats.get(key)!;
    setState(() {
      stat = genChartData(restat);
      // stat = genTestData(); // DEBUG;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)!.settings.arguments as CounterNavArguments;
    var itemDb = data.itemDb;
    item = data.item;
    itemDb = allDevicesDb()[itemDb.index];
    key = '${itemDb.mac}-CS${item.index}';
    bool wsize = MediaQuery.of(context).size.width > 800;
    if (load) {
      updateState();
      load = !load;
    }

    return Scaffold(
        appBar: counterAppBar(
            context, data.title, key, updateState, stat, itemDb.name),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: wsize
                      ? const EdgeInsets.all(10)
                      : const EdgeInsets.only(
                          top: 20, left: 10, right: 8, bottom: 10),
                  margin: wsize
                      ? const EdgeInsets.all(25)
                      : const EdgeInsets.only(top: 25, left: 17.5, right: 17.5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      // Chart title
                      title: ChartTitle(
                          alignment: ChartAlignment.near,
                          textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                          text: 'Статистика счётчика, м³\n'),
                      // Enable legend
                      legend: Legend(isVisible: true),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(
                          enable: true,
                          color: Theme.of(context).colorScheme.primary),
                      series: <ChartSeries<CounterSItem, String>>[
                        SplineSeries<CounterSItem, String>(
                            dataSource: stat != null
                                ? stat!
                                : <CounterSItem>[
                                    CounterSItem(
                                        date: DateTime.now(), value: 0),
                                  ],
                            xValueMapper: (CounterSItem? date, _) =>
                                parceDate(date!.date),
                            yValueMapper: (CounterSItem? value, _) =>
                                value!.value,
                            name: 'Расход',
                            color: Theme.of(context).colorScheme.secondary,
                            isVisibleInLegend: false,
                            animationDuration: 1500,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true))
                      ]),
                ),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  paramsBoxWide(
                      context,
                      420,
                      settingsBase(
                          context,
                          item,
                          itemDb,
                          formKey,
                          updateItemDb,
                          data.updateoneDeviceCounters,
                          data.updateoneDeviceCountersParams)),
                ]),
                const SizedBox(height: 90),
              ],
            ),
          ),
        ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            heroTag: "btn_cal",
            onPressed: () {
              _dialogBuilderCal(context, updateRange);
            },
            tooltip: 'Сортировка по дате',
            child: const Icon(CupertinoIcons.calendar_today),
          ),
          const SizedBox(height: 15, width: 15),
          FloatingActionButton(
            heroTag: "btnCStat",
            onPressed: (() {
              updateState();
            }),
            tooltip: 'Обновить список\nи сбросить фильтры',
            child: const Icon(CupertinoIcons.arrow_2_circlepath),
          ),
        ]));
  }
}
