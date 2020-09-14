import 'dart:convert';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notado/enums/enums.dart';
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

// class HomeScreen extends StatefulWidget {
//   final UserRepository userRepository;
//   final String uid;
//   final String userEmail;
//   final String photoUrl;
//   final String displayName;
//   final AsyncSnapshot snapshot;

//   const HomeScreen({
//     Key key,
//     @required this.userRepository,
//     this.uid,
//     this.userEmail,
//     this.photoUrl,
//     this.snapshot,
//     this.displayName,
//   }) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   AnimationController viewController;
//   bool islistView = true;
//   String uid;
//   var h = 1001.0694778740428;
//   final w = 462.03206671109666;
//   double homeScreenIconSize = 20.0 / 1001.0694778740428;
//   String photoUrl;
//   String displayName = "Username";
//   String userEmail;
//   AsyncSnapshot snapshot;
//   sortType sort = sortType.name;
//   int typeSort = 1;
//   setTypeSort(int val) {
//     Navigator.pop(context);
//     setState(() {
//       typeSort = val;
//     });
//   }

//   @override
//   void initState() {
//     // _loadNotes().then((onValue) {
//     //   setState(() {
//     //     //  _notes = onValue;
//     //   });
//     // }).catchError(print);
//     userEmail = widget.userEmail;
//     uid = widget.uid;
//     photoUrl = widget.photoUrl;
//     displayName = widget.displayName;
//     snapshot = widget.snapshot;
//     viewController =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 500));
//     super.initState();
//     nmode = noteMode.newNote;
//     currentScreen = whichScreen.home;
//   }

//   bool _showNetworkError = false;
//   final _borderRadius = BorderRadius.circular(70);
//   TapGestureRecognizer _repoButton;
//   void _launchUrl(String url) async {
//     if (await canLaunch(url) && await _checkConnection()) {
//       _checkConnection();
//       launch(url);
//     } else {
//       setState(() {
//         print('netwrok error');
//         _showNetworkError = true;
//       });
//     }
//   }

//   Future<bool> _checkConnection() async {
//     if (await DataConnectionChecker().hasConnection) {
//       setState(() {
//         _showNetworkError = false;
//       });
//       return true;
//     } else {
//       setState(() {
//         print('netwrok error');
//         _showNetworkError = true;
//       });
//       return false;
//     }
//   }

//   @override
//   void didUpdateWidget(HomeScreen oldWidget) {
//     if (widget.snapshot != oldWidget.snapshot) snapshot = widget.snapshot;

//     super.didUpdateWidget(oldWidget);
//   }

//   // @override
//   // void didUpdateWidget(HomeScreen oldWidget) {
//   //   super.didUpdateWidget(oldWidget);
//   //   if (widget.snapshot != oldWidget.snapshot) {
//   //     setState(() {});
//   //   }
//   // }

//   List<Note> _notes = [];
//   final formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
//   // Future<void> _loadNotes() async {
//   //   final jsonResponse =
//   //       await DefaultAssetBundle.of(context).loadString("assets/text.json");

//   //   setState(() {
//   //     _notes = Note.allFromResponse(jsonResponse);
//   //   });
//   // }

//   Widget _buildNoteListTile(BuildContext context, int index) {
//     var note = _notes[index];

//     return new ListTile(
//       onTap: () => _navigateToNoteDetails(note, index),
//       title: Text(
//         note.title,
//         // style: TextStyle(color: Colors.green[600]),
//       ),
//       // subtitle: Text(formatter.format(note.date)),
//     );
//   }

//   void _navigateToNoteDetails(Note note, Object index) {
//     Navigator.of(context).push(
//       new MaterialPageRoute(
//         builder: (c) {
//           return ZefyrNote(
//             // note: note,
//             databaseService: DatabaseService(uid: uid),
//             userRepository: widget.userRepository,
//           );
//         },
//       ),
//     );
//   }

//   Future<Null> refreshIt() async {
//     await Future.delayed(Duration(seconds: 2));
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     viewController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget content;
//     final height = MediaQuery.of(context).size.height;
//     if (_notes.isEmpty) {
//       content = Center(
//         child: CircularProgressIndicator(), //1
//       );
//     } else {
//       content = ListView.builder(
//         shrinkWrap: true,
//         //2
//         itemCount: _notes.length,
//         itemBuilder: _buildNoteListTile,
//       );
//     }
//     return Scaffold(
//       drawerEnableOpenDragGesture: true,
//       key: _scaffoldKey,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       resizeToAvoidBottomPadding: false,
//       floatingActionButton: FloatingActionButton(
//         // backgroundColor: Colors.green,
//         onPressed: () {
//           nmode = noteMode.newNote;
//           Navigator.push(
//             context,
//             // Pageroutebuilder for implementing different a transition between screens
//             PageRouteBuilder(
//               //Navigating to the addnte screen when FAB is pressed
//               pageBuilder: (context, animation, secondaryAnimation) =>
//                   // AddNote(userRepository: widget.userRepository),
//                   ZefyrNote(
//                 databaseService: DatabaseService(uid: uid),
//                 userRepository: widget.userRepository,
//               ),
//               transitionsBuilder:
//                   (context, animation, secondaryAnimation, child) {
//                 var begin = Offset(0, 1);
//                 var end = Offset.zero;
//                 var curve = Curves.easeInOutQuad;
//                 var tween = Tween(begin: begin, end: end)
//                     .chain(CurveTween(curve: curve));
//                 //var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
//                 return SlideTransition(
//                     position: animation.drive(tween), child: child);
//                 //return FadeTransition(opacity: animation.drive(tween), child: child);
//               },
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         // color: Colors.white,
//         notchMargin: 8.0,
//         shape: CircularNotchedRectangle(),
//         child: Padding(
//           padding: EdgeInsets.all(5.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     height: 45,
//                     child: IconButton(
//                       icon: AnimatedIcon(
//                         icon: AnimatedIcons.list_view,
//                         progress: viewController,
//                         size: homeScreenIconSize * height,
//                       ),
//                       onPressed: () {
//                         islistView
//                             ? viewController.forward()
//                             : viewController.reverse();
//                         islistView = !islistView;
//                         if (!islistView)
//                           _scaffoldKey.currentState.showSnackBar(SnackBar(
//                               content: Text(
//                                   'The app is currently in development mode, please wait while we cook the recipe for this.')));
//                       },
//                     ),
//                   ),
//                   Container(
//                     height: 45,
//                     child: IconButton(
//                       icon: Icon(Icons.brush),
//                       onPressed: () {
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (BuildContext context) {
//                           return DrawScreen(
//                               userRepository: widget.userRepository);
//                         }));
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 height: 45,
//                 padding: EdgeInsets.all(7),
//                 child: DropdownButton<String>(
//                   // dropdownColor: Colors.white,
//                   underline: SizedBox(),
//                   icon: Icon(
//                     Icons.more_vert,
//                     //  color: Colors.black,
//                   ),
//                   iconSize: homeScreenIconSize * height,
//                   elevation: 0,
//                   // style: TextStyle(color: Colors.green),
//                   onChanged: (String newValue) {
//                     _scaffoldKey.currentState.hideCurrentSnackBar();

//                     if (newValue == 'Sort by') {
//                       return showDialog(
//                         context: context,
//                         child: AlertDialog(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           content: SingleChildScrollView(
//                             child: ListBody(
//                               children: [
//                                 RadioListTile(
//                                   value: 1,
//                                   groupValue: typeSort,
//                                   onChanged: (value) => {
//                                     setTypeSort(value),
//                                   },
//                                   activeColor: Colors.lightGreen,
//                                   title: Text('Name '),
//                                 ),
//                                 RadioListTile(
//                                   value: 2,
//                                   groupValue: typeSort,
//                                   onChanged: (value) => {
//                                     setTypeSort(value),
//                                   },
//                                   activeColor: Colors.lightGreen,
//                                   title: Text('Date created'),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           actions: [
//                             FlatButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                                 // _scaffoldKey.currentState
//                                 //   ..hideCurrentSnackBar();
//                               },
//                               child: Text('Cancel'),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                   },
//                   items: <String>['Select Notes', 'Sort by']
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                       onTap: null,
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.black),
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         //  title: Text('My Notes', style: TextStyle(color: Colors.black)),
//         elevation: 0,
//         actions: [
//           Padding(
//             padding: EdgeInsets.all(4.0),
//             child: IconButton(
//               icon: Icon(Icons.search),
//               onPressed: () => Navigator.push(
//                 context,
//                 CupertinoPageRoute(
//                   builder: (context) {
//                     return SearchScreen(
//                       userRepository: widget.userRepository,
//                       uid: uid,
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(4.0),
//             child: GestureDetector(
//               child: photoUrl == null
//                   ? CircleAvatar(backgroundColor: Colors.green)
//                   : ClipRRect(
//                       borderRadius: BorderRadius.circular(30),
//                       child: Hero(
//                         tag: 'profilepic',
//                         child: Image(
//                           image: NetworkImage(
//                             photoUrl,
//                           ),
//                         ),
//                       ),
//                     ),
//               onTap: () {
//                 return showDialog(
//                   context: context,
//                   child: AlertDialog(
//                     content: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: ListTile(
//                         contentPadding: EdgeInsets.all(0),
//                         leading: Hero(
//                           tag: 'profilepic',
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(30),
//                             child: Image(
//                               image: NetworkImage(
//                                 photoUrl,
//                               ),
//                             ),
//                           ),
//                         ),
//                         title: Text(
//                           displayName,
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 15,
//                           ),
//                         ),
//                         subtitle: Text(
//                           userEmail,
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 11,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         elevation: 0.0,
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           color: Colors.white,
//           child: ListView(
//             children: [
//               Card(
//                 elevation: 0.0,
//                 child: Container(
//                   height: 80,
//                   child: Center(
//                     child: Text(
//                       'Notado',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w300,
//                         fontSize: 40,
//                         letterSpacing: 2,
//                         color: drawerBarColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               ListTile(
//                 onTap: () => {
//                   Navigator.pop(context),
//                   if (currentScreen == whichScreen.home)
//                     _scaffoldKey.currentState.showSnackBar(
//                       SnackBar(
//                         content: Text('You are already on the Home Screen'),
//                       ),
//                     ),
//                 },
//                 leading: Icon(Icons.note, color: drawerBarColor),
//                 title: Text('My Notes'),
//               ),
//               ListTile(
//                 onTap: () {
//                   Navigator.pop(context);
//                   _scaffoldKey.currentState.showSnackBar(SnackBar(
//                       content: Text(
//                           'This app is currently in development mode,\n please wait while we cook the recipe for you')));
//                 },
//                 leading:
//                     Icon(FontAwesomeIcons.bookReader, color: drawerBarColor),
//                 title: Text('Study notes'),
//               ),
//               ListTile(
//                 onTap: () => Navigator.push(
//                   context,
//                   buildPageRouteBuilder(
//                     TrashScreen(
//                       userRepository: widget.userRepository,
//                       databaseService: DatabaseService(uid: uid),
//                     ),
//                   ),
//                 ),
//                 leading: Icon(FontAwesomeIcons.trash, color: drawerBarColor),
//                 title: Text('Trash'),
//               ),
//               ListTile(
//                 onTap: () => Navigator.push(
//                   context,
//                   CupertinoPageRoute(
//                     builder: (context) {
//                       return SettingsScreen(
//                         userRepository: widget.userRepository,
//                       );
//                     },
//                   ),
//                 ),
//                 leading: Icon(Icons.settings, color: drawerBarColor),
//                 title: Text('Settings'),
//               ),
//               ListTile(
//                 onTap: () => {},
//                 leading: Icon(FontAwesomeIcons.star, color: drawerBarColor),
//                 title: Text('Rate us'),
//               ),
//               ListTile(
//                 onTap: () => {
//                   print('Contact us pressed'),
//                   _launchUrl(
//                       'mailto:notado.care@gmail.com?subject=User Experience@Notado')
//                 },
//                 leading: Icon(Icons.contact_mail, color: drawerBarColor),
//                 title: Text('Contact us'),
//               ),
//               ListTile(
//                 onTap: () {
//                   BlocProvider.of<AuthenticationBloc>(context).add(
//                     LoggedOut(),
//                   );
//                   Navigator.pushReplacement(
//                     context,
//                     PageRouteBuilder(
//                       transitionDuration: Duration(milliseconds: 440),
//                       pageBuilder: (context, animation, secondaryAnimation) =>
//                           LoginScreen(userRepository: widget.userRepository),
//                       transitionsBuilder:
//                           (context, animation, secondaryAnimation, child) {
//                         var begin = Offset(0, 1);
//                         var end = Offset.zero;
//                         var curve = Curves.easeInOutQuad;
//                         var tween = Tween(begin: begin, end: end)
//                             .chain(CurveTween(curve: curve));
//                         //var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

//                         return SlideTransition(
//                             position: animation.drive(tween), child: child);
//                         //return FadeTransition(opacity: animation.drive(tween), child: child);
//                       },
//                     ),
//                   );
//                 },
//                 leading:
//                     Icon(FontAwesomeIcons.signOutAlt, color: drawerBarColor),
//                 title: Text('Logout'),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: RefreshIndicator(
//         color: Colors.black,
//         onRefresh: refreshIt,
//         child: ListView(
//           physics: BouncingScrollPhysics(),
//           children: snapshot.data.documents.map<Widget>(
//             (document) {
//               Iterable list = json.decode(document['contents']);
//               print("......................................" +
//                   list.runtimeType.toString());
//               List<Note> Cnote = list.map((i) => Note.fromMap(i)).toList();
//               print(Cnote[0].title.toString() +
//                   ".............................noteeeee\n");
//               setState(() {});
//               return Padding(
//                 padding: EdgeInsets.all(2.0),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: ListTile(
//                     isThreeLine: false,
//                     tileColor: Colors.grey[100],
//                     onTap: () {
//                       nmode = noteMode.editNote;
//                       Navigator.push(
//                         context,
//                         PageRouteBuilder(
//                           pageBuilder:
//                               (context, animation, secondaryAnimation) =>
//                                   ZefyrNote(
//                             userRepository: widget.userRepository,
//                             databaseService: DatabaseService(uid: widget.uid),
//                             contents: document['contents'],
//                             id: document['id'],
//                             title: document['title'],
//                           ),
//                           transitionsBuilder:
//                               (context, animation, secondaryAnimation, child) {
//                             var begin = Offset(0, 0);
//                             var end = Offset.zero;
//                             var curve = Curves.easeInExpo;
//                             var tween = Tween(begin: begin, end: end)
//                                 .chain(CurveTween(curve: curve));
//                             //var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

//                             return SlideTransition(
//                                 position: animation.drive(tween), child: child);
//                             //return FadeTransition(opacity: animation.drive(tween), child: child);
//                           },
//                         ),
//                       );
//                     },
//                     // onTap: () {
//                     //   nmode = noteMode.editNote;
//                     //   Navigator.push(context, MaterialPageRoute(
//                     //       builder: (BuildContext context) {
//                     //     return ZefyrNote(
//                     //       userRepository: widget.userRepository,
//                     //       databaseService: DatabaseService(uid: uid),
//                     //       contents: document['contents'],
//                     //       id: document['id'],
//                     //       title: document['title'],
//                     //     );
//                     //   }));
//                     // },
//                     title: Text(document['title']),
//                     subtitle: Text(
//                       document['date'],
//                       style: TextStyle(color: Colors.grey[600], fontSize: 10),
//                     ),
//                     onLongPress: () => {
//                       DatabaseService(uid: widget.uid)
//                           .deleteZefyrUserDataFromNotes(
//                         contents: document['contents'],
//                         title: document['title'],
//                         id: document['id'],
//                         date: document['date'],
//                       ),
//                       Toast.show('Succesfully moved to trash...', context),
//                     },
//                   ),
//                 ),
//               );
//             },
//           ).toList(),
//         ),
//       ),
//     );
//   }
// }

// PageRouteBuilder buildPageRouteBuilder(Widget screen) {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => screen,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       var begin = Offset(-1, 0);
//       var end = Offset.zero;
//       var curve = Curves.easeInOutQuad;
//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//       //var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

//       return SlideTransition(position: animation.drive(tween), child: child);
//       //return FadeTransition(opacity: animation.drive(tween), child: child);
//     },
//   );
// }

/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////

// class HomeScreen extends StatefulWidget {
//   final UserRepository userRepository;

//   const HomeScreen({Key key, @required this.userRepository}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   AnimationController viewController;
//   bool islistView = true;
//   String uid;
//   var h = 1001.0694778740428;
//   final w = 462.03206671109666;
//   double homeScreenIconSize = 20.0 / 1001.0694778740428;
//   String photoUrl;
//   String displayName = "Username";
//   String userEmail;
//   sortType sort = sortType.name;
//   int typeSort = 1;
//   bool selectAll = false;
//   setTypeSort(int val) {
//     Navigator.pop(context);
//     setState(() {
//       typeSort = val;
//     });
//   }

//   _getDisplayName() async {
//     displayName = await widget.userRepository.getDisplayName();
//   }

//   _getUserEmail() async {
//     userEmail = await widget.userRepository.getUserEmail();
//   }

//   _getPhotoUrl() async {
//     photoUrl = await widget.userRepository.getPhotoUrl();
//   }

//   _getUID() async {
//     uid = await widget.userRepository.getUID();
//   }

//   @override
//   void didUpdateWidget(HomeScreen oldWidget) {
//     super.didUpdateWidget(oldWidget);
//   }

//   bool _showNetworkError = false;
//   final _borderRadius = BorderRadius.circular(70);
//   TapGestureRecognizer _repoButton;
//   void _launchUrl(String url) async {
//     if (await canLaunch(url) && await _checkConnection()) {
//       _checkConnection();
//       launch(url);
//     } else {
//       setState(() {
//         print('netwrok error');
//         _showNetworkError = true;
//       });
//     }
//   }

//   Future<bool> _checkConnection() async {
//     if (await DataConnectionChecker().hasConnection) {
//       setState(() {
//         _showNetworkError = false;
//       });
//       return true;
//     } else {
//       setState(() {
//         print('netwrok error');
//         _showNetworkError = true;
//       });
//       return false;
//     }
//   }

//   List<Note> _notes = [];
//   final formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');

//   Future<Null> refreshIt() async {
//     await Future.delayed(Duration(seconds: 2));
//     setState(() {});
//   }

//   @override
//   void initState() {
//     // _loadNotes().then((onValue) {
//     //   setState(() {
//     //     //  _notes = onValue;
//     //   });
//     // }).catchError(print);

//     viewController =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 500));
//     super.initState();
//     // nmode = noteMode.newNote;
//   }

//   @override
//   void didChangeDependencies() {
//     _getUserEmail();
//     _getUID();
//     _getPhotoUrl();
//     _getDisplayName();
//     _getUserEmail();
//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     viewController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print('building..............');

//     List<dynamic> _deletableNotesList = [];
//     // var nomode = Provider.of<NoteModeProvider>(context);
//     // var cScreenObject = Provider.of<CurrentScreenProvider>(context);
//     // var selectListItem = Provider.of<SelectListTile>(context);
//     // var changeSelectedListItem =
//     //     Provider.of<ChangeSelectedListItemProvider>(context);
//     Widget content;
//     final height = MediaQuery.of(context).size.height;

//     return Consumer<SelectListTile>(
//       builder: (context, selectListItem, child) =>
//           Consumer<ChangeSelectedListItemProvider>(
//         builder: (context, changeSelectedListItem, child) => WillPopScope(
//           onWillPop: () async {
//             DateTime currentBackPressTime;
//             if (!selectListItem.isSelecting) {
//               DateTime now = DateTime.now();
//               if (currentBackPressTime == null ||
//                   now.difference(currentBackPressTime) > Duration(seconds: 2)) {
//                 currentBackPressTime = now;
//                 Toast.show('Press again to exit', context);
//                 return Future.value(false);
//               }
//               return Future.value(true);
//             } else {
//               Future.delayed(Duration(milliseconds: 1), () {
//                 changeSelectedListItem.clearselectedItemsList();
//                 selectListItem.isSelecting = false;
//                 return false;
//               });
//             }
//           },
//           child: Consumer<NoteModeProvider>(
//             builder: (context, nomode, child) => Scaffold(
//               drawerEnableOpenDragGesture: true,
//               key: _scaffoldKey,
//               resizeToAvoidBottomPadding: false,
//               floatingActionButton: selectListItem.isSelecting != false
//                   ? null
//                   : FloatingActionButton(
//                       onPressed: () {
//                         changeSelectedListItem.clearselectedItemsList();
//                         nomode.notesmode = noteMode.newNote;
//                         Navigator.push(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder:
//                                 (context, animation, secondaryAnimation) =>
//                                     ZefyrNote(
//                               databaseService: DatabaseService(uid: uid),
//                               userRepository: widget.userRepository,
//                             ),
//                             transitionsBuilder: (context, animation,
//                                 secondaryAnimation, child) {
//                               var begin = Offset(0.5, 0.5);
//                               var end = Offset.zero;
//                               var curve = Curves.easeInOutQuad;
//                               // var tween = Tween(begin: begin, end: end)
//                               //     .chain(CurveTween(curve: curve));

//                               var tween = Tween(begin: 0.0, end: 1.0)
//                                   .chain(CurveTween(curve: curve));
//                               // return SlideTransition(
//                               //     position: animation.drive(tween), child: child);
//                               return FadeTransition(
//                                   opacity: animation.drive(tween),
//                                   child: child);
//                             },
//                           ),
//                         );
//                       },
//                       child: Icon(Icons.add),
//                     ),
//               bottomNavigationBar: BottomAppBar(
//                 notchMargin: 8.0,
//                 shape: CircularNotchedRectangle(),
//                 child: Padding(
//                   padding: EdgeInsets.all(5.0),
//                   child: selectListItem.isSelecting != false
//                       ? Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             IconButton(
//                               tooltip: 'Delete selected note',
//                               icon: Icon(
//                                 Icons.delete_outline,
//                                 color: Colors.teal,
//                               ),
//                               onPressed: () {
//                                 print(_deletableNotesList.length.toString() +
//                                     ".........deletablelist length");
//                               },
//                             ),
//                             IconButton(
//                               tooltip: 'Pin',
//                               icon: Icon(
//                                 Icons.pin_drop_outlined,
//                                 color: Colors.teal,
//                               ),
//                               onPressed: () {},
//                             ),
//                             IconButton(
//                               tooltip: 'Make available offline',
//                               icon: Icon(
//                                 Icons.cloud_download_outlined,
//                                 color: Colors.teal,
//                               ),
//                               onPressed: () {},
//                             ),
//                           ],
//                         )
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   height: 45,
//                                   child: IconButton(
//                                     tooltip: 'Change view',
//                                     icon: AnimatedIcon(
//                                       icon: AnimatedIcons.list_view,
//                                       progress: viewController,
//                                       size: homeScreenIconSize * height,
//                                     ),
//                                     onPressed: () {
//                                       islistView
//                                           ? viewController.forward()
//                                           : viewController.reverse();
//                                       islistView = !islistView;
//                                       if (!islistView)
//                                         _scaffoldKey.currentState.showSnackBar(
//                                             SnackBar(
//                                                 content: Text(
//                                                     'The app is currently in development mode, please wait while we cook the recipe for this.')));
//                                     },
//                                   ),
//                                 ),
//                                 Container(
//                                   height: 45,
//                                   child: IconButton(
//                                     tooltip: 'Handwritten notes',
//                                     icon: Icon(Icons.brush),
//                                     onPressed: () {
//                                       Navigator.push(context, MaterialPageRoute(
//                                           builder: (BuildContext context) {
//                                         return DrawScreen(
//                                             userRepository:
//                                                 widget.userRepository);
//                                       }));
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               height: 45,
//                               padding: EdgeInsets.all(7),
//                               child: DropdownButton<String>(
//                                 // dropdownColor: Colors.white,
//                                 underline: SizedBox(),

//                                 icon: Icon(
//                                   Icons.more_vert,
//                                   //  color: Colors.black,
//                                 ),
//                                 iconSize: homeScreenIconSize * height,
//                                 elevation: 0,
//                                 // style: TextStyle(color: Colors.green),
//                                 onChanged: (String newValue) {
//                                   _scaffoldKey.currentState
//                                       .hideCurrentSnackBar();

//                                   if (newValue == 'Sort by') {
//                                     return showDialog(
//                                       context: context,
//                                       child: AlertDialog(
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(10.0),
//                                         ),
//                                         content: SingleChildScrollView(
//                                           child: ListBody(
//                                             children: [
//                                               RadioListTile(
//                                                 value: 1,
//                                                 groupValue: typeSort,
//                                                 onChanged: (value) => {
//                                                   setTypeSort(value),
//                                                 },
//                                                 activeColor: Colors.lightGreen,
//                                                 title: Text('Name '),
//                                               ),
//                                               RadioListTile(
//                                                 value: 2,
//                                                 groupValue: typeSort,
//                                                 onChanged: (value) => {
//                                                   setTypeSort(value),
//                                                 },
//                                                 activeColor: Colors.lightGreen,
//                                                 title: Text('Date created'),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         actions: [
//                                           FlatButton(
//                                             onPressed: () {
//                                               Navigator.pop(context);
//                                               // _scaffoldKey.currentState
//                                               //   ..hideCurrentSnackBar();
//                                             },
//                                             child: Text('Cancel'),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 items: <String>[
//                                   'Select Notes',
//                                   'Sort by'
//                                 ].map<DropdownMenuItem<String>>((String value) {
//                                   return DropdownMenuItem<String>(
//                                     value: value,
//                                     child: Text(value),
//                                     onTap: null,
//                                   );
//                                 }).toList(),
//                               ),
//                             ),
//                           ],
//                         ),
//                 ),
//               ),
//               appBar: AppBar(
//                 iconTheme: IconThemeData(color: Colors.black),
//                 backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                 //  title: Text('My Notes', style: TextStyle(color: Colors.black)),
//                 elevation: 0,
//                 leading: selectListItem.isSelecting == false
//                     ? null
//                     : IconButton(
//                         icon: Icon(Icons.arrow_back),
//                         onPressed: () {
//                           changeSelectedListItem.clearselectedItemsList();
//                           selectListItem.isSelecting = false;
//                         },
//                       ),
//                 actions: selectListItem.isSelecting == false
//                     ? [
//                         Consumer<CurrentScreenProvider>(
//                           builder: (context, cScreenObject, child) => Padding(
//                             padding: EdgeInsets.all(4.0),
//                             child: IconButton(
//                               tooltip: 'Search',
//                               icon: Icon(Icons.search),
//                               onPressed: () {
//                                 cScreenObject.whichScreen =
//                                     currentScreen.search;

//                                 Navigator.push(
//                                   context,
//                                   CupertinoPageRoute(
//                                     builder: (context) {
//                                       return SearchScreen(
//                                         userRepository: widget.userRepository,
//                                         uid: uid,
//                                       );
//                                     },
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(4.0),
//                           child: GestureDetector(
//                             child: photoUrl == null
//                                 ? CircleAvatar(backgroundColor: Colors.green)
//                                 : ClipRRect(
//                                     borderRadius: BorderRadius.circular(30),
//                                     child: Hero(
//                                       tag: 'profilepic',
//                                       child: Image(
//                                         image: NetworkImage(
//                                           photoUrl,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                             onTap: () {
//                               return showDialog(
//                                 context: context,
//                                 child: AlertDialog(
//                                   content: ClipRRect(
//                                     borderRadius: BorderRadius.circular(10),
//                                     child: ListTile(
//                                       contentPadding: EdgeInsets.all(0),
//                                       leading: Hero(
//                                         tag: 'profilepic',
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(30),
//                                           child: Image(
//                                             image: NetworkImage(
//                                               photoUrl,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       title: Text(
//                                         displayName,
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 15,
//                                         ),
//                                       ),
//                                       subtitle: Text(
//                                         userEmail,
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 11,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ]
//                     : [
//                         IconButton(
//                           icon: Icon(Icons.share_outlined),
//                           onPressed: () {},
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.select_all_outlined),
//                           onPressed: () {
//                             setState(() {
//                               selectAll = !selectAll;
//                             });
//                           },
//                         ),
//                       ],
//               ),
//               drawer: selectListItem.isSelecting == true
//                   ? null
//                   : Consumer<CurrentScreenProvider>(
//                       builder: (context, cScreenObject, child) => Drawer(
//                         elevation: 0.0,
//                         child: Container(
//                           height: MediaQuery.of(context).size.height,
//                           color: Colors.white,
//                           child: ListView(
//                             children: [
//                               SizedBox(height: 30),
//                               Card(
//                                 elevation: 0.0,
//                                 child: Container(
//                                   height: 100,
//                                   child: Center(
//                                     child: Text(
//                                       'Notado',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w300,
//                                         fontSize: 50,
//                                         letterSpacing: 2,
//                                         color: drawerBarColor,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 30),
//                               ListTile(
//                                 onTap: () => {
//                                   Navigator.pop(context),
//                                   if (cScreenObject.whichScreen ==
//                                       currentScreen.home)
//                                     _scaffoldKey.currentState.showSnackBar(
//                                       SnackBar(
//                                         content: Text(
//                                             'You are already on the Home Screen'),
//                                       ),
//                                     ),
//                                 },
//                                 // leading:
//                                 //     Icon(Icons.note, color: drawerBarColor),
//                                 leading: SvgPicture.asset(
//                                   'assets/study.svg',
//                                   matchTextDirection: true,
//                                   alignment: Alignment.centerLeft,
//                                 ),
//                                 title: Text('My Notes'),
//                               ),
//                               ListTile(
//                                 onTap: () {
//                                   Navigator.pop(context);
//                                   _scaffoldKey.currentState.showSnackBar(SnackBar(
//                                       content: Text(
//                                           'This app is currently in development mode,\n please wait while we cook the recipe for you')));
//                                 },
//                                 leading: Icon(FontAwesomeIcons.bookReader,
//                                     color: drawerBarColor),
//                                 title: Text('Study notes'),
//                               ),
//                               ListTile(
//                                 onTap: () {
//                                   cScreenObject.whichScreen =
//                                       currentScreen.trash;
//                                   Navigator.push(
//                                     context,
//                                     buildPageRouteBuilder(
//                                       TrashScreen(
//                                         userRepository: widget.userRepository,
//                                         databaseService:
//                                             DatabaseService(uid: uid),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 leading: Icon(FontAwesomeIcons.trash,
//                                     color: drawerBarColor),
//                                 title: Text('Trash'),
//                               ),
//                               ListTile(
//                                 onTap: () {
//                                   cScreenObject.whichScreen =
//                                       currentScreen.settings;
//                                   Navigator.push(
//                                     context,
//                                     CupertinoPageRoute(
//                                       builder: (context) {
//                                         return SettingsScreen(
//                                           userRepository: widget.userRepository,
//                                         );
//                                       },
//                                     ),
//                                   );
//                                 },
//                                 leading:
//                                     Icon(Icons.settings, color: drawerBarColor),
//                                 title: Text('Settings'),
//                               ),
//                               ListTile(
//                                 onTap: () => {},
//                                 leading: Icon(FontAwesomeIcons.star,
//                                     color: drawerBarColor),
//                                 title: Text('Rate us'),
//                               ),
//                               ListTile(
//                                 onTap: () => {
//                                   _launchUrl(
//                                       'mailto:dotstudios.bs@gmail.com?subject=User Experience@Notado')
//                                 },
//                                 leading: Icon(Icons.contact_mail,
//                                     color: drawerBarColor),
//                                 title: Text('Contact us'),
//                               ),
//                               ListTile(
//                                 onTap: () {
//                                   BlocProvider.of<AuthenticationBloc>(context)
//                                       .add(
//                                     LoggedOut(),
//                                   );
//                                   Navigator.pushReplacement(
//                                     context,
//                                     PageRouteBuilder(
//                                       transitionDuration:
//                                           Duration(milliseconds: 440),
//                                       pageBuilder: (context, animation,
//                                               secondaryAnimation) =>
//                                           LoginScreen(
//                                               userRepository:
//                                                   widget.userRepository),
//                                       transitionsBuilder: (context, animation,
//                                           secondaryAnimation, child) {
//                                         var begin = Offset(0, 1);
//                                         var end = Offset.zero;
//                                         var curve = Curves.easeInOutQuad;
//                                         var tween = Tween(
//                                                 begin: begin, end: end)
//                                             .chain(CurveTween(curve: curve));
//                                         //var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

//                                         return SlideTransition(
//                                             position: animation.drive(tween),
//                                             child: child);
//                                         //return FadeTransition(opacity: animation.drive(tween), child: child);
//                                       },
//                                     ),
//                                   );
//                                 },
//                                 leading: Icon(FontAwesomeIcons.signOutAlt,
//                                     color: drawerBarColor),
//                                 title: Text('Logout'),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//               body: RefreshIndicator(
//                 color: Colors.black,
//                 onRefresh: refreshIt,
//                 child: StreamBuilder(
//                   stream: typeSort == 1
//                       ? DatabaseService(uid: uid)
//                           .notesZefyrFromNotesOrderByTitle
//                       : DatabaseService(uid: uid)
//                           .notesZefyrFromNotesOrderByDate,
//                   builder: (BuildContext context, AsyncSnapshot snapshot) {
//                     if (snapshot.hasError)
//                       return Center(child: Text('ERROR'));
//                     else if (snapshot.connectionState ==
//                         ConnectionState.waiting)
//                       return Center(
//                         child: CircularProgressIndicator(
//                           backgroundColor: Colors.blue,
//                         ),
//                       );
//                     else if (!snapshot.hasData) {
//                       return Center(
//                           child: Text('You haven\'t added any notes yet'));
//                     }
//                     print(snapshot.connectionState.toString() +
//                         "connecttionstate....");
//                     return ListView(
//                       physics: BouncingScrollPhysics(),
//                       children: snapshot.data.documents.map<Widget>(
//                         (document) {
//                           Iterable list = json.decode(document['contents']);
//                           List<Note> Cnote =
//                               list.map((i) => Note.fromMap(i)).toList();
//                           return Padding(
//                             padding: EdgeInsets.symmetric(vertical: 1),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(0),
//                               child: ListTile(
//                                 isThreeLine: true,
//                                 tileColor: Colors.grey[100],
//                                 selectedTileColor: Colors.green[500],
//                                 title: Text(
//                                   document['title'],
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 subtitle: Text(
//                                   document['date'],
//                                   style: TextStyle(
//                                       color: Colors.grey[600], fontSize: 10),
//                                 ),
//                                 selected: changeSelectedListItem
//                                     .selectedItemsIDList
//                                     .contains(document['id']),
//                                 // trailing: selectListItem.isSelecting == true
//                                 //     ? Checkbox(
//                                 //         value: false,
//                                 //         onChanged: (val) {},
//                                 //       )
//                                 //     : null,
//                                 onTap: selectListItem.isSelecting == false
//                                     ? () {
//                                         nomode.notesmode = noteMode.editNote;
//                                         changeSelectedListItem
//                                             .clearselectedItemsList();
//                                         print(changeSelectedListItem
//                                                 .selectedItemsIDList
//                                                 .contains(document['id'])
//                                                 .toString() +
//                                             "...........selectedORnot");
//                                         Navigator.push(context,
//                                             MaterialPageRoute(builder:
//                                                 (BuildContext context) {
//                                           return ZefyrNote(
//                                             userRepository:
//                                                 widget.userRepository,
//                                             databaseService:
//                                                 DatabaseService(uid: uid),
//                                             contents: document['contents'],
//                                             id: document['id'],
//                                             title: document['title'],
//                                           );
//                                         }));
//                                       }
//                                     : () {
//                                         changeSelectedListItem.listItemPressed(
//                                             id: document['id']);
//                                         if (changeSelectedListItem
//                                             .selectedItemsIDList
//                                             .contains(document['id']))
//                                           _deletableNotesList.add(document);
//                                       },
//                                 onLongPress: () => {
//                                   if (!selectListItem.isSelecting)
//                                     {
//                                       changeSelectedListItem.listItemPressed(
//                                           id: document['id']),
//                                       selectListItem.isSelecting = true,
//                                     }
//                                   else
//                                     {
//                                       // DatabaseService(uid: uid)
//                                       //     .deleteZefyrUserDataFromNotes(
//                                       //   contents: document['contents'],
//                                       //   title: document['title'],
//                                       //   id: document['id'],
//                                       //   date: document['date'],
//                                       // ),
//                                       // Toast.show(
//                                       //     'Succesfully moved to trash', context),
//                                     },
//                                 },
//                               ),
//                             ),
//                           );
//                         },
//                       ).toList(),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// PageRouteBuilder buildPageRouteBuilder(Widget screen) {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => screen,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       var begin = Offset(-1, 0);
//       var end = Offset.zero;
//       var curve = Curves.easeInOutQuad;
//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//       //var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

//       return SlideTransition(position: animation.drive(tween), child: child);
//       //return FadeTransition(opacity: animation.drive(tween), child: child);
//     },
//   );
// }

// var stag = StaggeredGridView.count(
//   crossAxisCount: 2,
// );
// /*
// StaggeredGridView.countBuilder(
//   crossAxisCount: 2,
//   itemCount: _,
//   itemBuilder: (BuildContext context, int index) => new Container(
//       color: Colors.green,
//       child: new Center(
//         child: new CircleAvatar(
//           backgroundColor: Colors.white,
//           child: new Text('$index'),
//         ),
//       )),
//   staggeredTileBuilder: (int index) =>
//       new StaggeredTile.count(2, index.isEven ? 2 : 1),
//   mainAxisSpacing: 4.0,
//   crossAxisSpacing: 4.0,
// )
// */

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

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
  var h = 1001.0694778740428;
  final w = 462.03206671109666;
  double homeScreenIconSize = 20.0 / 1001.0694778740428;
  String photoUrl;
  String displayName = "Username";
  String userEmail;
  sortType sort = sortType.name;
  int typeSort = 1;
  bool selectAll = false;
  setTypeSort(int val) {
    Navigator.pop(context);
    setState(() {
      typeSort = val;
    });
  }

  _getDisplayName() async {
    displayName = await widget.userRepository.getDisplayName();
  }

  _getUserEmail() async {
    userEmail = await widget.userRepository.getUserEmail();
  }

  _getPhotoUrl() async {
    photoUrl = await widget.userRepository.getPhotoUrl();
  }

  _getUID() async {
    uid = await widget.userRepository.getUID();
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
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

  // List<Note> _notes = [];
  final formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');

  Future<Null> refreshIt() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }

  List<Note> _notesList = [];
  _getNotesFromNotesFirebaseOrderByName() async {
    final _queryList = await Firestore.instance
        .collection('notes')
        .document(uid)
        .collection('userNotes')
        .orderBy('title')
        .getDocuments();
    var doc = _queryList.documents;
    doc.forEach((element) {
      var data = element.data;
      _notesList.add(Note(
        title: data['title'],
        date: data['date'],
        contents: data['contents'],
        id: data['id'],
        searchKey: data['searchKey'],
      ));
    });

    setState(() {});
  }

  _getNotesFromNotesFirebaseOrderByDate() async {
    final _queryList = await Firestore.instance
        .collection('notes')
        .document(uid)
        .collection('userNotes')
        .orderBy('date')
        .getDocuments();
    var doc = _queryList.documents;
    doc.forEach((element) {
      var data = element.data;
      _notesList.add(Note(
        title: data['title'],
        date: data['date'],
        contents: data['contents'],
        id: data['id'],
        searchKey: data['searchKey'],
      ));
    });

    setState(() {});
  }

  @override
  void initState() {
    viewController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _getUserEmail();
    _getUID();
    _getPhotoUrl();
    _getDisplayName();
    _getUserEmail();
    _getNotesFromNotesFirebaseOrderByName();
    _getNotesFromNotesFirebaseOrderByDate();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    viewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('building..............');

    List<dynamic> _deletableNotesList = [];
    Widget content;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: _notesList.length == 0
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  for (var i = 0; i < _notesList.length; i++)
                    ListTile(
                      title: Text(_notesList[i].title),
                    ),
                ],
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

var stag = StaggeredGridView.count(
  crossAxisCount: 2,
);
/*
StaggeredGridView.countBuilder(
  crossAxisCount: 2,
  itemCount: _,
  itemBuilder: (BuildContext context, int index) => new Container(
      color: Colors.green,
      child: new Center(
        child: new CircleAvatar(
          backgroundColor: Colors.white,
          child: new Text('$index'),
        ),
      )),
  staggeredTileBuilder: (int index) =>
      new StaggeredTile.count(2, index.isEven ? 2 : 1),
  mainAxisSpacing: 4.0,
  crossAxisSpacing: 4.0,
)
*/
