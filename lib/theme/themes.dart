import 'package:flutter/material.dart';

class MainTheme {
  MainTheme();
  ThemeData _darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    buttonColor: Color.fromARGB(14, 216, 206, 243),
    backgroundColor: Color(0xff3a375c),
    primaryColor: Color.fromARGB(255, 40, 37, 90),
    canvasColor: Color(0xff3a376c),
    accentColor: Colors.green[100],
    iconTheme: IconThemeData(color: Colors.white),
    splashColor: Colors.green[400],
    highlightColor: Color(0xffac8ae8),
    focusColor: Color.fromARGB(150, 80, 53, 232),
    hintColor: Color.fromARGB(100, 154, 109, 252),
    hoverColor: Color(0xff9479be),
    textTheme: ThemeData.dark().textTheme.copyWith(
          headline5: TextStyle(
            fontFamily: 'Roboto_Con',
            fontSize: 50,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Color(0xff766299),
                offset: Offset(0.0, 0.0),
                blurRadius: 15,
              ),
            ],
          ),
          headline6: TextStyle(
            fontFamily: 'Roboto_Con',
            fontSize: 56,
            color: Color(0xfffaf9ff),
            shadows: [
              Shadow(
                color: Color(0xffd6e0e9),
                offset: Offset(0.0, 0.0),
                blurRadius: 1,
              ),
            ],
          ),
          caption: TextStyle(
            fontFamily: 'Roboto',
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,
          ),
          subtitle1: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 17,
            color: Color(0xff7565c8),
          ),
          bodyText1: TextStyle(
            fontFamily: 'SourceSans',
            fontSize: 16,
            color: Colors.red[700],
          ),
        ),
  );

  ThemeData _lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    backgroundColor: Color(0xfffbfbfb),
    buttonColor: Color(0xfffbfbfb),
    primaryColor: Color(0xfffbfbfb),
    canvasColor: Color(0xfff5f5f5),
    accentColor: Color(0xffd6cef3),
    iconTheme: IconThemeData(color: Color(0xff333237)),
    splashColor: Colors.green[500],
    highlightColor: Colors.green[300],
    focusColor: Color(0xff5035e4),
    hintColor: Colors.green[400],
    hoverColor: Colors.green[200],
    floatingActionButtonTheme:
        FloatingActionButtonThemeData().copyWith(backgroundColor: Colors.green),
    textTheme: ThemeData.light().textTheme.copyWith(
          headline5: TextStyle(
            fontFamily: 'Roboto_Con',
            fontSize: 50,
            color: Color(0xff1d2440),
            shadows: [
              Shadow(
                color: Color(0xffd6e0e9),
                offset: Offset(0.0, 0.0),
                blurRadius: 15,
              ),
            ],
          ),
          headline6: TextStyle(
            fontFamily: 'Roboto_Con',
            fontSize: 56,
            color: Color(0xfffaf9ff),
            shadows: [
              Shadow(
                color: Color(0xffd6e0e9),
                offset: Offset(0.0, 0.0),
                blurRadius: 1,
              ),
            ],
          ),
          caption: TextStyle(
            fontFamily: 'Roboto',
            color: Color(0xff404047),
            fontSize: 20,
          ),
          subtitle1: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 17,
            color: Colors.green,
          ),
          bodyText1: TextStyle(
            fontFamily: 'SourceSans',
            fontSize: 16,
            color: Colors.green[700],
          ),
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
