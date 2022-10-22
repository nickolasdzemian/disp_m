import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:neptun_m/rebuilder.dart';
import 'package:window_size/window_size.dart';
import 'package:wakelock/wakelock.dart';

import 'package:neptun_m/api/route.dart';
import 'package:neptun_m/db/db.dart';
import 'package:neptun_m/lib/getters.dart';
import 'package:neptun_m/lib/remote_config.dart';
import 'package:neptun_m/screens/device.dart';

import './screens/theme/theme.dart';
import './screens/home.dart';
import './screens/settings.dart';
import './screens/history.dart';

import 'package:local_notifier/local_notifier.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@protected
Future initState() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Система диспетчеризации Neptun Smart');
    setWindowFrame(const Offset(1.0, 2.0) & const Size(850, 900));
    setWindowMinSize(const Size(850, 900));
    setWindowMaxSize(Size.infinite);
    await localNotifier.setup(
      appName: 'Neptun Smart Disp. System',
      // The parameter shortcutPolicy only works on Windows
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
  }
  Wakelock.enable();
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  appDataDirectory = '${directory.path}/Neptun';
  Hive.init(appDataDirectory);
  registerAdapters();
  await Hive.openBox<Device>(devicesBOXname,
      compactionStrategy: (entries, deletedEntries) {
    return deletedEntries > 50;
  });
  await Hive.openBox(settingsBOXname);
  await Hive.openBox<EventItem>(eventsBOXname);

  var initialRun = await settings.get('firstStart');
  if (initialRun == null || initialRun[0] == true) {
    await DataBase.firstRun();
    await settings.put('firstStart', [false, true, true]);
  }
}

void main() async {
  const rebuilddura = Duration(seconds: 2);
  await initState();
  return runApp(Rebuilder(
      key: UniqueKey(),
      waiting: (BuildContext context) => const Waiting(),
      errorBuilder: (_, error) => rebuildErr(),
      builder: (_, child) async {
        /// here we can initialize your services
        await getRemoteConfig();
        var server = await settings.get('server');
        if (server) {
          serve();
        }
        await Future.delayed(rebuilddura);
        return child;
      },
      child: ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(),
        child: const Neptun(),
      )));
}

class Neptun extends StatelessWidget {
  const Neptun({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              title: '666',
              locale: const Locale('ru'),
              supportedLocales: const [
                Locale('ru'),
                Locale('en'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                SfGlobalLocalizations.delegate
              ],
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
                '/history': (BuildContext context) => const HistoryScreen(),
                '/device': (BuildContext context) => const DeviceScreen(),
              },
            ));
  }
}
