import 'package:flutter/cupertino.dart';

// enum whichScreen {
//   home,
//   profile,
//   trash,
// }

// var currentScreen = whichScreen.home;

enum noteMode { editNote, newNote }
// noteMode nmode = noteMode.newNote;

class NoteModeProvider with ChangeNotifier {
  noteMode _notesmode = noteMode.newNote;
  noteMode get notesmode => _notesmode;
  set notesmode(noteMode val) {
    _notesmode = val;
    print('value changed.....' + val.toString());
    notifyListeners();
  }
}

//###############################################

enum currentScreen {
  home,
  study,
  trash,
  settings,
  login,
  search,
}

class currentScreenProvider with ChangeNotifier {
  currentScreen _whichScreen = currentScreen.home;
  currentScreen get whichScreen => _whichScreen;
  set whichScreen(currentScreen val) {
    _whichScreen = val;
    notifyListeners();
  }
}
