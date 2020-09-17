import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:notado/global/constants.dart';
import 'package:notado/global/helper/global_helper.dart';
import 'package:notado/global/providers/zefyr_providers.dart';
import 'package:notado/models/note_model/note_model.dart';
import 'package:notado/ui/components/CircularProgress.dart';
import 'package:notado/ui/screens/add_zefyr_note/add_zefyr_note.dart';
import 'package:notado/ui/screens/home_page/bloc/home_bloc.dart';
import 'package:notado/ui/components/snackbar.dart';
import 'package:provider/provider.dart';

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

class _HomeScreenNoteListState extends State<HomeScreenNoteList> {
  // List<String> _selectedTiles = [];
  @override
  Widget build(BuildContext context) {
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
                  appBar: sTileP.selectedOnes.length != 0
                      ? AppBar(
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
                          backgroundColor: Colors.white,
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
                            // IconButton(
                            //   icon: Icon(Icons.settings),
                            //   onPressed: () {},
                            // ),
                            PopupMenuButton(
                              //TODO: isn't working
                              onSelected: (value) {
                                print(value.toString());
                              },
                              itemBuilder: (BuildContext context) {
                                return <PopupMenuItem>[
                                  PopupMenuItem<String>(
                                    child: Row(
                                      children: [
                                        Icon(Icons.sort),
                                        SizedBox(width: 5),
                                        Text('Sort by'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    child: Row(
                                      children: [
                                        Icon(Icons.error_outline),
                                        SizedBox(width: 5),
                                        Text('Account Info'),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                            ),
                            // DropdownButton<String>(
                            //   // isExpanded: true,
                            //   underline: SizedBox(),
                            //   icon: Icon(Icons.more_vert),
                            //   items: <String>[
                            //     'Sort By',
                            //     'Settings',
                            //     'Account Info'
                            //   ].map<DropdownMenuItem<String>>((String val) {
                            //     return DropdownMenuItem<String>(
                            //       child: Text(val),
                            //       value: val,
                            //       onTap: () {
                            //         //TODO: implement
                            //       },
                            //     );
                            //   }).toList(),
                            //   onChanged: (val) {},
                            // ),
                          ],
                        ),
                  drawer: sTileP.selectedOnes.length != 0 ? null : Drawer(),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => BlocProvider.of<HomepageBloc>(context)
                        .add(NewNoteRequest()),
                    child: Icon(
                      Icons.add,
                      // color: Colors.brown,
                    ),
                    backgroundColor: Colors.teal,
                  ),
                  bottomNavigationBar: BottomAppBar(),
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
                    color: Colors.white,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await initializeApi;
                        BlocProvider.of<HomepageBloc>(context)
                            .add(NotesRequested());
                      },
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: <Widget>[
                            state.notelist.length > 0
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                          padding: EdgeInsets.only(bottom: 0.5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                  color: Colors.grey[100],
                                                  // .withOpacity(1),
                                                  offset: Offset(0.0, 5.0),
                                                  blurRadius: 10,
                                                  spreadRadius: 0.1,
                                                ),
                                              ],
                                            ),
                                            child: ListTile(
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
                                                if (sTileP
                                                        .selectedOnes.length !=
                                                    0)
                                                  sTileP.tilePressed(
                                                      note: element);
                                              },
                                              onLongPress: () {
                                                logger.v('Note Long Pressed');
                                                sTileP.tilePressed(
                                                    note: element);
                                              },

                                              selected: sTileP.selectedOnes
                                                  .contains(element),
                                              selectedTileColor:
                                                  Colors.blueGrey[200],
                                              dense: false,
                                              title: Text(
                                                element.title.toString(),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              // subtitle: Text(element.date),
                                              isThreeLine: true,
                                              subtitle: Text(
                                                mainContent[0] +
                                                    '...\n' +
                                                    element.date,
                                                overflow: TextOverflow.ellipsis,
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
                                  )
                                : Center(
                                    child:
                                        Text('You haven\' added any notes yet'),
                                  ),
                          ],
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
