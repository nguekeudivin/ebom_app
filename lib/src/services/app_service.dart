import 'package:flutter/material.dart';

class AppLayoutNavigationProvider extends ChangeNotifier {
  int _active = 0;

  int get active => _active;

  void setActive(int value) {
    _active = value;
    notifyListeners();
  }

  void setActiveScreen(String name) {
    switch (name) {
      case 'entreprises_screen':
        _active = 1;
        break;
      case 'services_screen':
        _active = 2;
        break;
      case 'products_screen':
        _active = 3;
        break;
    }
    notifyListeners();
  }
}
