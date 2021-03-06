import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notado/authentication/authenticationBloc/authentication_bloc.dart';
import 'package:notado/authentication/authenticationBloc/authentication_event.dart';
import 'package:notado/constants/constants.dart';
import 'package:notado/enums/enums.dart';
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
  int typeSort = 1;
  bool _showNetworkError = false;
  final _borderRadius = BorderRadius.circular(70);
  TapGestureRecognizer _repoButton;
  setTypeSort(int val) {
    Navigator.pop(context);
    setState(() {
      typeSort = val;
    });
  }

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
  }

  @override
  void dispose() {
    viewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    var cScreenObject = Provider.of<CurrentScreenProvider>(context);
    print('currentScreen.......................' +
        cScreenObject.whichScreen.toString());

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
                onTap: () {
                  cScreenObject.whichScreen = currentScreen.settings;
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return SettingsScreen(
                          userRepository: widget.userRepository,
                        );
                      },
                    ),
                  );
                },
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
                  onTap: () {
                    cScreenObject.whichScreen = currentScreen.home;
                    Navigator.push(
                      context,
                      buildPageRouteBuilder(
                          HomeScreen(userRepository: widget.userRepository)),
                    );
                  },
                  leading: Icon(Icons.home, color: drawerBarColor),
                  title: Text('My Notes'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                            'This app is currently in development mode,\n please wait while we cook the recipe for you')));
                  },
                  leading:
                      Icon(FontAwesomeIcons.bookReader, color: drawerBarColor),
                  title: Text('Study notes'),
                ),
                ListTile(
                  onTap: () => {
                    Navigator.pop(context),
                    if (cScreenObject.whichScreen == currentScreen.trash)
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
                    cScreenObject.whichScreen = currentScreen.login;

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
          tooltip: '',
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
                        tooltip: 'Change view',
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
                      _scaffoldKey.currentState.hideCurrentSnackBar();

                      if (newValue == 'Sort by') {
                        return showDialog(
                          context: context,
                          child: AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  RadioListTile(
                                    value: 1,
                                    groupValue: typeSort,
                                    onChanged: (value) => {
                                      setTypeSort(value),
                                    },
                                    activeColor: Colors.lightGreen,
                                    title: Text('Name '),
                                  ),
                                  RadioListTile(
                                    value: 2,
                                    groupValue: typeSort,
                                    onChanged: (value) => {
                                      setTypeSort(value),
                                    },
                                    activeColor: Colors.lightGreen,
                                    title: Text('Date created'),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // _scaffoldKey.currentState
                                  //   ..hideCurrentSnackBar();
                                },
                                child: Text('Cancel'),
                              ),
                            ],
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
            stream: typeSort == 1
                ? widget.databaseService.notesZefyrFromTrashOrderByName
                : widget.databaseService.notesZefyrFromTrashOrderByDate,
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
                        subtitle: Text(
                          document['date'],
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 10),
                        ),
                        onLongPress: () => {
                          showDialog(
                            context: context,
                            child: AlertDialog(
                              content: Text(
                                'Are you sure you want to delete this note permanently ?',
                                style: TextStyle(
                                  fontSize: 13,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No'),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    widget.databaseService
                                        .deleteZefyrUserDataFromTrash(
                                            id: document['id']);
                                    Navigator.pop(context);

                                    Toast.show(
                                      'Deleted',
                                      context,
                                      gravity: Toast.CENTER,
                                      backgroundRadius: 10.0,
                                    );
                                  },
                                  child: Text('Yes'),
                                ),
                              ],
                            ),
                          ),
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
