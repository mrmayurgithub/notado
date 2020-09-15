import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notado/global/helper/global_helper.dart';
import 'package:notado/ui/components/CircularProgress.dart';
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
        if (state is HomeInitial) {}
        if (state is HomepageLoaded) {}
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
      },
      builder: (context, state) {
        if (state is HomepageLoaded) {
          return Scaffold(
            appBar: AppBar(),
            drawer: Drawer(),
            floatingActionButton: FloatingActionButton(
              onPressed: () => {},
              child: Icon(Icons.add),
            ),
            bottomNavigationBar: BottomAppBar(),
            body: RefreshIndicator(
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
                                    padding: EdgeInsets.only(bottom: 15),
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
          );
        }
      },
    );
  }
}
