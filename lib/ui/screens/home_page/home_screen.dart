import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    viewController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var notemodeC = Provider.of<NoteModeProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        DateTime currentBackPressTime;
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
      },
      child: BlocConsumer<HomepageBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeInitial) {
            return Center(child: CircularProgressIndicator());
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
            return Consumer<SelectedTileProvider>(
              builder: (context, sTileP, child) {
                print('rebuildddddddddddddddddddddd........');
                return Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  appBar: sTileP.selectedOnes.length != 0
                      ? AppBar(
                          iconTheme: Theme.of(context)
                              .iconTheme
                              .copyWith(color: Colors.black),
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back),
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
                              icon: Icon(Icons.select_all_outlined),
                              onPressed: () {},
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

                          iconTheme: Theme.of(context).iconTheme.copyWith(
                                color: Colors.black,
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
                                  delegate: DataSearch(),
                                );
                              },
                            ),
                            IconButton(
                              icon: AnimatedIcon(
                                icon: AnimatedIcons.list_view,
                                progress: viewController,
                              ),
                              onPressed: () {
                                if (Provider.of<NotesViewProvider>(context,
                                            listen: false)
                                        .view ==
                                    notesView.list) {
                                  viewController.forward();
                                  Provider.of<NotesViewProvider>(context,
                                          listen: false)
                                      .view = notesView.grid;
                                } else {
                                  viewController.reverse();
                                  Provider.of<NotesViewProvider>(context,
                                          listen: false)
                                      .view = notesView.list;
                                  ;
                                }
                              },
                            ),
                            // PopupMenuButton(
                            //   //TODO: isn't working
                            //   onSelected: (value) {
                            //     print(value.toString());
                            //   },
                            //   itemBuilder: (BuildContext context) {
                            //     return <PopupMenuItem>[
                            //       PopupMenuItem<String>(
                            //         child: Row(
                            //           children: [
                            //             Icon(Icons.sort),
                            //             SizedBox(width: 5),
                            //             Text('Sort by'),
                            //           ],
                            //         ),
                            //       ),
                            //       PopupMenuItem<String>(
                            //         child: Row(
                            //           children: [
                            //             Icon(Icons.error_outline),
                            //             SizedBox(width: 5),
                            //             Text('Account Info'),
                            //           ],
                            //         ),
                            //       ),
                            //     ];
                            //   },
                            // ),
                          ],
                        ),
                  drawer: sTileP.selectedOnes.length != 0
                      ? null
                      : Drawer(
                          child: Container(
                            // color: Colors.blueGrey[900],
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                // colors: [
                                //   Colors.blueGrey[700],
                                //   Colors.blueGrey[700],
                                //   Colors.blueGrey[800],
                                //   Colors.blueGrey[900],
                                // ],
                                colors: [
                                  Colors.deepPurple[500],
                                  Colors.deepPurple[500],
                                  Colors.deepPurple[700],
                                  Colors.purple[900],
                                ],
                              ),
                            ),
                            // color: Colors.deepPurple,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: padV60 * size.height,
                                horizontal: padH10 * size.width,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: (padV60 / 6) * size.height,
                                    ),
                                    child: Container(
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          child: Image.network(
                                              globalUser.photoUrl),
                                        ),
                                        title: Text(
                                          globalUser.displayName,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        subtitle: Text(
                                          globalUser.email,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: (padV60 / 6) * size.height,
                                    ),
                                    child: Divider(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: (padV60 / 6) * size.height,
                                    ),
                                    child: Container(
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.home_outlined,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          'My Notes',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: (padV60 / 6) * size.height,
                                    ),
                                    child: Container(
                                      child: ListTile(
                                        leading: Icon(
                                          FontAwesomeIcons.bookOpen,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          'Study Notes',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: (padV60 / 6) * size.height,
                                    ),
                                    child: Container(
                                      child: ListTile(
                                        leading: Icon(
                                          FontAwesomeIcons.trash,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          'Trash',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: (padV60 / 6) * size.height,
                                    ),
                                    child: Container(
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.settings_outlined,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          'Settings',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: (padV60 / 6) * size.height,
                                    ),
                                    child: Container(
                                      child: ListTile(
                                        onTap: () {
                                          BlocProvider.of<AuthenticationBloc>(
                                                  context)
                                              .add(LoggedOut());
                                        },
                                        leading: Icon(
                                          Icons.logout,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          'Logout',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: (padV60 / 6) * size.height,
                                    ),
                                    child: Divider(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: (padV60 / 6) * size.height,
                                    ),
                                    child: Container(
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.share_outlined,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          'Share App',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: (padV60 / 6) * size.height,
                                    ),
                                    child: Container(
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.star_border_outlined,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          'Rate Us',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: (padV60 / 6) * size.height,
                                    ),
                                    child: Container(
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.support_outlined,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          'Support Developers',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: (padV60 / 6) * size.height,
                                    ),
                                    child: Container(
                                      child: ListTile(
                                        onTap: () async {
                                          String url =
                                              ' mailto:notado.care@gmail.com?subject=User Experience@Notado';

                                          if (await canLaunch(url) &&
                                              await _checkConnection()) {
                                            _checkConnection();
                                            launch(url);
                                          } else {
                                            // setState(() {
                                            //   print('netwrok error');
                                            //   _showNetworkError = true;
                                            // });
                                            Toast.show(
                                              'Network Error',
                                              context,
                                              backgroundColor: Colors.grey[300],
                                              textColor: Colors.black,
                                            );
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        leading: Icon(
                                          Icons.contact_mail_outlined,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          'Contact Us',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: (padV60 / 6) * size.height,
                                    ),
                                    child: Divider(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Made with ❤️ in India',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Copyright © 2020 Dot.Studios LLC',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                    // overlayColor: Colors.black12,
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.add_outlined),
                    children: [
                      SpeedDialChild(
                        backgroundColor: Colors.purple[500],
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
                        backgroundColor: Colors.purple[500],
                        label: 'Handwritten Note',
                        child: Icon(Icons.brush_outlined),
                      ),
                      SpeedDialChild(
                        onTap: () {
                          //TODO: implement
                        },
                        backgroundColor: Colors.purple[500],
                        label: 'Insert Image',
                        child: Icon(Icons.add_a_photo_outlined),
                      ),
                      SpeedDialChild(
                        onTap: () {
                          //TODO: implement
                        },
                        backgroundColor: Colors.purple[500],
                        label: 'Insert Audio',
                        child: Icon(Icons.mic_outlined),
                      ),
                    ],
                  ),
                  bottomNavigationBar: BottomAppBar(
                    child: Row(
                      children: <Widget>[],
                    ),
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
                                                  EdgeInsets.only(bottom: 5),
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
                                                  child: ListTile(
                                                    tileColor: Colors.white,
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
                                                      logger.v('Note Pressed');
                                                      if (sTileP.selectedOnes
                                                              .length !=
                                                          0)
                                                        sTileP.tilePressed(
                                                            note: element);
                                                      else {
                                                        notemodeC.notemode =
                                                            zefyrNoteMode
                                                                .editNote;
                                                        Navigator.of(context)
                                                            .push(
                                                          CupertinoPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return ZefyrNote(
                                                                contents:
                                                                    NotusDocument
                                                                        .fromJson(
                                                                  jsonDecode(element
                                                                      .contents),
                                                                ),
                                                                title: element
                                                                    .title,
                                                                id: element.id,
                                                                searchKey: element
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

                                                    selected: sTileP
                                                        .selectedOnes
                                                        .contains(element),
                                                    selectedTileColor:
                                                        Colors.blueGrey[200],
                                                    dense: false,
                                                    title: Text(
                                                      element.title.toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    // subtitle: Text(element.date),
                                                    isThreeLine: true,
                                                    subtitle: Text(
                                                      mainContent[0] +
                                                          '...\n' +
                                                          element.date,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
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
                                  else {}
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
            );
          }
          return Container();
        },
      ),
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
  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for appBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
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
    final suggestionList = query.isEmpty ? recentNotes : ['dhfdj'];
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.note_rounded),
        // title: Text(suggestionList[index]),
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].substring(0, query.length),
            style: TextStyle(
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: suggestionList[index].substring(query.length),
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final recentNotes = [
  'Note 1',
  'Note 2',
  'Note 3',
];
