import 'dart:async';
import 'dart:convert';
import 'package:ebom/src/config/app_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoriesService {
  final String baseUrl;

  CategoriesService({this.baseUrl = AppApi.data});

  // Method to get all product categories using Completer
  Future<List<dynamic>> productCategories() {
    final completer = Completer<List<dynamic>>();

    http.get(Uri.parse('$baseUrl/categories/produits')).then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        completer.complete(res['data']);
      } else {
        completer.completeError('Failed to load product categories');
      }
    }).catchError((error) {
      completer.completeError(error.toString());
    });

    return completer.future;
  }

  // Method to get all service categories using Completer
  Future<List<dynamic>> serviceCategories() {
    final completer = Completer<List<dynamic>>();

    http.get(Uri.parse('$baseUrl/categories/services')).then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        completer.complete(res['data']);
      } else {
        completer.completeError('Failed to load service categories');
      }
    }).catchError((error) {
      completer.completeError('Error: $error');
    });

    return completer.future;
  }

  // Method to get all service categories using Completer
  Future<List<dynamic>> typeEntreprises() {
    final completer = Completer<List<dynamic>>();

    http.get(Uri.parse('$baseUrl/types/entreprises')).then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        completer.complete(res['data']);
      } else {
        completer.completeError('Failed to load service categories');
      }
    }).catchError((error) {
      completer.completeError('Error: $error');
    });

    return completer.future;
  }
}

class CategoriesProvider extends ChangeNotifier {
  List<dynamic> _categories = [];

  List<dynamic> get categories => _categories;

  void searchProductCategories() {
    CategoriesService service = CategoriesService();

    service.productCategories().then((items) {
      _categories = items;
      notifyListeners();
    });
  }
}
