import 'package:flutter/cupertino.dart';
import 'package:notado/global/enums/enums.dart';

class NoteModeProvider with ChangeNotifier {
  zefyrNoteMode _notemode = zefyrNoteMode.newNote;
  zefyrNoteMode get notemode => _notemode;
  set notemode(zefyrNoteMode val) {
    _notemode = val;
    notifyListeners();
  }
}

class CurrentScreenProvider with ChangeNotifier {
  currentScreen _whichscreen = currentScreen.home;
  currentScreen get whichscreen => _whichscreen;
  set whichscreen(currentScreen val) {
    _whichscreen = val;
    notifyListeners();
  }
}

class NotesViewProvider with ChangeNotifier {
  notesView _view = notesView.list;
  notesView get view => _view;
  set view(notesView val) {
    _view = val;
    notifyListeners();
  }
}
