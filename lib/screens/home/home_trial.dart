import 'package:flutter/material.dart';
import 'package:notado/models/note_model.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/user_repository/user_Repository.dart';
import 'package:notado/services/database.dart';

class HomeTrial extends StatefulWidget {
  final UserRepository userRepository;

  const HomeTrial({Key key, this.userRepository}) : super(key: key);
  @override
  _HomeTrialState createState() => _HomeTrialState();
}

class _HomeTrialState extends State<HomeTrial> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String uid;
  getUID() async {
    uid = await widget.userRepository.getUser();
  }

  @override
  void initState() {
    getUID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Note>>.value(
      value: DatabaseService(uid: uid).notesZefyrFromNotes,
      child: Scaffold(),
    );
  }
}
