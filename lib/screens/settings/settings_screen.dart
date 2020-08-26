import 'package:flutter/material.dart';
import 'package:notado/constants/constants.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/screens/change_password/change_password_screen.dart';
import 'package:notado/screens/profile/profile_screen.dart';
import 'package:notado/theme/themes.dart';
import 'package:notado/user_repository/user_Repository.dart';

class SettingsScreen extends StatefulWidget {
  final UserRepository userRepository;

  const SettingsScreen({Key key, @required this.userRepository})
      : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

enum themeType { darkTheme, lightTheme }

class _SettingsScreenState extends State<SettingsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  themeType _themeType = themeType.lightTheme;
  TextEditingController _newPassController;
  TextEditingController _repeatPassController;
  TextEditingController _passController;
  var _formKey = GlobalKey<FormState>();
  bool checkPassValid = false;

  Future<bool> validateCurrentPassword(String password) async {
    return await widget.userRepository.validatePassword(password);
  }

  // Future<void> _showDialogBox(BuildContext context) {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(7),
  //         ),
  //         title: Text('Change Password'),
  //         content: SingleChildScrollView(
  //           child: Form(
  //             child: ListBody(
  //               children: [
  //                 TextFormField(
  //                   // validator: (value) => widget.userRepository.getUser().curre,
  //                   decoration: InputDecoration(
  //                     prefixIcon: Icon(Icons.lock_outline),
  //                     labelText: 'Enter current Password',
  //                   ),
  //                 ),
  //                 TextFormField(
  //                   decoration: InputDecoration(
  //                     prefixIcon: Icon(Icons.lock_outline),
  //                     labelText: 'Enter new Password',
  //                   ),
  //                 ),
  //                 TextFormField(
  //                   decoration: InputDecoration(
  //                     prefixIcon: Icon(Icons.lock_outline),
  //                     labelText: 'Enter new Password',
  //                   ),
  //                 ),
  //                 Padding(padding: EdgeInsets.symmetric(vertical: 5)),
  //               ],
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           FlatButton(
  //             onPressed: () {},
  //             child: Text('Cancel'),
  //           ),
  //           FlatButton(
  //             onPressed: () {},
  //             child: Text('Submit'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    _passController = TextEditingController();
    _newPassController = TextEditingController();
    _repeatPassController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool status = Theme.of(context).brightness == Brightness.dark;
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      key: _scaffoldKey,
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
      body: Builder(
        builder: (BuildContext context) => Container(
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
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        title: Text('Change Password'),
                        content: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: ListBody(
                              children: [
                                TextFormField(
                                  // validator: (value) => widget.userRepository.getUser().curre,
                                  controller: _passController,
                                  validator: (value) {},
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock_outline),
                                    labelText: 'Current Password',
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    return value.length >= 6
                                        ? null
                                        : 'Password should not be less than 6 characters long';
                                  },
                                  controller: _newPassController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock_outline),
                                    labelText: 'New Password',
                                  ),
                                ),
                                TextFormField(
                                  controller: _repeatPassController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock_outline),
                                    labelText: 'New Password',
                                  ),
                                  validator: (value) {
                                    return _newPassController.text == value
                                        ? null
                                        : 'The passswords doesn\' match';
                                  },
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5)),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          FlatButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          FlatButton(
                            onPressed: () async {
                              // checkPassValid = await validateCurrentPassword(_passwordController.text),
                              checkPassValid = await widget.userRepository
                                  .validatePassword(_passController.text);
                              // print(checkPassValid);

                              if (_formKey.currentState.validate()) {
                                //TODO: update password
//TODO: show snackbar
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Submit'),
                          ),
                        ],
                      );
                    },
                  ),
                  //  {
                  //   _showDialogBox(context);

                  //   // Navigator.push(context,
                  //   //     MaterialPageRoute(builder: (BuildContext context) {
                  //   //   return ChnangePasswordScreen(
                  //   //     userRepository: widget.userRepository,
                  //   //   );
                  //   // }));
                  // },
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
