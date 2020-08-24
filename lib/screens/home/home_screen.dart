import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notado/models/note_model.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/authentication/authenticationBloc/authentication_bloc.dart';
import 'package:notado/authentication/authenticationBloc/authentication_event.dart';
import 'package:notado/constants/constants.dart';
import 'package:notado/screens/addnote/addnote_screen.dart';
import 'package:notado/screens/home/note_list.dart';
import 'package:notado/screens/login/login_screen.dart';
import 'package:notado/screens/profile/profile_screen.dart';
import 'package:notado/screens/settings/settings_screen.dart';
import 'package:notado/services/database.dart';
import 'package:notado/user_repository/user_Repository.dart';

class HomeScreen extends StatefulWidget {
  final UserRepository userRepository;

  const HomeScreen({Key key, @required this.userRepository}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String userCard;
  String uid;
  getUserEmail() async {
    userCard = await widget.userRepository.getUser();
  }

  getUserUID() async {
    uid = await widget.userRepository.getUID();
  }

  @override
  void initState() {
    getUserEmail();
    getUserUID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Note>>.value(
      value: DatabaseService(uid: uid).notes,
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
        key: _scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        resizeToAvoidBottomPadding: false,
        floatingActionButton: FAB(widget: widget),
        appBar: appbar(context),
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
                  onTap: () => {},
                  leading: Icon(FontAwesomeIcons.trash, color: drawerBarColor),
                  title: Text('Trash'),
                ),
                ListTile(
                  onTap: () => {},
                  leading: Icon(FontAwesomeIcons.star, color: drawerBarColor),
                  title: Text('Rate us'),
                ),
                ListTile(
                  onTap: () => {},
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
        body: NotesList(),

        //  Builder(
        //   //TODO: Check whether this is correct or not i.e, two Scaffolds
        //   builder: (BuildContext context) => SingleChildScrollView(
        //     physics: BouncingScrollPhysics(),
        //     child: Padding(
        //       padding: EdgeInsets.all(14.0),
        //       child: Column(
        //         children: [
        //           Card(
        //             color: Colors.green[300],
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(10),
        //             ),
        //             child: Container(
        //               height: 150,
        //               width: MediaQuery.of(context).size.width,
        //               child: Padding(
        //                 padding: EdgeInsets.all(18.0),
        //                 child: Text('$userCard',
        //                     style: TextStyle(
        //                         fontSize: 30, fontWeight: FontWeight.w400)),
        //               ),
        //             ),
        //           ),
        //           GridView.count(
        //             crossAxisCount: 2,
        //             shrinkWrap: true,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }

//AppBar for HomeScreen
  AppBar appbar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text('My Notes', style: TextStyle(color: Colors.black)),
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
    );
  }
}

class FAB extends StatelessWidget {
  const FAB({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final HomeScreen widget;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      onPressed: () => Navigator.push(
        context,
        // Pageroutebuilder for implementing different a transition between screens
        PageRouteBuilder(
          //Navigating to the addnte screen when FAB is pressed
          pageBuilder: (context, animation, secondaryAnimation) =>
              AddNote(userRepository: widget.userRepository),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0, 1);
            var end = Offset.zero;
            var curve = Curves.easeInOutQuad;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            //var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
            return SlideTransition(
                position: animation.drive(tween), child: child);
            //return FadeTransition(opacity: animation.drive(tween), child: child);
          },
        ),
      ),
      child: Icon(Icons.add),
    );
  }
}

// Floating Action button for Home Screen

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

// class HomeScreen extends StatefulWidget {
//   final UserRepository userRepository;

//   const HomeScreen({Key key, @required this.userRepository}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();

//   String userCard;
//   getUserEmail() async {
//     userCard = await widget.userRepository.getUser();
//   }

//   @override
//   void initState() {
//     getUserEmail();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawerEnableOpenDragGesture: true,
//       key: _scaffoldKey,
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       resizeToAvoidBottomPadding: false,
//       floatingActionButton: FAB(widget: widget),
//       appBar: appbar(context),
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
//                 // onTap: () => Navigator.push(
//                 //   context,
//                 //   buildPageRouteBuilder(HomeScreen(user: null)),
//                 // ),
//                 onTap: () => {
//                   Navigator.pop(context),
//                   _scaffoldKey.currentState.showSnackBar(
//                     SnackBar(
//                       content: Text('You are already on the Home Screen'),
//                     ),
//                   ),
//                 },
//                 leading: Icon(Icons.home, color: drawerBarColor),
//                 title: Text('Home'),
//               ),
//               ListTile(
//                 onTap: () => Navigator.push(
//                   context,
//                   buildPageRouteBuilder(ProfileScreen()),
//                 ),
//                 leading: Icon(Icons.person, color: drawerBarColor),
//                 title: Text('Profile'),
//               ),
//               ListTile(
//                 onTap: () => {},
//                 leading: Icon(FontAwesomeIcons.trash, color: drawerBarColor),
//                 title: Text('Trash'),
//               ),
//               ListTile(
//                 onTap: () => {},
//                 leading: Icon(FontAwesomeIcons.star, color: drawerBarColor),
//                 title: Text('Rate us'),
//               ),
//               ListTile(
//                 onTap: () => {},
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
//       body: Builder(
//         //TODO: Check whether this is correct or not i.e, two Scaffolds
//         builder: (BuildContext context) => SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Padding(
//             padding: EdgeInsets.all(14.0),
//             child: Column(
//               children: [
//                 Card(
//                   color: Colors.green[300],
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Container(
//                     height: 150,
//                     width: MediaQuery.of(context).size.width,
//                     child: Padding(
//                       padding: EdgeInsets.all(18.0),
//                       child: Text('$userCard',
//                           style: TextStyle(
//                               fontSize: 30, fontWeight: FontWeight.w400)),
//                     ),
//                   ),
//                 ),
//                 GridView.count(
//                   crossAxisCount: 2,
//                   shrinkWrap: true,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

// //AppBar for HomeScreen
//   AppBar appbar(BuildContext context) {
//     return AppBar(
//       iconTheme: IconThemeData(color: Colors.black),
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       title: Text('My Notes', style: TextStyle(color: Colors.black)),
//       elevation: 0,
//       actions: [
//         Padding(
//           padding: EdgeInsets.all(10.0),
//           child: GestureDetector(
//             // Navigating to the settings screen when settings Icon is pressed
//             onTap: () => Navigator.push(
//               context,
//               CupertinoPageRoute(
//                 builder: (context) {
//                   return SettingsScreen(
//                     userRepository: widget.userRepository,
//                   );
//                 },
//               ),
//             ),
//             child: Icon(Icons.settings),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class FAB extends StatelessWidget {
//   const FAB({
//     Key key,
//     @required this.widget,
//   }) : super(key: key);

//   final HomeScreen widget;

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       backgroundColor: Colors.green,
//       onPressed: () => Navigator.push(
//         context,
//         // Pageroutebuilder for implementing different a transition between screens
//         PageRouteBuilder(
//           //Navigating to the addnte screen when FAB is pressed
//           pageBuilder: (context, animation, secondaryAnimation) =>
//               AddNote(userRepository: widget.userRepository),
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             var begin = Offset(0, 1);
//             var end = Offset.zero;
//             var curve = Curves.easeInOutQuad;
//             var tween =
//                 Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//             //var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
//             return SlideTransition(
//                 position: animation.drive(tween), child: child);
//             //return FadeTransition(opacity: animation.drive(tween), child: child);
//           },
//         ),
//       ),
//       child: Icon(Icons.add),
//     );
//   }
// }

// // Floating Action button for Home Screen

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
