import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  String _keyword = '';

  String get keyword => _keyword;

  void setKeyword(String value) {
    _keyword = value;
    notifyListeners();
  }
}
