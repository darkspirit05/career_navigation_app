import 'package:CareerVerse/theme/theme.dart';
import 'package:flutter/material.dart';


class ThemeProvider with ChangeNotifier {
  /// Initialize with system-based theme or default to light
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData.brightness == Brightness.dark;

  set themeData(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = isDarkMode ? lightMode : darkMode;
    notifyListeners();
  }
}
