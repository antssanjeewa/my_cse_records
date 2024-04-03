import 'package:flutter/material.dart';

class ScreenIndexProvider extends ChangeNotifier {
  int screenIndex = 0;

  int get currentScreenIndex {
    return screenIndex;
  }

  void updateScreenIndex(int index) {
    screenIndex = index;
    notifyListeners();
  }
}
