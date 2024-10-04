import 'dart:async';
import 'dart:convert';
import 'package:ebom/src/config/app_api.dart';
import 'package:http/http.dart' as http;

class CategorieManager {
  final String baseUrl;

  CategorieManager({this.baseUrl = AppApi.data});

  // Method to get all product categories using Completer
  Future<List<dynamic>> productCategories() {
    final completer = Completer<List<dynamic>>();

    http.get(Uri.parse('$baseUrl/categories/produits')).then((response) {
      if (response.statusCode == 200) {
        completer.complete(json.decode(response.body));
      } else {
        completer.completeError('Failed to load product categories');
      }
    }).catchError((error) {
      completer.completeError('Error: $error');
    });

    return completer.future;
  }

  // Method to get all service categories using Completer
  Future<List<dynamic>> serviceCategories() {
    final completer = Completer<List<dynamic>>();

    http.get(Uri.parse('$baseUrl/categories/services')).then((response) {
      if (response.statusCode == 200) {
        completer.complete(json.decode(response.body));
      } else {
        completer.completeError('Failed to load service categories');
      }
    }).catchError((error) {
      completer.completeError('Error: $error');
    });

    return completer.future;
  }
}
