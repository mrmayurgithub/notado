import 'package:flutter/material.dart';

class MainTheme {
  MainTheme();
  ThemeData _darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    buttonColor: Color.fromARGB(14, 216, 206, 243),
    backgroundColor: Color(0xff3a375c),
    primaryColor: Color.fromARGB(255, 40, 37, 90),
    canvasColor: Color(0xff3a376c),
    accentColor: Colors.purple[100],
    iconTheme: IconThemeData(color: Colors.white),
    splashColor: Colors.green[400],
    hoverColor: Colors.green,
    highlightColor: Colors.green[200],
    cardColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    textTheme: ThemeData.dark().textTheme.copyWith(
          headline5: TextStyle(color: Colors.white),
          headline6: TextStyle(color: Colors.grey[400]),
          caption: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.green),
        ),
  );

  ThemeData _lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    backgroundColor: Color(0xfffbfbfb),
    buttonColor: Color(0xfffbfbfb),
    primaryColor: Color(0xfffbfbfb),
    canvasColor: Color(0xfff5f5f5),
    accentColor: Color(0xffd6cef3),
    iconTheme: IconThemeData(color: Colors.blueGrey),
    splashColor: Colors.green[500],
    highlightColor: Colors.purple[300],
    focusColor: Color(0xff5035e4),
    hintColor: Colors.purple[400],
    hoverColor: Colors.purple[200],
    floatingActionButtonTheme: FloatingActionButtonThemeData()
        .copyWith(backgroundColor: Colors.purple),
    textTheme: ThemeData.light().textTheme.copyWith(
          headline5: TextStyle(color: Colors.blueGrey),
          headline6: TextStyle(color: Colors.white60),
          caption: TextStyle(color: Colors.blueGrey),
          bodyText2: TextStyle(color: Colors.green),
        ),
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
