import 'package:flutter/material.dart';
import 'package:notado/models/note_model.dart';
import 'package:notado/screens/home/note_card.dart';
import 'package:provider/provider.dart';

class NotesList extends StatefulWidget {
  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<List<Note>>(context) ?? [];
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return NoteCard();
      },
    );
  }
}
