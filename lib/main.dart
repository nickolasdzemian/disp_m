import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:neptun_m/rebuilder.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/services.dart';

import 'package:neptun_m/api/route.dart';
import 'package:neptun_m/db/db.dart';
import 'package:neptun_m/lib/getters.dart';
import 'package:neptun_m/lib/remote_config.dart';
import 'package:neptun_m/screens/device.dart';
import 'package:neptun_m/screens/counter.dart';

import './screens/theme/theme.dart';
import './screens/home.dart';
import './screens/settings.dart';
import './screens/history.dart';
import './screens/progbase.dart';
import './screens/progitem.dart';

import 'package:local_notifier/local_notifier.dart';
import 'package:neptun_m/lib/push.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:process_run/shell_run.dart';

@protected
Future initState() async {
  var controller = ShellLinesController();
  var shell =
      Shell(stdout: controller.sink, verbose: false, throwOnError: false);
  List<ProcessResult> havePid;
  int killer = 0;
  List pidList = [];
  if (Platform.isMacOS) {
    havePid = await shell.run('pgrep neptun_m');
    pidList = havePid[0].stdout.toString().split('\n');
    killer = pidList.length;
    if (killer > 1) {
      await shell.run('killall neptun_m');
    }
  } else if (Platform.isLinux) {
    havePid = await shell.run('pgrep neptun_m');
    pidList = havePid[0].stdout.toString().split('\n');
    killer = pidList.length;
    if (killer > 2) {
      Process.killPid(pid);
    }
  } else if (Platform.isWindows) {
    havePid = await shell.run('tasklist');
    pidList = havePid[0].stdout.toString().split('\n');
    for (int p = 0; p < pidList.length; p++) {
      if (pidList[p].contains('neptun_m.exe')) {
        killer++;
      }
    }
  }
  // TURN OFF NEXT IF LINUX
  if (killer > 1) {
    Process.killPid(pid);
  }

  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  appDataDirectory = '${directory.path}/Neptun';
  await initDatabase();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(850, 950),
      center: true,
      backgroundColor: Color.fromARGB(255, 0, 172, 225),
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setTitle('Система диспетчеризации Neptun Smart');
      await windowManager.setMinimumSize(const Size(850, 950));
      // await windowManager.setFullScreen(true);
    });
    await localNotifier.setup(
      appName: 'Neptun Smart Disp. System',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
  } else if (Platform.isAndroid) {
    await pushes();
    const platform = MethodChannel('com.example.neptun_m/common');
    await platform
        .invokeMethod('startService', {'dura': await settings.get('interval')});
  }
}

Future<void> main() async {
  const rebuilddura = Duration(seconds: 2);
  await initState();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    emergencyRestart();
  };
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://0fab3f35d0354df48ac143d5a6a96ab4@o4504078561771520.ingest.sentry.io/4504078562820096';
      options.tracesSampleRate = 1.0;
      options.debug = false;
      options.enableNativeCrashHandling = true;
      options.beforeSend = beforeSend;
    },
    appRunner: () => runApp(Rebuilder(
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
        ))),
  );
}

class Neptun extends StatelessWidget {
  const Neptun({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              title: 'Neptun Smart',
              locale: const Locale('ru'),
              supportedLocales: const [
                Locale('ru'),
                Locale('en'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
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
                '/counter': (BuildContext context) => const CounterScreen(),
                '/progbase': (BuildContext context) => const ProgBaseScreen(),
                '/progitem': (BuildContext context) => const ProgItemScreen(),
              },
            ));
  }
}
