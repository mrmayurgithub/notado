import 'package:flutter/material.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/theme/themes.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

enum themeType { darkTheme, lightTheme }

class _SettingsScreenState extends State<SettingsScreen> {
  themeType _themeType = themeType.lightTheme;
  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: Drawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //TODO: Implement theme change
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              height: 140,
              width: MediaQuery.of(context).size.width / 1.3,
              child: themeCard(isDarkTheme, _themeChanger),
            ),
          ),

          Center(
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'About App',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card themeCard(bool isDarkTheme, ThemeChanger _themeChanger) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(6),
        child: ListView(
          children: [
            ListTile(
              onTap: () {
                setState(() {
                  isDarkTheme
                      ? {
                          _themeChanger.setTheme(ThemeData.light()),
                          _themeType = themeType.darkTheme
                        }
                      : null;
                });
              },
              title: Text('Light Theme'),
              leading: Radio(
                value: _themeType,
                groupValue: themeType.darkTheme,
                onChanged: (value) {
                  setState(
                    () {
                      _themeChanger.setTheme(ThemeData.light());
                      _themeType = themeType.darkTheme;
                    },
                  );
                },
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  isDarkTheme == false
                      ? {
                          _themeChanger.setTheme(ThemeData.dark()),
                          _themeType = themeType.lightTheme
                        }
                      : null;
                });
              },
              title: Text('Dark Theme'),
              leading: Radio(
                value: _themeType,
                groupValue: themeType.lightTheme,
                onChanged: (value) {
                  setState(
                    () {
                      _themeChanger.setTheme(ThemeData.dark());
                      _themeType = themeType.lightTheme;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
