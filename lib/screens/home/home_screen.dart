import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notado/global_variable.dart';
import 'package:notado/models/note_model.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/authentication/authenticationBloc/authentication_bloc.dart';
import 'package:notado/authentication/authenticationBloc/authentication_event.dart';
import 'package:notado/constants/constants.dart';
import 'package:notado/screens/addnote/ZefyrEdit.dart';
import 'package:notado/screens/draw/draw_screen.dart';
import 'package:notado/screens/login/login_screen.dart';
import 'package:notado/screens/profile/profile_screen.dart';
import 'package:notado/screens/search/search_screen.dart';
import 'package:notado/screens/settings/settings_screen.dart';
import 'package:notado/screens/trash/trash_screen.dart';
import 'package:notado/services/database.dart';
import 'package:notado/user_repository/user_Repository.dart';
import 'package:url_launcher/url_launcher.dart';

// class selectNotesNotifier extends ChangeNotifier {
//   bool _isSelecting = false;
//   get selectingOrNot => _isSelecting;
//   changeSelect() {
//     _isSelecting = !_isSelecting;
//     notifyListeners();
//   }
// }

class HomeScreen extends StatefulWidget {
  final UserRepository userRepository;

  const HomeScreen({Key key, @required this.userRepository}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController viewController;
  bool islistView = true;
  String uid;
  String userCard;
  var h = 1001.0694778740428;
  final w = 462.03206671109666;
  double homeScreenIconSize = 20.0 / 1001.0694778740428;

  getUserEmail() async {
    userCard = await widget.userRepository.getUser();
  }

  _getUID() async {
    uid = await widget.userRepository.getUID();
  }

  bool _showNetworkError = false;
  final _borderRadius = BorderRadius.circular(70);
  TapGestureRecognizer _repoButton;
  void _launchUrl(String url) async {
    if (await canLaunch(url) && await _checkConnection()) {
      _checkConnection();
      launch(url);
    } else {
      setState(() {
        print('netwrok error');
        _showNetworkError = true;
      });
    }
  }

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

  List<Note> _notes = [];
  final formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
  // Future<void> _loadNotes() async {
  //   final jsonResponse =
  //       await DefaultAssetBundle.of(context).loadString("assets/text.json");

  //   setState(() {
  //     _notes = Note.allFromResponse(jsonResponse);
  //   });
  // }

  Widget _buildNoteListTile(BuildContext context, int index) {
    var note = _notes[index];

    return new ListTile(
      onTap: () => _navigateToNoteDetails(note, index),
      title: Text(
        note.title,
        // style: TextStyle(color: Colors.green[600]),
      ),
      subtitle: Text(formatter.format(note.date)),
    );
  }

  void _navigateToNoteDetails(Note note, Object index) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return ZefyrNote(
            // note: note,
            databaseService: DatabaseService(uid: uid),
            userRepository: widget.userRepository,
          );
        },
      ),
    );
  }

  Future<Null> refreshIt() async {
    setState(() {});
    // await Future.delayed(Duration(seconds: 5));
  }

  @override
  void initState() {
    // _loadNotes().then((onValue) {
    //   setState(() {
    //     //  _notes = onValue;
    //   });
    // }).catchError(print);
    getUserEmail();
    _getUID();
    viewController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
    currentScreen = whichScreen.home;
  }

  @override
  void dispose() {
    viewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    final height = MediaQuery.of(context).size.height;

    if (_notes.isEmpty) {
      content = Center(
        child: CircularProgressIndicator(), //1
      );
    } else {
      content = ListView.builder(
        shrinkWrap: true,
        //2
        itemCount: _notes.length,
        itemBuilder: _buildNoteListTile,
      );
    }
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            // Pageroutebuilder for implementing different a transition between screens
            PageRouteBuilder(
              //Navigating to the addnte screen when FAB is pressed
              pageBuilder: (context, animation, secondaryAnimation) =>
                  // AddNote(userRepository: widget.userRepository),
                  ZefyrNote(
                databaseService: DatabaseService(uid: uid),
                userRepository: widget.userRepository,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = Offset(0, 1);
                var end = Offset.zero;
                var curve = Curves.easeInOutQuad;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                //var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
                return SlideTransition(
                    position: animation.drive(tween), child: child);
                //return FadeTransition(opacity: animation.drive(tween), child: child);
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        // color: Colors.white,
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 45,
                    child: IconButton(
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.list_view,
                        progress: viewController,
                        size: homeScreenIconSize * height,
                      ),
                      onPressed: () {
                        islistView
                            ? viewController.forward()
                            : viewController.reverse();
                        islistView = !islistView;
                        if (!islistView)
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  'The app is currently in development mode, please wait while we cook the recipe for this.')));
                      },
                    ),
                  ),
                  Container(
                    height: 45,
                    child: IconButton(
                      icon: Icon(Icons.brush),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return DrawScreen(
                              userRepository: widget.userRepository);
                        }));
                      },
                    ),
                  ),
                ],
              ),
              Container(
                height: 45,
                padding: EdgeInsets.all(7),
                child: DropdownButton<String>(
                  // dropdownColor: Colors.white,
                  underline: SizedBox(),
                  icon: Icon(
                    Icons.more_vert,
                    //  color: Colors.black,
                  ),
                  iconSize: homeScreenIconSize * height,
                  elevation: 0,
                  // style: TextStyle(color: Colors.green),
                  onChanged: (String newValue) {
                    _scaffoldKey.currentState.hideCurrentSnackBar();

                    if (newValue == 'Sort by') {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 20),
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          content: AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            // backgroundColor: Colors.green,
                            title: Text('Sort By'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  ListTile(
                                    leading: Radio(
                                      value: false,
                                      groupValue: null,
                                      onChanged: null,
                                    ),
                                    title: Text('Name '),
                                  ),
                                  ListTile(
                                    leading: Radio(
                                      value: false,
                                      groupValue: null,
                                      onChanged: null,
                                    ),
                                    title: Text('Date created'),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  // Navigator.pop(context);
                                  _scaffoldKey.currentState
                                    ..hideCurrentSnackBar();
                                },
                                child: Text('Cancel'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  items: <String>['Select Notes', 'Sort by']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                      onTap: null,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('My Notes', style: TextStyle(color: Colors.black)),
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.all(4.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    return SearchScreen(
                      userRepository: widget.userRepository,
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    return SettingsScreen(
                      userRepository: widget.userRepository,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        elevation: 0.0,
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: ListView(
            children: [
              Card(
                elevation: 0.0,
                child: Container(
                  height: 80,
                  child: Center(
                    child: Text(
                      'Notado',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 40,
                        letterSpacing: 2,
                        color: drawerBarColor,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                // onTap: () => Navigator.push(
                //   context,
                //   buildPageRouteBuilder(HomeScreen(user: null)),
                // ),
                onTap: () => {
                  Navigator.pop(context),
                  if (currentScreen == whichScreen.home)
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text('You are already on the Home Screen'),
                      ),
                    ),
                },
                leading: Icon(Icons.home, color: drawerBarColor),
                title: Text('Home'),
              ),
              ListTile(
                onTap: () => Navigator.push(
                  context,
                  buildPageRouteBuilder(ProfileScreen()),
                ),
                leading: Icon(Icons.person, color: drawerBarColor),
                title: Text('Profile'),
              ),
              ListTile(
                onTap: () => Navigator.push(
                  context,
                  buildPageRouteBuilder(TrashScreen(
                      userRepository: widget.userRepository,
                      databaseService: DatabaseService(uid: uid))),
                ),
                leading: Icon(FontAwesomeIcons.trash, color: drawerBarColor),
                title: Text('Trash'),
              ),
              ListTile(
                onTap: () => {},
                leading: Icon(FontAwesomeIcons.star, color: drawerBarColor),
                title: Text('Rate us'),
              ),
              ListTile(
                onTap: () => {
                  print('Contact us pressed'),
                  _launchUrl(
                      'mailto:notado.care@gmail.com?subject=User Experience@Notado')
                },
                leading: Icon(Icons.contact_mail, color: drawerBarColor),
                title: Text('Contact us'),
              ),
              ListTile(
                onTap: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(
                    LoggedOut(),
                  );
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 440),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          LoginScreen(userRepository: widget.userRepository),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = Offset(0, 1);
                        var end = Offset.zero;
                        var curve = Curves.easeInOutQuad;
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        //var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

                        return SlideTransition(
                            position: animation.drive(tween), child: child);
                        //return FadeTransition(opacity: animation.drive(tween), child: child);
                      },
                    ),
                  );
                },
                leading:
                    Icon(FontAwesomeIcons.signOutAlt, color: drawerBarColor),
                title: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.black,
        onRefresh: refreshIt,
        child: StreamBuilder(
          stream: DatabaseService(uid: uid).notesZefyrFromNotes,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError)
              return Center(child: Text('ERROR'));
            else if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.green,
              ));
            return ListView(
              physics: BouncingScrollPhysics(),
              children: snapshot.data.documents.map<Widget>(
                (document) {
                  var Cnote =
                      Note.allFromResponse(json.decode(document['contents']));
                  // var Cnote = json.decode(document['contents']);
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ListTile(
                      // tileColor: Colors.grey[100],
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ZefyrNote(
                          userRepository: widget.userRepository,
                          databaseService: DatabaseService(uid: uid),
                          contents: document['contents'],
                        );
                      })),
                      // title: Text(Cnote['insert'].toString()),
                      onLongPress: () => {
                        DatabaseService(uid: uid).deleteZefyrUserDataFromNotes(
                          contents: document['contents'],
                          id: document['id'],
                        ),
                      },
                    ),
                  );
                },
              ).toList(),
            );
          },
        ),
      ),
    );
  }
}

PageRouteBuilder buildPageRouteBuilder(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(-1, 0);
      var end = Offset.zero;
      var curve = Curves.easeInOutQuad;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      //var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
      //return FadeTransition(opacity: animation.drive(tween), child: child);
    },
  );
}
