import 'package:flutter/cupertino.dart';
import 'package:notado/global/enums/enums.dart';
import 'package:notado/models/note_model/note_model.dart';

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

class SelectedTileProvider with ChangeNotifier {
  List<Note> _selectedOnes = [];
  List<Note> get selectedOnes => _selectedOnes;
  // set selectedOnes(String val) {}
  tilePressed({@required Note note}) {
    if (_selectedOnes.contains(note)) {
      _selectedOnes.remove(note);
      notifyListeners();
    } else {
      _selectedOnes.add(note);
      notifyListeners();
    }
  }

  clearSelectedOnes() {
    _selectedOnes.clear();
    notifyListeners();
  }
}
