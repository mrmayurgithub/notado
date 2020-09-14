import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:notado/packages/packages.dart';

enum noteMode { editNote, newNote }

class NoteModeProvider with ChangeNotifier {
  noteMode _notesmode = noteMode.newNote;
  noteMode get notesmode => _notesmode;
  set notesmode(noteMode val) {
    _notesmode = val;
    print('value changed.....' + val.toString());
    notifyListeners();
  }
}

enum currentScreen {
  home,
  study,
  trash,
  settings,
  login,
  search,
}

class CurrentScreenProvider with ChangeNotifier {
  currentScreen _whichScreen = currentScreen.home;
  currentScreen get whichScreen => _whichScreen;
  set whichScreen(currentScreen val) {
    _whichScreen = val;
    notifyListeners();
  }
}

class SelectListTile with ChangeNotifier {
  bool _isSelecting = false;
  bool get isSelecting => _isSelecting;
  set isSelecting(bool val) {
    _isSelecting = val;
    notifyListeners();
  }
}

class ChangeSelectedListItemProvider with ChangeNotifier {
  List<String> _selectedItemsIDList = [];
  listItemPressed({@required String id}) {
    if (_selectedItemsIDList.contains(id)) {
      _selectedItemsIDList.remove(id);
      notifyListeners();
    } else {
      _selectedItemsIDList.add(id);
      notifyListeners();
    }
  }

  clearselectedItemsList() {
    _selectedItemsIDList.clear();
    notifyListeners();
  }

  List<String> get selectedItemsIDList => _selectedItemsIDList;
}

enum notelistViewType { listView, gridView }

class NoteListViewProvider with ChangeNotifier {
  notelistViewType _view = notelistViewType.listView;
  notelistViewType get view => _view;
  set view(val) {
    _view = val;
    notifyListeners();
  }
}
