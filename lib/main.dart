import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:neptun_m/api/route.dart';
import 'package:neptun_m/db/db.dart';
import 'package:neptun_m/lib/getters.dart';
// import 'package:neptun_m/lib/remote_config.dart';

import './screens/theme/color_schemes.g.dart';
import './screens/theme/theme.dart';
import './screens/home.dart';
import './screens/settings.dart';

@protected
Future initState() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  appDataDirectory = directory.toString();
  Hive.init(directory.path);
  registerAdapters();
  await Hive.openBox<Device>(devicesBOXname,
      compactionStrategy: (entries, deletedEntries) {
    return deletedEntries > 50;
  });
  await Hive.openBox(settingsBOXname);
  await Hive.openBox<EventItem>(eventsBOXname);

  var initialRun = await settings.get('firstStart');
  if (initialRun == null || initialRun == true) {
    await DataBase.firstRun();
    await settings.put('firstStart', false);
  }

  // getRemoteConfig();
  var server = await settings.get('server');
  if (server) {
    serve();
  }
}

void main() async {
  await initState();
  return runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
    child: const Neptun(),
  ));
  // runApp(const Neptun());
}

class Neptun extends StatelessWidget {
  const Neptun({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              title: 'Пися ежа',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: theme.getTheme(),
              home: BlocProvider(
                create: (_) => StatesModel(),
                // lazy: false,
                child: const HomePage(),
              ),
              routes: <String, WidgetBuilder>{
                '/settings': (BuildContext context) => BlocProvider(
                      create: (_) => StatesModel(),
                      child: AppSettingsPage(setMode: theme.setMode),
                    ),
                '/history': (BuildContext context) => BlocProvider(
                      create: (_) => StatesModel(),
                      child: AppSettingsPage(setMode: theme.setMode),
                    ),
              },
            ));
  }
}
