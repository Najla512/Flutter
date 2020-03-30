//import 'package:flutter/material.dart';
//
//Color primaryColor = Color.fromARGB(255, 58, 149, 255);
//Color reallyLightGrey = Colors.grey.withAlpha(25);
//ThemeData appThemeLight =
//ThemeData.light().copyWith(primaryColor: primaryColor);
//ThemeData appThemeDark = ThemeData.dark().copyWith(
//    primaryColor: Colors.white,
//    toggleableActiveColor: primaryColor,
//    accentColor: primaryColor,
//    buttonColor: primaryColor,
//    textSelectionColor: primaryColor,
//    textSelectionHandleColor: primaryColor);

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme;
  Typography defaultTypography;
  SharedPreferences prefs;

  ThemeData dark = ThemeData.dark().copyWith();

  ThemeData light = ThemeData.light().copyWith();

  ThemeProvider(bool darkThemeOn) {
    _selectedTheme = darkThemeOn ? dark : light;
  }

  Future<void> swapTheme() async {
    prefs = await SharedPreferences.getInstance();

    if (_selectedTheme == dark) {
      _selectedTheme = light;
      await prefs.setBool("darkTheme", false);
    } else {
      _selectedTheme = dark;
      await prefs.setBool("darkTheme", true);
    }

    notifyListeners();
  }

  ThemeData getTheme() => _selectedTheme;
}
