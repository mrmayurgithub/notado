import 'package:flutter/material.dart';

class MainTheme {
  MainTheme();

  ThemeData _darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    buttonColor: Color.fromARGB(14, 216, 206, 243),
    backgroundColor: Color(0xff3a375c),
    primaryColor: Color.fromARGB(255, 40, 37, 90),
    canvasColor: Color(0xff3a376c),
    accentColor: Color(0xffd6ceff),
    iconTheme: IconThemeData(color: Colors.white),
    highlightColor: Color(0xffac8ae8),
    hintColor: Color.fromARGB(100, 154, 109, 252),
  );

  ThemeData _lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    backgroundColor: Color(0xfffbfbfb),
    buttonColor: Color(0xfffbfbfb),
    primaryColor: Color(0xfffbfbfb),
    canvasColor: Color(0xfff5f5f5),
  );

  ThemeData getDarkTheme() {
    return _darkTheme;
  }

  ThemeData getLightTheme() {
    return _lightTheme;
  }
}

MainTheme appTheme = MainTheme();

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData = appTheme.getDarkTheme();
  ThemeChanger(this._themeData);
  getTheme() => _themeData;
  setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}
