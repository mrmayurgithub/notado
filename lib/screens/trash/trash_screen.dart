import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notado/authentication/authenticationBloc/authentication_bloc.dart';
import 'package:notado/authentication/authenticationBloc/authentication_event.dart';
import 'package:notado/constants/constants.dart';
import 'package:notado/global_variable.dart';
import 'package:notado/models/note_model.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/screens/addnote/ZefyrEdit.dart';
import 'package:notado/screens/home/home_screen.dart';
import 'package:notado/screens/login/login_screen.dart';
import 'package:notado/screens/profile/profile_screen.dart';
import 'package:notado/screens/settings/settings_screen.dart';
import 'package:notado/services/database.dart';
import 'package:notado/user_repository/user_Repository.dart';
import 'package:url_launcher/url_launcher.dart';

class TrashScreen extends StatefulWidget {
  final UserRepository userRepository;
  final DatabaseService databaseService;

  const TrashScreen(
      {Key key, @required this.userRepository, @required this.databaseService})
      : super(key: key);

  @override
  _TrashScreenState createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController viewController;
  bool islistView = true;

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
      title: Text(note.title),
      // subtitle: Text(formatter.format(note.date)),
    );
  }

  void _navigateToNoteDetails(Note note, Object index) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return ZefyrNote(
              // note: note,
              databaseService: widget.databaseService,
              userRepository: widget.userRepository);
        },
      ),
    );
  }

  Future<Null> refreshIt() async {
    setState(() {});
    // await Future.delayed(Duration(seconds: 2));
  }

  @override
  void initState() {
    // _loadNotes().then((onValue) {
    //   setState(() {
    //     //  _notes = onValue;
    //   });
    // }).catchError(print);
    viewController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
    currentScreen = whichScreen.trash;
  }

  @override
  void dispose() {
    viewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_notes.isEmpty) {
      content = Center(
        child: CircularProgressIndicator(), //1
      );
    } else {
      content = Container(
        height: 200,
        child: ListView.builder(
          //2
          itemCount: _notes.length,
          itemBuilder: _buildNoteListTile,
        ),
      );
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.green,
      ),
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text('Trash', style: TextStyle(color: Colors.black)),
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: GestureDetector(
                // Navigating to the settings screen when settings Icon is pressed
                onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) {
                      return SettingsScreen(
                        userRepository: widget.userRepository,
                      );
                    },
                  ),
                ),
                child: Icon(Icons.settings),
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
                  onTap: () => {
                    Navigator.push(
                      context,
                      buildPageRouteBuilder(
                          HomeScreen(userRepository: widget.userRepository)),
                    )
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
                  onTap: () => {
                    Navigator.pop(context),
                    if (currentScreen == whichScreen.home)
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text('You are already on the Trash Screen'),
                        ),
                      ),
                  },
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
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        resizeToAvoidBottomPadding: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {},
          child: Icon(FontAwesomeIcons.trash),
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 8.0,
          // elevation: 0.0,
          shape: CircularNotchedRectangle(),
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  child: Column(
                    children: [
                      IconButton(
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.list_view,
                          progress: viewController,
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
                      )
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.all(7),
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    underline: SizedBox(),
                    icon: Icon(Icons.more_vert, color: Colors.black),
                    iconSize: 24,
                    elevation: 0,
                    style: TextStyle(color: Colors.green),
                    onChanged: (String newValue) {
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
                              backgroundColor: Colors.green,
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
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: refreshIt,
          child: StreamBuilder(
            stream: widget.databaseService.notesZefyrFromTrash,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError)
                return Center(child: Text('ERROR'));
              else if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              return ListView(
                physics: BouncingScrollPhysics(),
                children: snapshot.data.documents.map<Widget>(
                  (document) {
                    Iterable list = json.decode(document['contents']);
                    print("......................................" +
                        list.runtimeType.toString());
                    List<Note> Cnote =
                        list.map((i) => Note.fromMap(i)).toList();
                    print(Cnote[0].title.toString() +
                        ".............................noteeeee\n");
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.grey[100],
                        title: Text(document['title']),
                        onLongPress: () => {
                          widget.databaseService
                              .deleteZefyrUserDataFromTrash(id: document['id']),
                        },
                        onTap: () => {
                          //TODO: add view note
                        },
                        // trailing: IconButton(
                        //   icon: Icon(Icons.undo_rounded),
                        //   onPressed: null,
                        //   tooltip: 'Restore',
                        // ),
                      ),
                    );
                  },
                ).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class selectableBloc with ChangeNotifier {
  bool _selectTile = false;
  getSelectTile() => _selectTile;
  setSelectTile() {
    _selectTile = !_selectTile;
    notifyListeners();
  }
}
