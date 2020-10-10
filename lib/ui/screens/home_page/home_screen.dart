import 'dart:convert';
import 'dart:ui';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:notado/auth/auth_bloc.dart';
import 'package:notado/global/constants.dart';
import 'package:notado/global/enums/enums.dart';
import 'package:notado/global/helper/global_helper.dart';
import 'package:notado/global/providers/zefyr_providers.dart';
import 'package:notado/models/note_model/note_model.dart';
import 'package:notado/ui/components/CircularProgress.dart';
import 'package:notado/ui/screens/add_zefyr_note/add_zefyr_note.dart';
import 'package:notado/ui/screens/handwritten_note_screen/handwritten_note.dart';
import 'package:notado/ui/screens/home_page/bloc/home_bloc.dart';
import 'package:notado/ui/components/snackbar.dart';
import 'package:notado/ui/screens/login_page/login_screen.dart';
import 'package:notado/ui/screens/settings_page/settings_screen.dart';
import 'package:notado/ui/themes/theme.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zefyr/zefyr.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomepageBloc()..add(NotesRequested()),
      child: HomeScreenNoteList(),
    );
  }
}

class HomeScreenNoteList extends StatefulWidget {
  @override
  _HomeScreenNoteListState createState() => _HomeScreenNoteListState();
}

class _HomeScreenNoteListState extends State<HomeScreenNoteList>
    with SingleTickerProviderStateMixin {
  // List<String> _selectedTiles = [];
  bool _showNetworkError = false;
  var h = 1001.0694778740428;
  final w = 462.03206671109666;
  final padV60 = 60 / 1001.0694778740428;
  final padH10 = 10 / 462.03206671109666;
  AnimationController viewController;

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

  Future<bool> _onBackPressed() async {
    DateTime currentBackPressTime;
    var deTl = Provider.of<SelectedTileProvider>(context);
    if (deTl.selectedOnes.length == 0) {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Toast.show('Press again to exit', context);
        return Future.value(false);
      }
      return Future.value(true);
    } else {
      Future.delayed(Duration(milliseconds: 1), () {
        deTl.clearSelectedOnes();
        return false;
      });
    }
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    // if (!selectListItem.isSelecting) {
    //   DateTime now = DateTime.now();
    //   if (currentBackPressTime == null ||
    //       now.difference(currentBackPressTime) > Duration(seconds: 2)) {
    //     currentBackPressTime = now;
    //     Toast.show('Press again to exit', context);
    //     return Future.value(false);
    //   }
    //   return Future.value(true);
    // } else {
    //   Future.delayed(Duration(milliseconds: 1), () {
    //     changeSelectedListItem.clearselectedItemsList();
    //     selectListItem.isSelecting = false;
    //     return false;
    //   });
    // }
  }

  @override
  void initState() {
    viewController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool status = Theme.of(context).brightness == Brightness.dark;
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    final size = MediaQuery.of(context).size;
    var notemodeC = Provider.of<NoteModeProvider>(context);
    return BlocConsumer<HomepageBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeInitial) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png'),
                CircularProgressIndicator(),
              ],
            ),
          );
        }
        // if (state is HomepageLoaded) {}
        if (state is HomepageError) {
          context.showSnackBar(state.message);
        }
        if (state is HomepageLoading) {
          showProgress(context);
        }
        if (state is HomepageSuccess) {
          Navigator.of(context).pop();
          BlocProvider.of<HomepageBloc>(context).add(NotesRequested());
        }
        if (state is NewZefyrPageLoaded) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return ZefyrNote();
            }),
          );
        }
        if (state is EditZefyrpageLoaded) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return ZefyrNote(
                contents: state.contents,
                title: state.title,
                id: state.id,
                date: state.date,
                searchKey: state.searchKey,
              );
            }),
          );
        }
        if (state is CreateLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is UpdateLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is DeletingNotes) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is Cancelled) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return HomeScreen();
              },
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is HomepageLoaded) {
          return WillPopScope(
            onWillPop: _onBackPressed,
            child: Consumer<SelectedTileProvider>(
              builder: (context, sTileP, child) {
                logger.v('Rebuilding');
                return Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  appBar: sTileP.selectedOnes.length != 0
                      ? AppBar(
                          toolbarHeight: 80.0,
                          automaticallyImplyLeading: false,
                          title: Text(
                            'Select Notes',
                            style: TextStyle(
                              fontSize: 25,
                              letterSpacing: 1.0,
                              color:
                                  Theme.of(context).textTheme.headline5.color,
                            ),
                          ),
                          iconTheme: Theme.of(context).iconTheme.copyWith(
                                color: Theme.of(context).iconTheme.color,
                              ),
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back_outlined),
                            onPressed: () {
                              logger.v('Back Button Pressed');
                              sTileP.clearSelectedOnes();
                            },
                          ),
                          actions: [
                            IconButton(
                              icon: Icon(Icons.delete_outline),
                              onPressed: () {
                                //TODO: this below code dosen't work
                                //TODO: this below code dosen't work
                                //TODO: this below code dosen't work
                                List<Note> dNotesList = sTileP.selectedOnes;
                                BlocProvider.of<HomepageBloc>(context).add(
                                  DeleteNotesRequest(dNotesList),
                                );
                                sTileP.clearSelectedOnes();
                              },
                            ),
                            IconButton(
                              // icon: Icon(Icons.select_all_outlined),
                              icon: Icon(Icons.select_all_outlined),
                              onPressed: () {
                                if (sTileP.selectedOnes.length ==
                                    state.notelist.length) {
                                  sTileP.clearSelectedOnes();
                                } else {
                                  sTileP.clearSelectedOnes();

                                  for (var i = 0;
                                      i < state.notelist.length;
                                      i++) {
                                    sTileP.tilePressed(note: state.notelist[i]);
                                  }
                                }
                              },
                            ),
                          ],
                        )
                      : AppBar(
                          // flexibleSpace: Container(
                          //   decoration: BoxDecoration(
                          //     gradient: FlutterGradients.aquaGuidance(
                          //       center: Alignment.bottomLeft,
                          //       type: GradientType.linear,
                          //     ),
                          //   ),
                          // ),
                          toolbarHeight: 80.0,
                          automaticallyImplyLeading: false,

                          title: Text(
                            'HOME',
                            style: TextStyle(
                              fontSize: 25,
                              letterSpacing: 1.0,
                              color:
                                  Theme.of(context).textTheme.headline5.color,
                            ),
                          ),
                          iconTheme: Theme.of(context).iconTheme.copyWith(
                                color: Theme.of(context).iconTheme.color,
                              ),
                          // backgroundColor: Colors.blueGrey[100],
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          elevation: 0.0,
                          actions: <Widget>[
                            IconButton(
                              icon: Icon(Icons.search_outlined),
                              onPressed: () {
                                showSearch(
                                  context: context,
                                  delegate:
                                      DataSearch(allNotes: state.notelist),
                                );
                              },
                            ),
                            // PopupMenuButton(
                            //   itemBuilder: (BuildContext context) {
                            //     return <PopupMenuItem>[
                            //       PopupMenuItem<String>(
                            //         child: GestureDetector(
                            //           onTap: () {
                            //             logger.v('Sort By');
                            //             return showDialog(
                            //               context: context,
                            //               child: AlertDialog(
                            //                 title: Text(
                            //                   'Sort by',
                            //                   style: TextStyle(
                            //                     color: Theme.of(context)
                            //                         .textTheme
                            //                         .headline5
                            //                         .color,
                            //                   ),
                            //                 ),
                            //                 content: ListView(
                            //                   shrinkWrap: true,
                            //                   children: <Widget>[
                            //                     ListTile(
                            //                       leading: Radio(
                            //                         value: null,
                            //                         groupValue: null,
                            //                         onChanged: null,
                            //                       ),
                            //                       title: Text(
                            //                         'Name',
                            //                         style: TextStyle(
                            //                           color: Theme.of(context)
                            //                               .textTheme
                            //                               .headline5
                            //                               .color,
                            //                         ),
                            //                       ),
                            //                     ),
                            //                     ListTile(
                            //                       leading: Radio(
                            //                         value: null,
                            //                         groupValue: null,
                            //                         onChanged: null,
                            //                       ),
                            //                       title: Text(
                            //                         'Date Modified',
                            //                         style: TextStyle(
                            //                           color: Theme.of(context)
                            //                               .textTheme
                            //                               .headline5
                            //                               .color,
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             );
                            //           },
                            //           child: Container(
                            //             child: Text(
                            //               'Sort by',
                            //               style: TextStyle(
                            //                 color: Theme.of(context)
                            //                     .textTheme
                            //                     .headline5
                            //                     .color,
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       PopupMenuItem<String>(
                            //         child: GestureDetector(
                            //           onTap: () {
                            //             logger.v('view');
                            //             if (Provider.of<NotesViewProvider>(
                            //                         context,
                            //                         listen: false)
                            //                     .view ==
                            //                 notesView.list) {
                            //               Provider.of<NotesViewProvider>(
                            //                       context,
                            //                       listen: false)
                            //                   .view = notesView.grid;
                            //               Navigator.of(context).pop();
                            //             } else {
                            //               Provider.of<NotesViewProvider>(
                            //                       context,
                            //                       listen: false)
                            //                   .view = notesView.list;
                            //               Navigator.of(context).pop();
                            //             }
                            //           },
                            //           child: Container(
                            //             child: Provider.of<NotesViewProvider>(
                            //                             context,
                            //                             listen: false)
                            //                         .view ==
                            //                     notesView.list
                            //                 ? Text(
                            //                     'Grid View',
                            //                     style: TextStyle(
                            //                       color: Theme.of(context)
                            //                           .textTheme
                            //                           .headline5
                            //                           .color,
                            //                     ),
                            //                   )
                            //                 : Text(
                            //                     'List View',
                            //                     style: TextStyle(
                            //                       color: Theme.of(context)
                            //                           .textTheme
                            //                           .headline5
                            //                           .color,
                            //                     ),
                            //                   ),
                            //           ),
                            //         ),
                            //       ),
                            //       PopupMenuItem<String>(
                            //         child: GestureDetector(
                            //           onTap: () {
                            //             Navigator.of(context).push(
                            //               CupertinoPageRoute(
                            //                   builder: (BuildContext context) {
                            //                 return SettingsScreen();
                            //               }),
                            //             );
                            //           },
                            //           child: Container(
                            //             child: Text(
                            //               'Settings',
                            //               style: TextStyle(
                            //                 color: Theme.of(context)
                            //                     .textTheme
                            //                     .headline5
                            //                     .color,
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ];
                            //   },
                            // ),

                            IconButton(
                              icon: Icon(
                                Icons.settings_outlined,
                              ),
                              onPressed: () => Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (BuildContext context) {
                                    return SettingsScreen();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                  // drawer: sTileP.selectedOnes.length != 0
                  //     ? null
                  //     : Drawer(
                  //         child: Container(
                  //           // color: Colors.blueGrey[900],
                  //           decoration: BoxDecoration(
                  //             gradient: LinearGradient(
                  //               begin: Alignment.topLeft,
                  //               end: Alignment.bottomRight,
                  //               // colors: [
                  //               //   Colors.blueGrey[700],
                  //               //   Colors.blueGrey[700],
                  //               //   Colors.blueGrey[800],
                  //               //   Colors.blueGrey[900],
                  //               // ],
                  //               colors: [
                  //                 Colors.green[500],
                  //                 Colors.green[500],
                  //                 Colors.green[700],
                  //                 Colors.green[800],
                  //               ],
                  //               // colors: [
                  //               //   Colors.deepPurple[500],
                  //               //   Colors.deepPurple[500],
                  //               //   Colors.deepPurple[700],
                  //               //   Colors.purple[900],
                  //               // ],
                  //             ),
                  //           ),
                  //           // color: Colors.deepPurple,
                  //           child: Padding(
                  //             padding: EdgeInsets.symmetric(
                  //               vertical: padV60 * size.height,
                  //               horizontal: padH10 * size.width,
                  //             ),
                  //             child: ListView(
                  //               shrinkWrap: true,
                  //               children: <Widget>[
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(
                  //                     vertical: (padV60 / 6) * size.height,
                  //                   ),
                  //                   child: Container(
                  //                     child: ListTile(
                  //                       leading: CircleAvatar(
                  //                         child: Image.network(
                  //                             globalUser.photoUrl),
                  //                       ),
                  //                       title: Text(
                  //                         globalUser.displayName,
                  //                         style: TextStyle(
                  //                           color: Colors.white,
                  //                         ),
                  //                       ),
                  //                       subtitle: Text(
                  //                         globalUser.email,
                  //                         style: TextStyle(
                  //                           color: Colors.white,
                  //                           fontSize: 12,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(
                  //                     vertical: (padV60 / 6) * size.height,
                  //                   ),
                  //                   child: Divider(
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(
                  //                     vertical: (padV60 / 6) * size.height,
                  //                   ),
                  //                   child: Container(
                  //                     child: ListTile(
                  //                       leading: Icon(
                  //                         Icons.home_outlined,
                  //                         color: Colors.white,
                  //                       ),
                  //                       title: Text(
                  //                         'My Notes',
                  //                         style: TextStyle(
                  //                           color: Colors.white,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(
                  //                     vertical: (padV60 / 6) * size.height,
                  //                   ),
                  //                   child: Container(
                  //                     child: ListTile(
                  //                       onTap: () {},
                  //                       leading: Icon(
                  //                         FontAwesomeIcons.trash,
                  //                         color: Colors.white,
                  //                       ),
                  //                       title: Text(
                  //                         'Trash',
                  //                         style: TextStyle(
                  //                           color: Colors.white,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(
                  //                     vertical: (padV60 / 6) * size.height,
                  //                   ),
                  //                   child: Container(
                  //                     child: ListTile(
                  //                       leading: Icon(
                  //                         FontAwesomeIcons.themeisle,
                  //                         color: Colors.white,
                  //                       ),
                  //                       title: Text(
                  //                         'Dark Mode',
                  //                         style: TextStyle(
                  //                           color: Colors.white,
                  //                         ),
                  //                       ),
                  //                       trailing: Switch(
                  //                         value: status,
                  //                         onChanged: (value) {
                  //                           status = value;
                  //                           status == true
                  //                               ? _themeChanger
                  //                                   .setTheme(ThemeData.dark())
                  //                               : _themeChanger.setTheme(
                  //                                   ThemeData.light());
                  //                         },
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(
                  //                     vertical: (padV60 / 6) * size.height,
                  //                   ),
                  //                   child: Container(
                  //                     child: ListTile(
                  //                       onTap: () {
                  //                         BlocProvider.of<AuthenticationBloc>(
                  //                                 context)
                  //                             .add(LoggedOut());
                  //                         //TODO: implement going to login screen here
                  //                       },
                  //                       leading: Icon(
                  //                         Icons.logout,
                  //                         //TODO: update
                  //                         color: Colors.white,
                  //                       ),
                  //                       title: Text(
                  //                         'Logout',
                  //                         style: TextStyle(
                  //                           color: Colors.white,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(
                  //                     vertical: (padV60 / 6) * size.height,
                  //                   ),
                  //                   child: Divider(
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(
                  //                     vertical: (padV60 / 6) * size.height,
                  //                   ),
                  //                   child: Container(
                  //                     child: ListTile(
                  //                       leading: Icon(
                  //                         Icons.share_outlined,
                  //                         color: Colors.white,
                  //                       ),
                  //                       title: Text(
                  //                         'Share App',
                  //                         style: TextStyle(
                  //                           color: Colors.white,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(
                  //                     vertical: (padV60 / 6) * size.height,
                  //                   ),
                  //                   child: Container(
                  //                     child: ListTile(
                  //                       leading: Icon(
                  //                         Icons.star_border_outlined,
                  //                         color: Colors.white,
                  //                       ),
                  //                       title: Text(
                  //                         'Rate Us',
                  //                         style: TextStyle(
                  //                           color: Colors.white,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(
                  //                     vertical: (padV60 / 6) * size.height,
                  //                   ),
                  //                   child: Container(
                  //                     child: ListTile(
                  //                       leading: Icon(
                  //                         Icons.support_outlined,
                  //                         color: Colors.white,
                  //                       ),
                  //                       title: Text(
                  //                         'Support Developers',
                  //                         style: TextStyle(
                  //                           color: Colors.white,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(
                  //                     vertical: (padV60 / 6) * size.height,
                  //                   ),
                  //                   child: Container(
                  //                     child: ListTile(
                  //                       onTap: () async {
                  //                         String url =
                  //                             ' mailto:notado.care@gmail.com?subject=User Experience@Notado';

                  //                         if (await canLaunch(url) &&
                  //                             await _checkConnection()) {
                  //                           _checkConnection();
                  //                           launch(url);
                  //                         } else {
                  //                           // setState(() {
                  //                           //   print('netwrok error');
                  //                           //   _showNetworkError = true;
                  //                           // });
                  //                           Toast.show(
                  //                             'Network Error',
                  //                             context,
                  //                             backgroundColor: Colors.grey[300],
                  //                             textColor: Colors.black,
                  //                           );
                  //                           Navigator.of(context).pop();
                  //                         }
                  //                       },
                  //                       leading: Icon(
                  //                         Icons.contact_mail_outlined,
                  //                         color: Colors.white,
                  //                       ),
                  //                       title: Text(
                  //                         'Contact Us',
                  //                         style: TextStyle(
                  //                           color: Colors.white,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(
                  //                     vertical: (padV60 / 6) * size.height,
                  //                   ),
                  //                   child: Divider(
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //                 Column(
                  //                   mainAxisAlignment: MainAxisAlignment.end,
                  //                   children: <Widget>[
                  //                     Text(
                  //                       'Made with ❤️ in India',
                  //                       style: TextStyle(
                  //                         fontSize: 11,
                  //                         color: Colors.white,
                  //                       ),
                  //                     ),
                  //                     Text(
                  //                       'Copyright © 2020 Dot.Studios LLC',
                  //                       style: TextStyle(
                  //                         fontSize: 11,
                  //                         color: Colors.white,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  // floatingActionButton: FloatingActionButton(
                  //   onPressed: () {
                  //     notemodeC.notemode = zefyrNoteMode.newNote;
                  //     logger.v('Current Note Mode ${notemodeC.notemode}');
                  //     // BlocProvider.of<HomepageBloc>(context)
                  //     //     .add(NewNoteRequest());
                  //     Navigator.of(context).push(
                  //       CupertinoPageRoute(
                  //         builder: (BuildContext context) {
                  //           return ZefyrNote();
                  //         },
                  //       ),
                  //     );
                  //   },
                  //   child: Icon(
                  //     Icons.add,
                  //     // color: Colors.brown,
                  //   ),
                  //   // backgroundColor: Colors.blueGrey[900],
                  //   backgroundColor: Colors.deepPurple,
                  // ),

                  floatingActionButton: SpeedDial(
                    overlayColor: Colors.black12,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.add_outlined),
                    children: [
                      SpeedDialChild(
                        backgroundColor:
                            Theme.of(context).textTheme.bodyText2.color,
                        onTap: () {
                          notemodeC.notemode = zefyrNoteMode.newNote;
                          logger.v('Current Note Mode ${notemodeC.notemode}');
                          // BlocProvider.of<HomepageBloc>(context)
                          //     .add(NewNoteRequest());
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (BuildContext context) {
                                return ZefyrNote();
                              },
                            ),
                          );
                        },
                        labelBackgroundColor: Theme.of(context).cardColor,
                        label: 'Add Note',
                        child: Icon(Icons.note_add_outlined),
                      ),
                      SpeedDialChild(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return DrawScreen();
                            }),
                          );
                        },
                        backgroundColor:
                            Theme.of(context).textTheme.bodyText2.color,
                        labelBackgroundColor: Theme.of(context).cardColor,
                        label: 'Handwritten Note',
                        child: Icon(Icons.brush_outlined),
                      ),
                      SpeedDialChild(
                        onTap: () {
                          //TODO: implement
                        },
                        labelBackgroundColor: Theme.of(context).cardColor,
                        backgroundColor:
                            Theme.of(context).textTheme.bodyText2.color,
                        label: 'Insert Image',
                        child: Icon(Icons.add_a_photo),
                      ),
                      SpeedDialChild(
                        onTap: () {
                          //TODO: implement
                        },
                        backgroundColor:
                            Theme.of(context).textTheme.bodyText2.color,
                        labelBackgroundColor: Theme.of(context).cardColor,
                        label: 'Insert Audio',
                        child: Icon(Icons.mic_outlined),
                      ),
                    ],
                  ),

                  body: Container(
                    // decoration: BoxDecoration(
                    //   gradient: LinearGradient(
                    //     colors: [
                    //       Colors.blueGrey[100],
                    //       Colors.blueGrey[100],
                    //       Colors.blueGrey[100],
                    //       Colors.blueGrey[100],
                    //     ],
                    //   ),
                    // ),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await initializeApi;
                        BlocProvider.of<HomepageBloc>(context)
                            .add(NotesRequested());
                      },
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: state.notelist.length > 0
                            ? Consumer<NotesViewProvider>(
                                builder: (context, notView, child) {
                                  if (notView.view == notesView.list)
                                    return Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: state.notelist.map(
                                          (element) {
                                            Iterable list =
                                                json.decode(element.contents);
                                            List Cnote = list
                                                .map((i) => i['insert'])
                                                .toList();
                                            List<String> mainContent =
                                                Cnote[0].toString().split('\n');
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                      // .withOpacity(1),
                                                      offset: Offset(0.0, 5.0),
                                                      blurRadius: 10,
                                                      spreadRadius: 0.1,
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: ListTile(
                                                        tileColor:
                                                            status != true
                                                                ? Colors.white
                                                                : Colors.black,
                                                        // trailing: _selectedTiles
                                                        //         .contains(element.id)
                                                        //     ? Icon(Icons.check_box)
                                                        //     : null,
                                                        // onTap: () {
                                                        //   logger.v('Note Pressed');
                                                        //   if (_selectedTiles.length != 0) {
                                                        //     if (_selectedTiles
                                                        //         .contains(element.id)) {
                                                        //       setState(() {
                                                        //         _selectedTiles
                                                        //             .remove(element.id);
                                                        //       });
                                                        //     } else {
                                                        //       setState(() {
                                                        //         _selectedTiles
                                                        //             .add(element.id);
                                                        //       });
                                                        //     }
                                                        //   }
                                                        // },
                                                        // onLongPress: () {
                                                        //   logger.v('Note Long Pressed');
                                                        //   setState(() {
                                                        //     if (!_selectedTiles
                                                        //         .contains(element.id))
                                                        //       _selectedTiles.add(element.id);
                                                        //   });
                                                        // },
                                                        //  selected: _selectedTiles
                                                        //   .contains(element.id),
                                                        onTap: () {
                                                          logger.v(
                                                              'Note Pressed');
                                                          if (sTileP
                                                                  .selectedOnes
                                                                  .length !=
                                                              0)
                                                            sTileP.tilePressed(
                                                                note: element);
                                                          else {
                                                            notemodeC.notemode =
                                                                zefyrNoteMode
                                                                    .editNote;
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              CupertinoPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return ZefyrNote(
                                                                    contents:
                                                                        NotusDocument
                                                                            .fromJson(
                                                                      jsonDecode(
                                                                          element
                                                                              .contents),
                                                                    ),
                                                                    title: element
                                                                        .title,
                                                                    id: element
                                                                        .id,
                                                                    searchKey:
                                                                        element
                                                                            .searchKey,
                                                                    date: element
                                                                        .date,
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        onLongPress: () {
                                                          logger.v(
                                                              'Note Long Pressed');
                                                          sTileP.tilePressed(
                                                              note: element);
                                                        },
                                                        trailing: sTileP
                                                                .selectedOnes
                                                                .contains(
                                                                    element)
                                                            ? Icon(
                                                                Icons
                                                                    .check_circle,
                                                                color: Colors
                                                                    .green,
                                                              )
                                                            : null,
                                                        selected: sTileP
                                                            .selectedOnes
                                                            .contains(element),
                                                        selectedTileColor:
                                                            status != true
                                                                ? Colors
                                                                    .grey[200]
                                                                : Colors
                                                                    .black54,
                                                        dense: false,
                                                        title: Text(
                                                          element.title
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color: status !=
                                                                    true
                                                                ? Colors.black
                                                                : Colors.white,
                                                          ),
                                                        ),
                                                        // subtitle: Text(element.date),
                                                        isThreeLine: true,
                                                        subtitle: Text(
                                                          mainContent[0] +
                                                              '...\n' +
                                                              element.date,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color: status !=
                                                                    true
                                                                ? Colors.black
                                                                : Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 1.0,
                                                      indent: 1.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          //  Padding(
                                          //   padding: EdgeInsets.only(bottom: 0.5),
                                          //   child: FlatButton(
                                          //     onPressed: null,
                                          //     onLongPress: () {},
                                          //     child: element,
                                          //   ),
                                          // ),
                                        ).toList(),
                                      ),
                                    );
                                  else {
                                    return GridView.count(
                                      scrollDirection: Axis.vertical,
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      crossAxisCount: 2,
                                      children: state.notelist.map((element) {
                                        Iterable list =
                                            json.decode(element.contents);
                                        List Cnote = list
                                            .map((i) => i['insert'])
                                            .toList();
                                        List<String> mainContent =
                                            Cnote[0].toString().split('\n');
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 5,
                                            left: 5,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  // .withOpacity(1),
                                                  offset: Offset(0.0, 5.0),
                                                  blurRadius: 10,
                                                  spreadRadius: 0.1,
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Card(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: Text(
                                                        element.title
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: Text(mainContent[0]
                                                          .toString()),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: Text(element.date
                                                          .toString()),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }
                                },
                              )
                            : Center(
                                child: Text('You haven\' added any notes yet'),
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
//  Iterable list = json.decode(document['contents']);
//                           List<Note> Cnote =
//                               list.map((i) => Note.fromMap(i)).toList();
// static Note fromMap(Map map) {
//   return Note(
//     title: map['title'],
//     date: map['date'],
//   );
// }

class DataSearch extends SearchDelegate<String> {
  final allNotes;

  DataSearch({@required this.allNotes});
  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for appBar
    return [
      IconButton(
        icon: Icon(Icons.clear_outlined),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the appBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Note> suggestionList = query.isEmpty
        ? allNotes
        : allNotes.where((Note p) => p.title.contains(query)).toList();
    if (query.isEmpty) {
      return Center(
        child: Text('Search for the notes here'),
      );
    }
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (BuildContext context) {
                return ZefyrNote(
                  contents: NotusDocument.fromJson(
                    jsonDecode(suggestionList[index].contents),
                  ),
                  title: suggestionList[index].title,
                  id: suggestionList[index].id,
                  searchKey: suggestionList[index].searchKey,
                  date: suggestionList[index].date,
                );
              },
            ),
          );
        },
        leading: Icon(
          Icons.article_outlined,
          color: Colors.green,
        ),
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].title.substring(0, query.length),
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: suggestionList[index].title.substring(
                    query.length, suggestionList[index].title.length),
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline5.color,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return ListView.builder(
    //   itemCount: suggestionList.length,
    //   itemBuilder: (context, index) => ListTile(
    //     leading: Icon(Icons.note_outlined),
    //     // title: Text(suggestionList[index]),
    //     title: RichText(
    //       text: TextSpan(
    //         text: suggestionList[index].substring(0, query.length),
    //         style: TextStyle(
    //           color: Colors.black,
    //         ),
    //         children: [
    //           TextSpan(
    //             text: suggestionList[index].substring(query.length),
    //             style: TextStyle(
    //               color: Colors.grey,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
// import 'dart:convert';
// import 'dart:ui';
// import 'package:data_connection_checker/data_connection_checker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gradients/flutter_gradients.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:logger/logger.dart';
// import 'package:notado/auth/auth_bloc.dart';
// import 'package:notado/global/constants.dart';
// import 'package:notado/global/enums/enums.dart';
// import 'package:notado/global/helper/global_helper.dart';
// import 'package:notado/global/providers/zefyr_providers.dart';
// import 'package:notado/models/note_model/note_model.dart';
// import 'package:notado/ui/components/CircularProgress.dart';
// import 'package:notado/ui/screens/add_zefyr_note/add_zefyr_note.dart';
// import 'package:notado/ui/screens/handwritten_note_screen/handwritten_note.dart';
// import 'package:notado/ui/screens/home_page/bloc/home_bloc.dart';
// import 'package:notado/ui/components/snackbar.dart';
// import 'package:notado/ui/screens/login_page/login_screen.dart';
// import 'package:notado/ui/themes/theme.dart';
// import 'package:provider/provider.dart';
// import 'package:toast/toast.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:zefyr/zefyr.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => HomepageBloc()..add(NotesRequested()),
//       child: HomeScreenNoteList(),
//     );
//   }
// }

// class HomeScreenNoteList extends StatefulWidget {
//   @override
//   _HomeScreenNoteListState createState() => _HomeScreenNoteListState();
// }

// class _HomeScreenNoteListState extends State<HomeScreenNoteList>
//     with SingleTickerProviderStateMixin {
//   // List<String> _selectedTiles = [];
//   bool _showNetworkError = false;
//   var h = 1001.0694778740428;
//   final w = 462.03206671109666;
//   final padV60 = 60 / 1001.0694778740428;
//   final padH10 = 10 / 462.03206671109666;
//   AnimationController viewController;

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

//   Future<bool> _onBackPressed() async {
//     DateTime currentBackPressTime;
//     var deTl = Provider.of<SelectedTileProvider>(context);
//     if (deTl.selectedOnes.length == 0) {
//       DateTime now = DateTime.now();
//       if (currentBackPressTime == null ||
//           now.difference(currentBackPressTime) > Duration(seconds: 2)) {
//         currentBackPressTime = now;
//         Toast.show('Press again to exit', context);
//         return Future.value(false);
//       }
//       return Future.value(true);
//     } else {
//       Future.delayed(Duration(milliseconds: 1), () {
//         deTl.clearSelectedOnes();
//         return false;
//       });
//     }
//     ///////////////////////////////////////////////
//     ///////////////////////////////////////////////
//     // if (!selectListItem.isSelecting) {
//     //   DateTime now = DateTime.now();
//     //   if (currentBackPressTime == null ||
//     //       now.difference(currentBackPressTime) > Duration(seconds: 2)) {
//     //     currentBackPressTime = now;
//     //     Toast.show('Press again to exit', context);
//     //     return Future.value(false);
//     //   }
//     //   return Future.value(true);
//     // } else {
//     //   Future.delayed(Duration(milliseconds: 1), () {
//     //     changeSelectedListItem.clearselectedItemsList();
//     //     selectListItem.isSelecting = false;
//     //     return false;
//     //   });
//     // }
//   }

//   @override
//   void initState() {
//     viewController =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 500));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool status = Theme.of(context).brightness == Brightness.dark;
//     ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
//     final size = MediaQuery.of(context).size;
//     var notemodeC = Provider.of<NoteModeProvider>(context);
//     return BlocConsumer<HomepageBloc, HomeState>(
//       listener: (context, state) {
//         if (state is HomeInitial) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset('assets/logo.png'),
//                 CircularProgressIndicator(),
//               ],
//             ),
//           );
//         }
//         // if (state is HomepageLoaded) {}
//         if (state is HomepageError) {
//           context.showSnackBar(state.message);
//         }
//         if (state is HomepageLoading) {
//           showProgress(context);
//         }
//         if (state is HomepageSuccess) {
//           Navigator.of(context).pop();
//           BlocProvider.of<HomepageBloc>(context).add(NotesRequested());
//         }
//         if (state is NewZefyrPageLoaded) {
//           Navigator.of(context).push(
//             MaterialPageRoute(builder: (BuildContext context) {
//               return ZefyrNote();
//             }),
//           );
//         }
//         if (state is EditZefyrpageLoaded) {
//           Navigator.of(context).push(
//             MaterialPageRoute(builder: (BuildContext context) {
//               return ZefyrNote(
//                 contents: state.contents,
//                 title: state.title,
//                 id: state.id,
//                 date: state.date,
//                 searchKey: state.searchKey,
//               );
//             }),
//           );
//         }
//         if (state is CreateLoading) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (state is UpdateLoading) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (state is DeletingNotes) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (state is Cancelled) {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (BuildContext context) {
//                 return HomeScreen();
//               },
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         if (state is HomepageLoaded) {
//           return SafeArea(
//             child: WillPopScope(
//               onWillPop: _onBackPressed,
//               child: Consumer<SelectedTileProvider>(
//                 builder: (context, sTileP, child) {
//                   logger.v('Rebuilding');
//                   return Scaffold(
//                     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                     // appBar: sTileP.selectedOnes.length != 0
//                     //     ? AppBar(
//                     //         title: Text(
//                     //           'HOME',
//                     //           style: TextStyle(
//                     //             letterSpacing: 1.0,
//                     //             color:
//                     //                 Theme.of(context).textTheme.headline5.color,
//                     //           ),
//                     //         ),
//                     //         iconTheme: Theme.of(context).iconTheme.copyWith(
//                     //               color: Theme.of(context).iconTheme.color,
//                     //             ),
//                     //         backgroundColor:
//                     //             Theme.of(context).scaffoldBackgroundColor,
//                     //         leading: IconButton(
//                     //           icon: Icon(Icons.arrow_back_outlined),
//                     //           onPressed: () {
//                     //             logger.v('Back Button Pressed');
//                     //             sTileP.clearSelectedOnes();
//                     //           },
//                     //         ),
//                     //         actions: [
//                     //           IconButton(
//                     //             icon: Icon(Icons.delete_outline),
//                     //             onPressed: () {
//                     //               //TODO: this below code dosen't work
//                     //               //TODO: this below code dosen't work
//                     //               //TODO: this below code dosen't work
//                     //               List<Note> dNotesList = sTileP.selectedOnes;
//                     //               BlocProvider.of<HomepageBloc>(context).add(
//                     //                 DeleteNotesRequest(dNotesList),
//                     //               );
//                     //               sTileP.clearSelectedOnes();
//                     //             },
//                     //           ),
//                     //           IconButton(
//                     //             // icon: Icon(Icons.select_all_outlined),
//                     //             icon: Icon(Icons.select_all_outlined),
//                     //             onPressed: () {
//                     //               if (sTileP.selectedOnes.length ==
//                     //                   state.notelist.length) {
//                     //                 sTileP.clearSelectedOnes();
//                     //               } else {
//                     //                 sTileP.clearSelectedOnes();

//                     //                 for (var i = 0;
//                     //                     i < state.notelist.length;
//                     //                     i++) {
//                     //                   sTileP.tilePressed(note: state.notelist[i]);
//                     //                 }
//                     //               }
//                     //             },
//                     //           ),
//                     //         ],
//                     //       )
//                     //     : AppBar(
//                     //         // flexibleSpace: Container(
//                     //         //   decoration: BoxDecoration(
//                     //         //     gradient: FlutterGradients.aquaGuidance(
//                     //         //       center: Alignment.bottomLeft,
//                     //         //       type: GradientType.linear,
//                     //         //     ),
//                     //         //   ),
//                     //         // ),
//                     //         title: Text(
//                     //           'HOME',
//                     //           style: TextStyle(
//                     //             letterSpacing: 1.0,
//                     //             color:
//                     //                 Theme.of(context).textTheme.headline5.color,
//                     //           ),
//                     //         ),
//                     //         iconTheme: Theme.of(context).iconTheme.copyWith(
//                     //               color: Theme.of(context).iconTheme.color,
//                     //             ),
//                     //         // backgroundColor: Colors.blueGrey[100],
//                     //         backgroundColor:
//                     //             Theme.of(context).scaffoldBackgroundColor,
//                     //         elevation: 0.0,
//                     //         actions: <Widget>[
//                     //           IconButton(
//                     //             icon: Icon(Icons.search_outlined),
//                     //             onPressed: () {
//                     //               showSearch(
//                     //                 context: context,
//                     //                 delegate:
//                     //                     DataSearch(allNotes: state.notelist),
//                     //               );
//                     //             },
//                     //           ),
//                     //           // IconButton(
//                     //           //   icon: AnimatedIcon(
//                     //           //     icon: AnimatedIcons.list_view,
//                     //           //     progress: viewController,
//                     //           //   ),
//                     //           //   onPressed: () {
//                     //           //     if (Provider.of<NotesViewProvider>(context,
//                     //           //                 listen: false)
//                     //           //             .view ==
//                     //           //         notesView.list) {
//                     //           //       viewController.forward();
//                     //           //       Provider.of<NotesViewProvider>(context,
//                     //           //               listen: false)
//                     //           //           .view = notesView.grid;
//                     //           //     } else {
//                     //           //       viewController.reverse();
//                     //           //       Provider.of<NotesViewProvider>(context,
//                     //           //               listen: false)
//                     //           //           .view = notesView.list;
//                     //           //     }
//                     //           //   },
//                     //           // ),
//                     //           PopupMenuButton(
//                     //             itemBuilder: (BuildContext context) {
//                     //               return <PopupMenuItem>[
//                     //                 PopupMenuItem<String>(
//                     //                   child: GestureDetector(
//                     //                     onTap: () {
//                     //                       logger.v('Sort By');
//                     //                       return showDialog(
//                     //                         context: context,
//                     //                         child: AlertDialog(
//                     //                           title: Text('Sort by'),
//                     //                           content: ListView(
//                     //                             shrinkWrap: true,
//                     //                             children: <Widget>[
//                     //                               ListTile(
//                     //                                 leading: Radio(
//                     //                                   value: null,
//                     //                                   groupValue: null,
//                     //                                   onChanged: null,
//                     //                                 ),
//                     //                                 title: Text('Name'),
//                     //                               ),
//                     //                               ListTile(
//                     //                                 leading: Radio(
//                     //                                   value: null,
//                     //                                   groupValue: null,
//                     //                                   onChanged: null,
//                     //                                 ),
//                     //                                 title: Text('Date Modified'),
//                     //                               ),
//                     //                             ],
//                     //                           ),
//                     //                         ),
//                     //                       );
//                     //                     },
//                     //                     child: Container(
//                     //                       child: Text('Sort by'),
//                     //                     ),
//                     //                   ),
//                     //                 ),
//                     //                 PopupMenuItem<String>(
//                     //                   child: GestureDetector(
//                     //                     onTap: () {
//                     //                       logger.v('view');
//                     //                       if (Provider.of<NotesViewProvider>(
//                     //                                   context,
//                     //                                   listen: false)
//                     //                               .view ==
//                     //                           notesView.list) {
//                     //                         Provider.of<NotesViewProvider>(
//                     //                                 context,
//                     //                                 listen: false)
//                     //                             .view = notesView.grid;
//                     //                         Navigator.of(context).pop();
//                     //                       } else {
//                     //                         Provider.of<NotesViewProvider>(
//                     //                                 context,
//                     //                                 listen: false)
//                     //                             .view = notesView.list;
//                     //                         Navigator.of(context).pop();
//                     //                       }
//                     //                     },
//                     //                     child: Container(
//                     //                       child: Provider.of<NotesViewProvider>(
//                     //                                       context,
//                     //                                       listen: false)
//                     //                                   .view ==
//                     //                               notesView.list
//                     //                           ? Text('Grid View')
//                     //                           : Text('List View'),
//                     //                     ),
//                     //                   ),
//                     //                 ),
//                     //               ];
//                     //             },
//                     //           ),
//                     //           // PopupMenuButton(
//                     //           //   //TODO: isn't working
//                     //           //   onSelected: (value) {
//                     //           //     print(value.toString());
//                     //           //   },
//                     //           //   itemBuilder: (BuildContext context) {
//                     //           //     return <PopupMenuItem>[
//                     //           //       PopupMenuItem<String>(
//                     //           //         child: Row(
//                     //           //           children: [
//                     //           //             Icon(Icons.sort),
//                     //           //             SizedBox(width: 5),
//                     //           //             Text('Sort by'),
//                     //           //           ],
//                     //           //         ),
//                     //           //       ),
//                     //           //       PopupMenuItem<String>(
//                     //           //         child: Row(
//                     //           //           children: [
//                     //           //             Icon(Icons.error_outline),
//                     //           //             SizedBox(width: 5),
//                     //           //             Text('Account Info'),
//                     //           //           ],
//                     //           //         ),
//                     //           //       ),
//                     //           //     ];
//                     //           //   },
//                     //           // ),
//                     //         ],
//                     //       ),
//                     drawer: sTileP.selectedOnes.length != 0
//                         ? null
//                         : Drawer(
//                             child: Container(
//                               // color: Colors.blueGrey[900],
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                   // colors: [
//                                   //   Colors.blueGrey[700],
//                                   //   Colors.blueGrey[700],
//                                   //   Colors.blueGrey[800],
//                                   //   Colors.blueGrey[900],
//                                   // ],
//                                   colors: [
//                                     Colors.green[500],
//                                     Colors.green[500],
//                                     Colors.green[700],
//                                     Colors.green[800],
//                                   ],
//                                   // colors: [
//                                   //   Colors.deepPurple[500],
//                                   //   Colors.deepPurple[500],
//                                   //   Colors.deepPurple[700],
//                                   //   Colors.purple[900],
//                                   // ],
//                                 ),
//                               ),
//                               // color: Colors.deepPurple,
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                   vertical: padV60 * size.height,
//                                   horizontal: padH10 * size.width,
//                                 ),
//                                 child: ListView(
//                                   shrinkWrap: true,
//                                   children: <Widget>[
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: (padV60 / 6) * size.height,
//                                       ),
//                                       child: Container(
//                                         child: ListTile(
//                                           leading: CircleAvatar(
//                                             child: Image.network(
//                                                 globalUser.photoUrl),
//                                           ),
//                                           title: Text(
//                                             globalUser.displayName,
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                           subtitle: Text(
//                                             globalUser.email,
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: (padV60 / 6) * size.height,
//                                       ),
//                                       child: Divider(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: (padV60 / 6) * size.height,
//                                       ),
//                                       child: Container(
//                                         child: ListTile(
//                                           leading: Icon(
//                                             Icons.home_outlined,
//                                             color: Colors.white,
//                                           ),
//                                           title: Text(
//                                             'My Notes',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: (padV60 / 6) * size.height,
//                                       ),
//                                       child: Container(
//                                         child: ListTile(
//                                           onTap: () {},
//                                           leading: Icon(
//                                             FontAwesomeIcons.trash,
//                                             color: Colors.white,
//                                           ),
//                                           title: Text(
//                                             'Trash',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: (padV60 / 6) * size.height,
//                                       ),
//                                       child: Container(
//                                         child: ListTile(
//                                           leading: Icon(
//                                             FontAwesomeIcons.themeisle,
//                                             color: Colors.white,
//                                           ),
//                                           title: Text(
//                                             'Dark Mode',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                           trailing: Switch(
//                                             value: status,
//                                             onChanged: (value) {
//                                               status = value;
//                                               status == true
//                                                   ? _themeChanger.setTheme(
//                                                       ThemeData.dark())
//                                                   : _themeChanger.setTheme(
//                                                       ThemeData.light());
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: (padV60 / 6) * size.height,
//                                       ),
//                                       child: Container(
//                                         child: ListTile(
//                                           onTap: () {
//                                             BlocProvider.of<AuthenticationBloc>(
//                                                     context)
//                                                 .add(LoggedOut());
//                                             //TODO: implement going to login screen here
//                                           },
//                                           leading: Icon(
//                                             Icons.logout,
//                                             //TODO: update
//                                             color: Colors.white,
//                                           ),
//                                           title: Text(
//                                             'Logout',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: (padV60 / 6) * size.height,
//                                       ),
//                                       child: Divider(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: (padV60 / 6) * size.height,
//                                       ),
//                                       child: Container(
//                                         child: ListTile(
//                                           leading: Icon(
//                                             Icons.share_outlined,
//                                             color: Colors.white,
//                                           ),
//                                           title: Text(
//                                             'Share App',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: (padV60 / 6) * size.height,
//                                       ),
//                                       child: Container(
//                                         child: ListTile(
//                                           leading: Icon(
//                                             Icons.star_border_outlined,
//                                             color: Colors.white,
//                                           ),
//                                           title: Text(
//                                             'Rate Us',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: (padV60 / 6) * size.height,
//                                       ),
//                                       child: Container(
//                                         child: ListTile(
//                                           leading: Icon(
//                                             Icons.support_outlined,
//                                             color: Colors.white,
//                                           ),
//                                           title: Text(
//                                             'Support Developers',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: (padV60 / 6) * size.height,
//                                       ),
//                                       child: Container(
//                                         child: ListTile(
//                                           onTap: () async {
//                                             String url =
//                                                 ' mailto:notado.care@gmail.com?subject=User Experience@Notado';

//                                             if (await canLaunch(url) &&
//                                                 await _checkConnection()) {
//                                               _checkConnection();
//                                               launch(url);
//                                             } else {
//                                               // setState(() {
//                                               //   print('netwrok error');
//                                               //   _showNetworkError = true;
//                                               // });
//                                               Toast.show(
//                                                 'Network Error',
//                                                 context,
//                                                 backgroundColor:
//                                                     Colors.grey[300],
//                                                 textColor: Colors.black,
//                                               );
//                                               Navigator.of(context).pop();
//                                             }
//                                           },
//                                           leading: Icon(
//                                             Icons.contact_mail_outlined,
//                                             color: Colors.white,
//                                           ),
//                                           title: Text(
//                                             'Contact Us',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: (padV60 / 6) * size.height,
//                                       ),
//                                       child: Divider(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     Column(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: <Widget>[
//                                         Text(
//                                           'Made with ❤️ in India',
//                                           style: TextStyle(
//                                             fontSize: 11,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                         Text(
//                                           'Copyright © 2020 Dot.Studios LLC',
//                                           style: TextStyle(
//                                             fontSize: 11,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                     // floatingActionButton: FloatingActionButton(
//                     //   onPressed: () {
//                     //     notemodeC.notemode = zefyrNoteMode.newNote;
//                     //     logger.v('Current Note Mode ${notemodeC.notemode}');
//                     //     // BlocProvider.of<HomepageBloc>(context)
//                     //     //     .add(NewNoteRequest());
//                     //     Navigator.of(context).push(
//                     //       CupertinoPageRoute(
//                     //         builder: (BuildContext context) {
//                     //           return ZefyrNote();
//                     //         },
//                     //       ),
//                     //     );
//                     //   },
//                     //   child: Icon(
//                     //     Icons.add,
//                     //     // color: Colors.brown,
//                     //   ),
//                     //   // backgroundColor: Colors.blueGrey[900],
//                     //   backgroundColor: Colors.deepPurple,
//                     // ),
//                     floatingActionButton: SpeedDial(
//                       // overlayColor: Colors.black12,
//                       backgroundColor: Colors.green,
//                       child: Icon(Icons.add_outlined),
//                       children: [
//                         SpeedDialChild(
//                           backgroundColor: Colors.purple[500],
//                           onTap: () {
//                             notemodeC.notemode = zefyrNoteMode.newNote;
//                             logger.v('Current Note Mode ${notemodeC.notemode}');
//                             // BlocProvider.of<HomepageBloc>(context)
//                             //     .add(NewNoteRequest());
//                             Navigator.of(context).push(
//                               CupertinoPageRoute(
//                                 builder: (BuildContext context) {
//                                   return ZefyrNote();
//                                 },
//                               ),
//                             );
//                           },
//                           label: 'Add Note',
//                           child: Icon(Icons.note_add_outlined),
//                         ),
//                         SpeedDialChild(
//                           onTap: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                   builder: (BuildContext context) {
//                                 return DrawScreen();
//                               }),
//                             );
//                           },
//                           backgroundColor: Colors.purple[500],
//                           label: 'Handwritten Note',
//                           child: Icon(Icons.brush_outlined),
//                         ),
//                         SpeedDialChild(
//                           onTap: () {
//                             //TODO: implement
//                           },
//                           backgroundColor: Colors.purple[500],
//                           label: 'Insert Image',
//                           child: Icon(Icons.add_a_photo),
//                         ),
//                         SpeedDialChild(
//                           onTap: () {
//                             //TODO: implement
//                           },
//                           backgroundColor: Colors.purple[500],
//                           label: 'Insert Audio',
//                           child: Icon(Icons.mic_outlined),
//                         ),
//                       ],
//                     ),
//                     bottomNavigationBar: BottomAppBar(
//                       child: Row(
//                         children: <Widget>[],
//                       ),
//                     ),
//                     body: CustomScrollView(
//                       shrinkWrap: true,
//                       slivers: <Widget>[
//                         SliverAppBar(
//                           iconTheme: Theme.of(context).iconTheme.copyWith(
//                                 color: Theme.of(context).iconTheme.color,
//                               ),
//                           expandedHeight: 200,
//                           floating: true,
//                           pinned: true,
//                           flexibleSpace: FlexibleSpaceBar(
//                             title: Text(
//                               'HOME',
//                               style: TextStyle(
//                                 letterSpacing: 1.0,
//                                 color:
//                                     Theme.of(context).textTheme.headline5.color,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Consumer<NotesViewProvider>(
//                           builder: (context, notView, child) {
//                             if (notView.view == notesView.list)
//                               return SliverList(
//                                 delegate: SliverChildListDelegate(
//                                   state.notelist.map(
//                                     (element) {
//                                       Iterable list =
//                                           json.decode(element.contents);
//                                       List Cnote =
//                                           list.map((i) => i['insert']).toList();
//                                       List<String> mainContent =
//                                           Cnote[0].toString().split('\n');
//                                       return Padding(
//                                         padding: EdgeInsets.only(bottom: 5),
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             boxShadow: <BoxShadow>[
//                                               BoxShadow(
//                                                 color: Theme.of(context)
//                                                     .scaffoldBackgroundColor,
//                                                 // .withOpacity(1),
//                                                 offset: Offset(0.0, 5.0),
//                                                 blurRadius: 10,
//                                                 spreadRadius: 0.1,
//                                               ),
//                                             ],
//                                           ),
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             child: ListTile(
//                                               tileColor: status != true
//                                                   ? Colors.white
//                                                   : Colors.black,
//                                               // trailing: _selectedTiles
//                                               //         .contains(element.id)
//                                               //     ? Icon(Icons.check_box)
//                                               //     : null,
//                                               // onTap: () {
//                                               //   logger.v('Note Pressed');
//                                               //   if (_selectedTiles.length != 0) {
//                                               //     if (_selectedTiles
//                                               //         .contains(element.id)) {
//                                               //       setState(() {
//                                               //         _selectedTiles
//                                               //             .remove(element.id);
//                                               //       });
//                                               //     } else {
//                                               //       setState(() {
//                                               //         _selectedTiles
//                                               //             .add(element.id);
//                                               //       });
//                                               //     }
//                                               //   }
//                                               // },
//                                               // onLongPress: () {
//                                               //   logger.v('Note Long Pressed');
//                                               //   setState(() {
//                                               //     if (!_selectedTiles
//                                               //         .contains(element.id))
//                                               //       _selectedTiles.add(element.id);
//                                               //   });
//                                               // },
//                                               //  selected: _selectedTiles
//                                               //   .contains(element.id),
//                                               onTap: () {
//                                                 logger.v('Note Pressed');
//                                                 if (sTileP
//                                                         .selectedOnes.length !=
//                                                     0)
//                                                   sTileP.tilePressed(
//                                                       note: element);
//                                                 else {
//                                                   notemodeC.notemode =
//                                                       zefyrNoteMode.editNote;
//                                                   Navigator.of(context).push(
//                                                     CupertinoPageRoute(
//                                                       builder: (BuildContext
//                                                           context) {
//                                                         return ZefyrNote(
//                                                           contents:
//                                                               NotusDocument
//                                                                   .fromJson(
//                                                             jsonDecode(element
//                                                                 .contents),
//                                                           ),
//                                                           title: element.title,
//                                                           id: element.id,
//                                                           searchKey:
//                                                               element.searchKey,
//                                                           date: element.date,
//                                                         );
//                                                       },
//                                                     ),
//                                                   );
//                                                 }
//                                               },
//                                               onLongPress: () {
//                                                 logger.v('Note Long Pressed');
//                                                 sTileP.tilePressed(
//                                                     note: element);
//                                               },
//                                               trailing: sTileP.selectedOnes
//                                                       .contains(element)
//                                                   ? Icon(
//                                                       Icons
//                                                           .check_circle_outline,
//                                                     )
//                                                   : null,
//                                               selected: sTileP.selectedOnes
//                                                   .contains(element),
//                                               selectedTileColor: status != true
//                                                   ? Colors.grey[200]
//                                                   : Colors.black54,
//                                               dense: false,
//                                               title: Text(
//                                                 element.title.toString(),
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: TextStyle(
//                                                   color: status != true
//                                                       ? Colors.black
//                                                       : Colors.white,
//                                                 ),
//                                               ),
//                                               // subtitle: Text(element.date),
//                                               isThreeLine: true,
//                                               subtitle: Text(
//                                                 mainContent[0] +
//                                                     '...\n' +
//                                                     element.date,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: TextStyle(
//                                                   color: status != true
//                                                       ? Colors.black
//                                                       : Colors.white,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     //  Padding(
//                                     //   padding: EdgeInsets.only(bottom: 0.5),
//                                     //   child: FlatButton(
//                                     //     onPressed: null,
//                                     //     onLongPress: () {},
//                                     //     child: element,
//                                     //   ),
//                                     // ),
//                                   ).toList(),
//                                 ),
//                               );
//                             return Container(
//                               child: Text('ppppppppppppppp'),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           );
//         }
//         return Container();
//       },
//     );
//   }
// }
// //  Iterable list = json.decode(document['contents']);
// //                           List<Note> Cnote =
// //                               list.map((i) => Note.fromMap(i)).toList();
// // static Note fromMap(Map map) {
// //   return Note(
// //     title: map['title'],
// //     date: map['date'],
// //   );
// // }

// class DataSearch extends SearchDelegate<String> {
//   final allNotes;

//   DataSearch({@required this.allNotes});
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     //actions for appBar
//     return [
//       IconButton(
//         icon: Icon(Icons.clear_outlined),
//         onPressed: () {
//           query = "";
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     // leading icon on the left of the appBar
//     return IconButton(
//       icon: AnimatedIcon(
//         icon: AnimatedIcons.menu_arrow,
//         progress: transitionAnimation,
//       ),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {}

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestionList = query.isEmpty ? allNotes : [];
//     return ListView.builder(
//       itemCount: suggestionList.length,
//       itemBuilder: (context, index) => ListTile(
//         leading: Icon(Icons.note_outlined),
//         // title: Text(suggestionList[index]),
//         title: RichText(
//           text: TextSpan(
//             text: suggestionList[index].substring(0, query.length),
//             style: TextStyle(
//               color: Colors.black,
//             ),
//             children: [
//               TextSpan(
//                 text: suggestionList[index].substring(query.length),
//                 style: TextStyle(
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
