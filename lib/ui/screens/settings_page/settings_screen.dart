import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notado/global/constants.dart';
import 'package:notado/ui/screens/settings_page/settings_constants.dart';
import 'package:notado/ui/screens/settings_page/terms_and_privacy_policy.dart';
import 'package:notado/ui/themes/theme.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Color typeColor = Colors.green;
  bool _showNetworkError = false;

  Future<bool> _checkConnection() async {
    if (await DataConnectionChecker().hasConnection) {
      setState(() {
        _showNetworkError = false;
      });
      return true;
    } else {
      setState(() {
        print('netwrok error');
        _showNetworkError = true;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.v('Settings Build');
    bool status = Theme.of(context).brightness == Brightness.dark;
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Theme.of(context).iconTheme.color,
            ),
        title: Text(
          'Settings',
          style: TextStyle(
            letterSpacing: 1.0,
            color: Theme.of(context).textTheme.headline5.color,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Account',
                    style: TextStyle(
                      color: typeColor,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.login_outlined),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline5.color,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Theme',
                    style: TextStyle(
                      color: typeColor,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.looks_outlined),
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline5.color,
                    ),
                  ),
                  trailing: Switch(
                    activeColor: typeColor,
                    value: status,
                    onChanged: (value) {
                      status = value;
                      status == true
                          ? _themeChanger.setTheme(appTheme.getDarkTheme())
                          : _themeChanger.setTheme(appTheme.getLightTheme());
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'About',
                    style: TextStyle(
                      color: typeColor,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.policy_outlined),
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
                            child: RichText(
                          text: TextSpan(
                            // text: terms,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                            children: [
                              TextSpan(
                                  text: headtas + '\n\n',
                                  style: mainHeadingStyle),
                              TextSpan(
                                  text: terms + '\n\n', style: headingsStyle),
                              TextSpan(text: termsC + '\n\n'),
                              TextSpan(
                                  text: license + '\n\n', style: headingsStyle),
                              TextSpan(text: licenseC + '\n\n'),
                              TextSpan(
                                  text: disclaimer + '\n\n',
                                  style: headingsStyle),
                              TextSpan(text: disclaimerC + '\n\n'),
                              TextSpan(
                                  text: limitations + '\n\n',
                                  style: headingsStyle),
                              TextSpan(text: limitationsC + '\n\n'),
                              TextSpan(
                                  text: accuracyOfMaterials + '\n\n',
                                  style: headingsStyle),
                              TextSpan(text: accuracyOfMaterialsC + '\n\n'),
                              TextSpan(
                                  text: links + '\n\n', style: headingsStyle),
                              TextSpan(text: linksC + '\n\n'),
                              TextSpan(
                                  text: modifications + '\n\n',
                                  style: headingsStyle),
                              TextSpan(text: modificationsC + '\n\n'),
                              TextSpan(
                                  text: governingLaw + '\n\n',
                                  style: headingsStyle),
                              TextSpan(text: governingLawC + '\n\n'),
                              TextSpan(
                                  text: privacyPolicy + '\n\n',
                                  style: headingsStyle),
                              TextSpan(text: privacyPolicyC + '\n\n'),
                            ],
                          ),
                        )),
                      )),
                  title: Text(
                    'Terms and Privacy Policy',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline5.color,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.support_outlined),
                  title: Text(
                    'Support Developers',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline5.color,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.feedback_outlined),
                  title: Text(
                    'Feedback',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline5.color,
                    ),
                  ),
                  onTap: () async {
                    String url =
                        ' mailto:notado.care@gmail.com?subject=User Experience@Notado';

                    if (await canLaunch(url) && await _checkConnection()) {
                      _checkConnection();
                      launch(url);
                    } else {
                      Toast.show(
                        'Network Error',
                        context,
                        backgroundColor: Colors.grey[400],
                        textColor: Colors.black,
                      );
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.star_outline_outlined),
                  title: Text(
                    'Rate Us',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline5.color,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text(
                    'Help',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline5.color,
                    ),
                  ),
                ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: <Widget>[
                //     Text(
                //       'Made with ❤️ in India',
                //       style: TextStyle(
                //         fontSize: 11,
                //         color: Theme.of(context).textTheme.headline5.color,
                //       ),
                //     ),
                //     Text(
                //       'Copyright © 2020 Dot.Studios LLC',
                //       style: TextStyle(
                //         fontSize: 11,
                //         color: Theme.of(context).textTheme.headline5.color,
                //       ),
                //     ),
                //   ],
                // ),
                ListTile(
                  title: Text(
                    'Miscellaneous',
                    style: TextStyle(
                      color: typeColor,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.policy_outlined),
                  title: Text(
                    'Version',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline5.color,
                    ),
                  ),
                  subtitle: Text('1.0.0'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
