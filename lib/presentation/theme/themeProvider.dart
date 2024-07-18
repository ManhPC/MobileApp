// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/theme/dark_mode.dart';
import 'package:nvs_trading/presentation/theme/light_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = darkTheme;
  bool _isDarkMode = false;

  ThemeData get currentTheme => _currentTheme;
  bool get isDarkMode => _isDarkMode;

  static const String _themeKey = 'theme_key';

  Future<void> loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, _isDarkMode);
  }
}
