import 'package:flutter/material.dart';
import 'package:notado/constants/constants.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/screens/change_password/change_password_screen.dart';
import 'package:notado/screens/profile/profile_screen.dart';
import 'package:notado/screens/settings/bloc/visibility_bloc.dart';
import 'package:notado/screens/settings/settings_constants.dart';
import 'package:notado/screens/settings/terms_and_privacy_policy.dart';
import 'package:notado/theme/themes.dart';
import 'package:notado/user_repository/user_Repository.dart';

// class SettingsScreen extends StatefulWidget {
//   final UserRepository userRepository;

//   const SettingsScreen({Key key, @required this.userRepository})
//       : super(key: key);

//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }

// enum themeType { darkTheme, lightTheme }

// class _SettingsScreenState extends State<SettingsScreen> {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   themeType _themeType = themeType.lightTheme;
//   TextEditingController _newPassController;
//   TextEditingController _repeatPassController;
//   TextEditingController _passController;
//   var _formKey = GlobalKey<FormState>();
//   bool checkPassValid = true;

//   Future<bool> validateCurrentPassword(String password) async {
//     return await widget.userRepository.validatePassword(password);
//   }

//   @override
//   void initState() {
//     _passController = TextEditingController();
//     _newPassController = TextEditingController();
//     _repeatPassController = TextEditingController();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool status = Theme.of(context).brightness == Brightness.dark;
//     ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
//     // VisibilityBloc _visibilityBloc = Provider.of<VisibilityBloc>(context);

//     return ChangeNotifierProvider<VisibilityBloc>(
//       create: (context) => VisibilityBloc(),
//       child: Builder(
//         builder: (BuildContext context) => Scaffold(
//           key: _scaffoldKey,
//           appBar: AppBar(
//             backgroundColor: drawerBarColor,
//             title: Text(
//               'Settings',
//               // change pswrd   theme // terms and policy // app info
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w300,
//                 fontSize: 22,
//               ),
//             ),
//           ),
//           body: Container(
//             child: Padding(
//               padding: EdgeInsets.all(10.0),
//               child: Consumer<VisibilityBloc>(
//                 builder: (BuildContext context, _visibilityBloc, Widget child) {
//                   // final bool isPassVisible =
//                   //     Provider.of<VisibilityBloc>(context).isPassVis1;
//                   // final bool isNewPassVisible1 =
//                   //     Provider.of<VisibilityBloc>(context).isPassVis2;
//                   // final bool isNewPassVisible2 =
//                   //     Provider.of<VisibilityBloc>(context).isPassVis3;
//                   return ListenableProvider(
//                     create: (BuildContext context) => VisibilityBloc(),
//                     child: ListView(
//                       children: [
//                         ListTile(
//                           onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (BuildContext context) {
//                                 return ProfileScreen();
//                               },
//                             ),
//                           ),
//                           leading: Icon(Icons.person_outline),
//                           title: Text('My Profile'),
//                           trailing: Icon(Icons.arrow_right),
//                         ),
//                         ListTile(
//                           leading: Icon(FontAwesomeIcons.themeisle),
//                           title: Text('Dark Theme'),
//                           trailing: Switch(
//                               value: status,
//                               onChanged: (value) {
//                                 setState(() {
//                                   status = value;
//                                   status == true
//                                       ? _themeChanger.setTheme(ThemeData.dark())
//                                       : _themeChanger
//                                           .setTheme(ThemeData.light());
//                                 });
//                               }),
//                         ),
//                         ListTile(
//                           trailing: Icon(Icons.arrow_right),
//                           leading: Icon(Icons.lock_open),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           onTap: () => showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(7),
//                                 ),
//                                 title: Text('Change Password'),
//                                 content: SingleChildScrollView(
//                                   child: Form(
//                                     key: _formKey,
//                                     child: ListBody(
//                                       children: [
//                                         TextFormField(
//                                           controller: _passController,
//                                           obscureText:
//                                               _visibilityBloc.getisPass1(),
//                                           decoration: InputDecoration(
//                                             suffixIcon: IconButton(
//                                               onPressed: () => {
//                                                 _visibilityBloc.setisPass1(
//                                                     !_visibilityBloc
//                                                         .getisPass1()),
//                                               },
//                                               // onPressed: () => {
//                                               //   _visibilityBloc.setisPass1(
//                                               //       !isPassVisible),
//                                               // },
//                                               icon: _visibilityBloc.getisPass1()
//                                                   ? Icon(Icons.visibility)
//                                                   : Icon(Icons.visibility_off),
//                                             ),
//                                             errorText: checkPassValid == true
//                                                 ? null
//                                                 : 'Invalid Password',
//                                             prefixIcon:
//                                                 Icon(Icons.lock_outline),
//                                             labelText: 'Current Password',
//                                           ),
//                                         ),
//                                         TextFormField(
//                                           validator: (value) {
//                                             return value.length >= 6
//                                                 ? null
//                                                 : 'Password should not be less than 6 characters long';
//                                           },
//                                           controller: _newPassController,
//                                           obscureText:
//                                               _visibilityBloc.getisPass2(),
//                                           decoration: InputDecoration(
//                                             suffixIcon: IconButton(
//                                               onPressed: () => {
//                                                 _visibilityBloc.setisPass2(
//                                                     !_visibilityBloc
//                                                         .getisPass2()),
//                                               },
//                                               // onPressed: () => {
//                                               //   _visibilityBloc.setisPass2(
//                                               //       !isNewPassVisible1),
//                                               // },
//                                               icon: _visibilityBloc.getisPass2()
//                                                   ? Icon(Icons.visibility)
//                                                   : Icon(Icons.visibility_off),
//                                             ),
//                                             prefixIcon:
//                                                 Icon(Icons.lock_outline),
//                                             labelText: 'New Password',
//                                           ),
//                                         ),
//                                         TextFormField(
//                                           controller: _repeatPassController,
//                                           obscureText:
//                                               _visibilityBloc.getisPass3(),
//                                           decoration: InputDecoration(
//                                             suffixIcon: IconButton(
//                                               // onPressed: () => {
//                                               //   _visibilityBloc.setisPass3(
//                                               //       !_visibilityBloc
//                                               //           .getisPass3()),
//                                               // },
//                                               onPressed: () => {
//                                                 _visibilityBloc.setisPass3(
//                                                   !_visibilityBloc.getisPass3(),
//                                                 ),
//                                               },
//                                               icon: _visibilityBloc.getisPass3()
//                                                   ? Icon(Icons.visibility)
//                                                   : Icon(Icons.visibility_off),
//                                             ),
//                                             prefixIcon:
//                                                 Icon(Icons.lock_outline),
//                                             labelText: 'New Password',
//                                           ),
//                                           validator: (value) {
//                                             return _newPassController.text ==
//                                                     value
//                                                 ? null
//                                                 : 'The passswords doesn\' match';
//                                           },
//                                         ),
//                                         Padding(
//                                             padding: EdgeInsets.symmetric(
//                                                 vertical: 5)),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 actions: [
//                                   FlatButton(
//                                     onPressed: () {
//                                       _visibilityBloc.setisPass1(false);
//                                       _visibilityBloc.setisPass2(false);
//                                       _visibilityBloc.setisPass3(false);

//                                       Navigator.pop(context);
//                                     },
//                                     child: Text('Cancel'),
//                                   ),
//                                   FlatButton(
//                                     onPressed: () async {
//                                       // checkPassValid = await validateCurrentPassword(_passwordController.text),
//                                       checkPassValid = await widget
//                                           .userRepository
//                                           .validatePassword(
//                                               _passController.text);

//                                       if (checkPassValid == false)
//                                         // Scaffold.of(context).showSnackBar(
//                                         //   SnackBar(
//                                         //     content: Text('Invalid Password'),
//                                         //   ),
//                                         // );
//                                         setState(() {});

//                                       if (_formKey.currentState.validate() &&
//                                           checkPassValid) {
//                                         //TODO: update password
//                                         //TODO: show snackbar

//                                         Navigator.pop(context);
//                                       }
//                                     },
//                                     child: Text('Submit'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                           //  {
//                           //   _showDialogBox(context);

//                           //   // Navigator.push(context,
//                           //   //     MaterialPageRoute(builder: (BuildContext context) {
//                           //   //   return ChnangePasswordScreen(
//                           //   //     userRepository: widget.userRepository,
//                           //   //   );
//                           //   // }));
//                           // },
//                           title: Text('Change Password'),
//                         ),
//                         ListTile(
//                           onTap: () => showDialog(
//                               context: context,
//                               child: AlertDialog(
//                                 actions: [
//                                   FlatButton(
//                                     onPressed: () => Navigator.pop(context),
//                                     child: Text(
//                                       'Done',
//                                       style: normalStyle,
//                                     ),
//                                   ),
//                                 ],
//                                 content: SingleChildScrollView(
//                                     child: RichText(
//                                   text: TextSpan(
//                                     // text: terms,
//                                     style: TextStyle(
//                                       color: _themeType == themeType.lightTheme
//                                           ? Colors.black
//                                           : Colors.white,
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.w300,
//                                     ),
//                                     children: [
//                                       TextSpan(
//                                           text: headtas + '\n\n',
//                                           style: mainHeadingStyle),
//                                       TextSpan(
//                                           text: terms + '\n\n',
//                                           style: headingsStyle),
//                                       TextSpan(text: termsC + '\n\n'),
//                                       TextSpan(
//                                           text: license + '\n\n',
//                                           style: headingsStyle),
//                                       TextSpan(text: licenseC + '\n\n'),
//                                       TextSpan(
//                                           text: disclaimer + '\n\n',
//                                           style: headingsStyle),
//                                       TextSpan(text: disclaimerC + '\n\n'),
//                                       TextSpan(
//                                           text: limitations + '\n\n',
//                                           style: headingsStyle),
//                                       TextSpan(text: limitationsC + '\n\n'),
//                                       TextSpan(
//                                           text: accuracyOfMaterials + '\n\n',
//                                           style: headingsStyle),
//                                       TextSpan(
//                                           text: accuracyOfMaterialsC + '\n\n'),
//                                       TextSpan(
//                                           text: links + '\n\n',
//                                           style: headingsStyle),
//                                       TextSpan(text: linksC + '\n\n'),
//                                       TextSpan(
//                                           text: modifications + '\n\n',
//                                           style: headingsStyle),
//                                       TextSpan(text: modificationsC + '\n\n'),
//                                       TextSpan(
//                                           text: governingLaw + '\n\n',
//                                           style: headingsStyle),
//                                       TextSpan(text: governingLawC + '\n\n'),
//                                       TextSpan(
//                                           text: privacyPolicy + '\n\n',
//                                           style: headingsStyle),
//                                       TextSpan(text: privacyPolicyC + '\n\n'),
//                                     ],
//                                   ),
//                                 )),
//                               )),
//                           trailing: Icon(Icons.arrow_right),
//                           leading: Icon(Icons.event_note),
//                           title: Text('Terms and Privacy Policy'),
//                         ),

//                         //TODO: Implement theme change
//                         // Center(
//                         //   child: Container(
//                         //     decoration: BoxDecoration(
//                         //       borderRadius: BorderRadius.circular(10),
//                         //     ),
//                         //     height: 140,
//                         //     width: MediaQuery.of(context).size.width / 1.3,
//                         //     child: themeCard(isDarkTheme, _themeChanger),
//                         //   ),
//                         // ),
//                         ListTile(
//                           trailing: Icon(Icons.arrow_right),
//                           leading: Icon(Icons.error_outline),
//                           onTap: () => showAboutDialog(
//                               context: context,
//                               //TODO: Application Icon
//                               // applicationIcon: Icon(Icons.error),
//                               applicationVersion: 'v1.0.0',
//                               applicationName: 'Notado'),
//                           title: Text('About App'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

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
// }

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
                      return ChangePswrdDialog();
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
                  onTap: () => showDialog(
                      context: context,
                      child: AlertDialog(
                        actions: [
                          FlatButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Done',
                              style: normalStyle,
                            ),
                          ),
                        ],
                        content: SingleChildScrollView(
                            child:
                                TermsAndPrivacyPolicy(themeType: _themeType)),
                      )),
                  trailing: Icon(Icons.arrow_right),
                  leading: Icon(Icons.event_note),
                  title: Text('Terms and Privacy Policy'),
                ),
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

class TermsAndPrivacyPolicy extends StatelessWidget {
  const TermsAndPrivacyPolicy({
    Key key,
    @required themeType themeType,
  })  : _themeType = themeType,
        super(key: key);

  final themeType _themeType;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        // text: terms,
        style: TextStyle(
          color:
              _themeType == themeType.lightTheme ? Colors.black : Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w300,
        ),
        children: [
          TextSpan(text: headtas + '\n\n', style: mainHeadingStyle),
          TextSpan(text: terms + '\n\n', style: headingsStyle),
          TextSpan(text: termsC + '\n\n'),
          TextSpan(text: license + '\n\n', style: headingsStyle),
          TextSpan(text: licenseC + '\n\n'),
          TextSpan(text: disclaimer + '\n\n', style: headingsStyle),
          TextSpan(text: disclaimerC + '\n\n'),
          TextSpan(text: limitations + '\n\n', style: headingsStyle),
          TextSpan(text: limitationsC + '\n\n'),
          TextSpan(text: accuracyOfMaterials + '\n\n', style: headingsStyle),
          TextSpan(text: accuracyOfMaterialsC + '\n\n'),
          TextSpan(text: links + '\n\n', style: headingsStyle),
          TextSpan(text: linksC + '\n\n'),
          TextSpan(text: modifications + '\n\n', style: headingsStyle),
          TextSpan(text: modificationsC + '\n\n'),
          TextSpan(text: governingLaw + '\n\n', style: headingsStyle),
          TextSpan(text: governingLawC + '\n\n'),
          TextSpan(text: privacyPolicy + '\n\n', style: headingsStyle),
          TextSpan(text: privacyPolicyC + '\n\n'),
        ],
      ),
    );
  }
}

class ChangePswrdDialog extends StatefulWidget {
  final UserRepository userRepository;

  const ChangePswrdDialog({Key key, this.userRepository}) : super(key: key);
  @override
  _ChangePswrdDialogState createState() => _ChangePswrdDialogState();
}

class _ChangePswrdDialogState extends State<ChangePswrdDialog> {
  var _formKey = GlobalKey<FormState>();
  bool checkPassValid = true;
  bool isPassVisible = true;
  bool isNewPassVisible1 = true;
  bool isNewPassVisible2 = true;
  TextEditingController _newPassController;
  TextEditingController _repeatPassController;
  TextEditingController _passController;

  Future<bool> validateCurrentPassword(String password) async {
    return await widget.userRepository.validatePassword(password);
  }

  @override
  void initState() {
    _passController = TextEditingController();
    _newPassController = TextEditingController();
    _repeatPassController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      title: Text(
        'Change Password',
        style: TextStyle(fontSize: 25),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: ListBody(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passController,
                    obscureText: isPassVisible,
                    decoration: InputDecoration(
                      border: sScreenChangePsBorder,
                      enabledBorder: sScreenChangePsEBorder,
                      focusedBorder: sScreenChangePsFBorder,
                      suffixIcon: IconButton(
                          onPressed: () => {
                                setState(() {
                                  isPassVisible = !isPassVisible;
                                }),
                              },
                          icon: isPassVisible
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility)),
                      errorText:
                          checkPassValid == true ? null : 'Invalid Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      labelText: 'Current Password',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      return value.length >= 6
                          ? null
                          : 'Password should not be less than 6 characters long';
                    },
                    controller: _newPassController,
                    obscureText: isNewPassVisible1,
                    decoration: InputDecoration(
                      border: sScreenChangePsBorder,
                      enabledBorder: sScreenChangePsEBorder,
                      focusedBorder: sScreenChangePsFBorder,
                      suffixIcon: IconButton(
                          onPressed: () => {
                                setState(() {
                                  isNewPassVisible1 = !isNewPassVisible1;
                                }),
                              },
                          icon: isNewPassVisible1
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility)),
                      prefixIcon: Icon(Icons.lock_outline),
                      labelText: 'New Password',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _repeatPassController,
                    obscureText: isNewPassVisible2,
                    decoration: InputDecoration(
                      border: sScreenChangePsBorder,
                      enabledBorder: sScreenChangePsEBorder,
                      focusedBorder: sScreenChangePsFBorder,
                      suffixIcon: IconButton(
                          onPressed: () => {
                                setState(() {
                                  isNewPassVisible2 = !isNewPassVisible2;
                                }),
                              },
                          icon: isNewPassVisible2
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility)),
                      prefixIcon: Icon(Icons.lock_outline),
                      labelText: 'New Password',
                    ),
                    validator: (value) {
                      return _newPassController.text == value
                          ? null
                          : 'The passswords doesn\' match';
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              ],
            ),
          ),
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            isPassVisible = false;
            isNewPassVisible1 = false;
            isNewPassVisible2 = false;
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        FlatButton(
          onPressed: () async {
            // checkPassValid = await validateCurrentPassword(_passwordController.text),
            checkPassValid = await widget.userRepository
                .validatePassword(_passController.text);

            if (checkPassValid == false)
              // Scaffold.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text('Invalid Password'),
              //   ),
              // );
              setState(() {});

            if (_formKey.currentState.validate() && checkPassValid) {
              //TODO: update password
              //TODO: show snackbar

              isPassVisible = false;
              isNewPassVisible1 = false;
              isNewPassVisible2 = false;
              Navigator.pop(context);
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
