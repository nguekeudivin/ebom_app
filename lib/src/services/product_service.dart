import 'dart:async';
import 'dart:convert';
import 'package:ebom/src/config/app_api.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl;

  ProductService({this.baseUrl = AppApi.data});

  // Method to get all product categories using Completer
  Future<List<dynamic>> items() {
    final completer = Completer<List<dynamic>>();

    http.get(Uri.parse('$baseUrl/produits')).then((response) {
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

  Future<List<dynamic>> dynamicItems(String apiUri) {
    final completer = Completer<List<dynamic>>();

    http.get(Uri.parse('$baseUrl/$apiUri')).then((response) {
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
}
