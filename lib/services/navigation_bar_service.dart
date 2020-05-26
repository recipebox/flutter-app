import 'package:flutter/material.dart';

class BottomNavigationBarService with ChangeNotifier {
  int _currentIndex = 0;
  bool _detail = false;

  get currentIndex => _currentIndex;
  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  get showDetail => _detail;
  set showDetail(bool show) {
    _detail = show;
    notifyListeners();
  }
}
