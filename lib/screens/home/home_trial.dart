import 'package:flutter/material.dart';
import 'package:notado/models/note_model.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/user_repository/user_Repository.dart';
import 'package:notado/services/database.dart';

class HomeTrial extends StatefulWidget {
  final UserRepository userRepository;
  final DatabaseService databaseService;

  const HomeTrial(
      {Key key, this.userRepository, @required this.databaseService})
      : super(key: key);
  @override
  _HomeTrialState createState() => _HomeTrialState();
}

class _HomeTrialState extends State<HomeTrial> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: widget.databaseService.notesZefyrFromNotes,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else
            return ListView(
              children: snapshot.data.documents.map<Widget>((document) {
                return ListTile(
                  title: Text(document['contents'].toString()),
                );
              }).toList(),
            );
        },
      ),
    );
  }
}
