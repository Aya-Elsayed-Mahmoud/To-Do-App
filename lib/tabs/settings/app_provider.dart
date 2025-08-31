import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  Locale currentLocale = const Locale('en');
  ThemeMode themeMode = ThemeMode.light;

  void changeLanguage(String languageCode) {
    currentLocale = Locale(languageCode);
    notifyListeners();
  }

  void toggleTheme(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
