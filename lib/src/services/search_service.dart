import 'dart:async';
import 'dart:convert';

import 'package:ebom/src/config/app_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResultItem {
  String type;
  dynamic data;
  ResultItem({required this.type, required this.data});
}

class SearchProvider extends ChangeNotifier {
  String _keyword = '';
  int _categoryId = 0;
  String _currentScreen = '';

  final Map<String, List<String>> _filters = {
    'products_screen': [],
    'entreprises_screen': [],
    'services_screen': [],
  };

  String get keyword => _keyword;
  int get categoryId => _categoryId;
  String get currentScreen => _currentScreen;
  Map<String, List<String>> get filters => _filters;

  void setKeyword(String value) {
    _keyword = value;
    notifyListeners();
  }

  void setCategoryId(int value) {
    _categoryId = value;
    notifyListeners();
  }

  void setCurrentScreen(String value) {
    _currentScreen = value;
    notifyListeners();
  }

  void setFilters(String screen, List<String> values) {
    _filters[screen] = values;
    notifyListeners();
  }

  void toggleFilters(String screen, String id) {
    if (_filters[screen]!.contains(id)) {
      _filters[screen]!.remove(id);
    } else {
      _filters[screen]!.add(id);
    }
    notifyListeners();
  }
}

class SearchService {
  Future<List<ResultItem>> search(dynamic data) {
    final completer = Completer<List<ResultItem>>();
    String url = AppApi.search;

    http
        .post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);

        List<ResultItem> list = [];
        for (int i = 0; i < res['data']['entreprises'].length; i++) {
          list.add(
            ResultItem(
              type: 'Entreprise',
              data: res['data']['entreprises'][i],
            ),
          );
        }
        for (int i = 0; i < res['data']['produits'].length; i++) {
          list.add(
            ResultItem(
              type: 'Produit',
              data: res['data']['produits'][i],
            ),
          );
        }
        for (int i = 0; i < res['data']['services'].length; i++) {
          list.add(
            ResultItem(
              type: 'Service',
              data: res['data']['services'][i],
            ),
          );
        }
        completer.complete(list);
      } else {
        completer.complete([]);
        //completer.completeError('Failed to load product categories');
      }
    }).catchError((error) {
      completer.complete([]);
      //completer.completeError(error.toString());
    });

    return completer.future;
  }
}
