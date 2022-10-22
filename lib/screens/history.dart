import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:neptun_m/db/db.dart';

import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter_excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_core/theme.dart';

part 'components/styles/history.dart';
part 'components/history/his_bar.dart';
part 'components/history/filter_func.dart';
part 'components/history/clear.dart';
part 'components/history/export_xls.dart';
part 'components/history/calendar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  HistoryWidgetState createState() => HistoryWidgetState();
}

class HistoryWidgetState extends State<HistoryScreen> {
  List<EventItem> allevents = [];
  @override
  void initState() {
    super.initState();
    if (allEventsDb().isNotEmpty) {
      var evs = [...events.values.toList()];
      var filteredEvents = evs.where((e) => e.evType < 3).toList();
      filteredEvents.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      allevents = filteredEvents;
    }
  }

  bool reorder = false;
  int filterValue = -1;

  void invertOrder(r) {
    var evs = [...allevents];
    var filteredEvents = evs;
    if (r) {
      filteredEvents.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } else {
      filteredEvents
          .sort((a, b) => b.timestamp.compareTo(a.timestamp)); // new top
    }
    setState(() {
      allevents = filteredEvents;
      reorder = r;
    });
  }

  void filterType(r, t) {
    var evs = [...events.values.toList()];
    List<EventItem> filteredEvents = [];
    if (t < 0) {
      filteredEvents = evs.where((e) => e.evType < 3).toList();
    } else if (t > 9) {
      filteredEvents = evs.where((e) => e.evType < t).toList();
    } else {
      filteredEvents = evs.where((e) => e.evType == t).toList();
    }
    if (r) {
      filteredEvents.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } else {
      filteredEvents
          .sort((a, b) => b.timestamp.compareTo(a.timestamp)); // new top
    }
    setState(() {
      allevents = filteredEvents;
      filterValue = t;
    });
  }

  void updateState() {
    if (allEventsDb().isNotEmpty) {
      var evs = [...events.values.toList()];
      var filteredEvents = evs.where((e) => e.evType < 3).toList();
      filteredEvents.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      setState(() {
        allevents = filteredEvents;
        reorder = false;
        filterValue = -1;
      });
    } else {
      setState(() {
        allevents = [];
        reorder = false;
        filterValue = -1;
      });
    }
  }

  void updateRange(sd, ed) {
    var evs = [...events.values.toList()];
    var filteredEvents = evs
        .where((e) => (e.timestamp.isAfter(sd) && e.timestamp.isBefore(ed)))
        .toList();
    setState(() {
      allevents = filteredEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: historyAppBar(context, reorder, filterValue, invertOrder,
            filterType, updateState, allevents),
        body: allevents.isNotEmpty
            ? ListView.builder(
                primary: false,
                padding: const EdgeInsets.only(left: 25, right: 25),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: allevents.length,
                itemExtent: 66,
                itemBuilder: (context, index) {
                  final item = allevents[index];

                  return ListTile(
                    minVerticalPadding: 5,
                    visualDensity: VisualDensity.comfortable,
                    leading: item.evType == 0
                        ? Icon(
                            color: Theme.of(context).colorScheme.secondary,
                            CupertinoIcons.drop_fill)
                        : item.evType == 1
                            ? const Icon(
                                color: Colors.yellow,
                                CupertinoIcons.antenna_radiowaves_left_right)
                            : item.evType == 2
                                ? const Icon(
                                    color: Colors.yellow,
                                    CupertinoIcons.battery_empty)
                                : item.evType == 3
                                    ? Icon(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        CupertinoIcons.wifi_slash)
                                    : item.evType == 4
                                        ? Icon(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            CupertinoIcons
                                                .chevron_left_slash_chevron_right)
                                        : Icon(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            CupertinoIcons
                                                .exclamationmark_triangle_fill),
                    title: Row(children: [
                      Text(
                          '${item.formatedStamp}   ${item.deviceName}: ${item.evName}')
                    ]),
                    subtitle: Text(item.info),
                  );
                },
              )
            : Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                        'Журнал событий пуст',
                      ),
                    ]),
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
            heroTag: "btn4",
            onPressed: (() {
              updateState();
            }),
            tooltip: 'Обновить список\nи сбросить фильтры',
            child: const Icon(CupertinoIcons.arrow_2_circlepath),
          ),
        ]));
  }
}
