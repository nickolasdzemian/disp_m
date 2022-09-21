import 'package:flutter/material.dart';
import 'package:neptun_m/db/db.dart';
import './color_schemes.g.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeData = ThemeMode.light;
  ThemeMode getTheme() => _themeData;

  ThemeNotifier() {
    bool v = settings.get('themeMode');
    _themeData = v ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  Future setMode(v) async {
    await DataBase.updateOnlySetting('themeMode', v);
    _themeData = v ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    appBarTheme: AppBarTheme(
      toolbarHeight: 100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
          bottom: Radius.circular(15),
        ),
      ),
      elevation: 3.0,
      shadowColor: lightColorScheme.shadow,
    ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 230, 230, 230));

ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    appBarTheme: AppBarTheme(
      toolbarHeight: 100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
          bottom: Radius.circular(15),
        ),
      ),
      elevation: 3.0,
      shadowColor: darkColorScheme.shadow,
    ),
    scaffoldBackgroundColor: const Color(0x00303030));
