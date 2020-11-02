// import 'package:async/async.dart';
// import 'package:flutter/material.dart';
// import 'package:notado/models/note_model.dart';
// import 'package:notado/packages/packages.dart';
// import 'package:notado/screens/addnote/ZefyrEdit.dart';
// import 'package:notado/user_repository/user_Repository.dart';

// class HomeScreen extends StatefulWidget {
//   final UserRepository userRepository;

//   const HomeScreen({Key key, @required this.userRepository}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<Note> _notes = [];
//   final formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
//   Future<void> _loadNotes() async {
//     final jsonResponse =
//         await DefaultAssetBundle.of(context).loadString("assets/text.json");

//     setState(() {
//       _notes = Note.allFromResponse(jsonResponse);
//     });
//   }

//   Widget _buildNoteListTile(BuildContext context, int index) {
//     var note = _notes[index];

//     return new ListTile(
//       onTap: () => _navigateToNoteDetails(note, index),
//       title: new Text(note.title),
//       subtitle: new Text(formatter.format(note.date)),
//     );
//   }

//   void _navigateToNoteDetails(Note note, Object index) {
//     Navigator.of(context).push(
//       new MaterialPageRoute(
//         builder: (c) {
//           return ZefyrNote(note: note);
//         },
//       ),
//     );
//   }

//   @override
//   void initState() {
//     _loadNotes().then((onValue) {
//       setState(() {
//         //  _notes = onValue;
//       });
//     }).catchError(print);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget content;

//     if (_notes.isEmpty) {
//       content = new Center(
//         child: new CircularProgressIndicator(), //1
//       );
//     } else {
//       content = new ListView.builder(
//         //2
//         itemCount: _notes.length,
//         itemBuilder: _buildNoteListTile,
//       );
//     }

//     return new Scaffold(
//       appBar: new AppBar(title: new Text('MDEDitor')),
//       body: content,
//     );
//   }
// }
