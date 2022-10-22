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
    visualDensity: VisualDensity.adaptivePlatformDensity,
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
    scrollbarTheme: ScrollbarThemeData(
        thumbColor:
            MaterialStateProperty.all(const Color.fromARGB(255, 0, 172, 225))),
    scaffoldBackgroundColor: const Color.fromARGB(255, 230, 230, 230),
    highlightColor: const Color.fromARGB(255, 0, 172, 225));

ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
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
    scrollbarTheme: ScrollbarThemeData(
        thumbColor:
            MaterialStateProperty.all(const Color.fromARGB(255, 0, 172, 225))),
    scaffoldBackgroundColor: const Color.fromARGB(255, 30, 30, 30),
    highlightColor: const Color.fromARGB(255, 0, 172, 225));
