import 'package:neptun_m/db/db.dart';
// import 'dart:developer';

int errc = 0;

Future<void> writeStats(String mac, int cidx, List v) async {
  final String key = '$mac-CS$cidx';
  final now = DateTime.now().toLocal();
  try {
    List initialStats = [...cstats.get(key)!];
    int slength = initialStats.length;
    CounterSItem last = initialStats[slength - 1];

    final fromlast = last.date;
    var temp = DateTime.now();
    var d1 = DateTime(temp.year, temp.month, temp.day);
    var d2 = DateTime(fromlast.year, fromlast.month, fromlast.day);

    double newvalue = 0;
    num litres = v[0] << 16 | v[1];
    double m3 = litres / 1000;
    if (d1.isAfter(d2)) {
      if (slength > 1 && slength < 184) {
        newvalue = m3;
      } else if (slength > 183) {
        newvalue = m3;
        initialStats.removeAt(slength - 1);
      }
      initialStats.add(CounterSItem(date: now, value: newvalue));
      await cstats.put(key, initialStats);
      errc--;
    }
  } catch (e) {
    errc++;
  }
  if (errc < 7) {
    errc = 0;
  } else if (errc > 7) {
    errc = 0;
    cstats.delete(key);
    final List<CounterSItem> initialStats = <CounterSItem>[
      CounterSItem(date: now, value: 0)
    ];
    await cstats.put(key, initialStats);
  }
}
