import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:notado/global/helper/global_helper.dart';
import 'package:notado/ui/components/CircularProgress.dart';
import 'package:notado/ui/screens/add_zefyr_note/add_zefyr_note.dart';
import 'package:notado/ui/screens/home_page/bloc/home_bloc.dart';
import 'package:notado/ui/components/snackbar.dart';

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
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomepageBloc, HomeState>(
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
          return Scaffold(
            appBar: AppBar(
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
              backgroundColor: Colors.blueGrey[100],
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {},
                ),
              ],
            ),
            drawer: Drawer(),
            floatingActionButton: FloatingActionButton(
              onPressed: () =>
                  BlocProvider.of<HomepageBloc>(context).add(NewNoteRequest()),
              child: Icon(Icons.add),
            ),
            bottomNavigationBar: BottomAppBar(),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueGrey[100],
                    Colors.blueGrey[100],
                    Colors.blueGrey[100],
                    Colors.blueGrey[100],
                  ],
                ),
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  await initializeApi;
                  BlocProvider.of<HomepageBloc>(context).add(NotesRequested());
                },
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      state.notelist.length > 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: state.notelist
                                  .map(
                                    (element) => Padding(
                                      padding: EdgeInsets.only(bottom: 0.5),
                                      child: FlatButton(
                                        onPressed: null,
                                        onLongPress: () {},
                                        child: element,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            )
                          : Center(
                              child: Text('You haven\' added any notes yet'),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
