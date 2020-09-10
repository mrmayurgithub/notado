import 'package:flutter/cupertino.dart';

enum whichScreen {
  home,
  profile,
  trash,
}

var currentScreen = whichScreen.home;

enum noteMode { editNote, newNote }
noteMode nmode = noteMode.newNote;
