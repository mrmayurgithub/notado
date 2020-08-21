import 'package:flutter/material.dart';
import 'package:notado/constants/constants.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/screens/change_password/change_password_screen.dart';
import 'package:notado/screens/profile/profile_screen.dart';
import 'package:notado/theme/themes.dart';
import 'package:notado/user_repository/user_Repository.dart';

class SettingsScreen extends StatefulWidget {
  final UserRepository userRepository;

  const SettingsScreen({Key key,@required this.userRepository}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

enum themeType { darkTheme, lightTheme }

class _SettingsScreenState extends State<SettingsScreen> {
  themeType _themeType = themeType.lightTheme;
  @override
  Widget build(BuildContext context) {
    bool status = Theme.of(context).brightness == Brightness.dark;

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: drawerBarColor,
        title: Text(
          'Settings',
          // change pswrd   theme // terms and policy // app info
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 22,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            // color: Colors.black54
            // gradient: LinearGradient(
            //   end: Alignment.bottomRight,
            //   begin: Alignment.topLeft,
            //   colors: status == true
            //       ? [
            //           Colors.black,
            //           Colors.black,
            //           Colors.black,
            //           Colors.black,

            //           Colors.black87,

            //           Colors.black87,
            //           Colors.black54,

            //           Colors.black54,
            //           Colors.black45,

            //           Colors.black38,
            //           Colors.black26,
            //           Colors.black12,
            //           // Colors.white38
            //         ]
            //       : [],
            // ),
            ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: [
              ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProfileScreen();
                    },
                  ),
                ),
                leading: Icon(Icons.person_outline),
                title: Text('My Profile'),
                trailing: Icon(Icons.arrow_right),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.themeisle),
                title: Text('Dark Theme'),
                trailing: Switch(
                    value: status,
                    onChanged: (value) {
                      setState(() {
                        status = value;
                        status == true
                            ? _themeChanger.setTheme(ThemeData.dark())
                            : _themeChanger.setTheme(ThemeData.light());
                      });
                    }),
              ),
              ListTile(
                trailing: Icon(Icons.arrow_right),
                leading: Icon(Icons.lock_open),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return ChnangePasswordScreen(
                      userRepository: widget.userRepository,
                    );
                  }));
                },
                title: Text('Change Password'),
              ),
              ListTile(
                onTap: () {},
                trailing: Icon(Icons.arrow_right),
                leading: Icon(Icons.event_note),
                title: Text('Terms and Privacy Policy'),
              ),

              //TODO: Implement theme change
              // Center(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     height: 140,
              //     width: MediaQuery.of(context).size.width / 1.3,
              //     child: themeCard(isDarkTheme, _themeChanger),
              //   ),
              // ),
              ListTile(
                trailing: Icon(Icons.arrow_right),
                leading: Icon(Icons.error_outline),
                onTap: () => showAboutDialog(
                    context: context,
                    //TODO: Application Icon
                    // applicationIcon: Icon(Icons.error),
                    applicationVersion: 'v1.0.0',
                    applicationName: 'Notado'),
                title: Text('About App'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card themeCard(bool isDarkTheme, ThemeChanger _themeChanger) {
  //   return Card(
  //     shadowColor: Colors.transparent,
  //     color: Theme.of(context).scaffoldBackgroundColor,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //     child: Padding(
  //       padding: EdgeInsets.all(6),
  //       child: ListView(
  //         children: [
  //           ListTile(
  //             onTap: () {
  //               setState(() {
  //                 isDarkTheme
  //                     ? {
  //                         _themeChanger.setTheme(ThemeData.light()),
  //                         _themeType = themeType.darkTheme
  //                       }
  //                     : null;
  //               });
  //             },
  //             title: Text('Light Theme'),
  //             leading: Radio(
  //               value: _themeType,
  //               groupValue: themeType.darkTheme,
  //               onChanged: (value) {
  //                 setState(
  //                   () {
  //                     _themeChanger.setTheme(ThemeData.light());
  //                     _themeType = themeType.darkTheme;
  //                   },
  //                 );
  //               },
  //             ),
  //           ),
  //           ListTile(
  //             onTap: () {
  //               setState(() {
  //                 isDarkTheme == false
  //                     ? {
  //                         _themeChanger.setTheme(ThemeData.dark()),
  //                         _themeType = themeType.lightTheme
  //                       }
  //                     : null;
  //               });
  //             },
  //             title: Text('Dark Theme'),
  //             leading: Radio(
  //               value: _themeType,
  //               groupValue: themeType.lightTheme,
  //               onChanged: (value) {
  //                 setState(
  //                   () {
  //                     _themeChanger.setTheme(ThemeData.dark());
  //                     _themeType = themeType.lightTheme;
  //                   },
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
