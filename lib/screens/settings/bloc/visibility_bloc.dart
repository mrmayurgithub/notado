import 'package:flutter/cupertino.dart';

class VisibilityBloc extends ChangeNotifier {
  bool isPassVis1 = false;
  bool isPassVis2 = false;
  bool isPassVis3 = false;

  getisPass1() => isPassVis1;
  getisPass2() => isPassVis2;
  getisPass3() => isPassVis3;

  setisPass1(bool v) {
    isPassVis1 = v;
    notifyListeners();
  }

  setisPass2(bool v) {
    isPassVis2 = v;
    notifyListeners();
  }

  setisPass3(bool v) {
    isPassVis3 = v;
    notifyListeners();
  }
}
