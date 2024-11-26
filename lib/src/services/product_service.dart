import 'dart:async';
import 'dart:convert';
import 'package:ebom/src/config/app_api.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl;

  ProductService({this.baseUrl = AppApi.data});

  // Method to get all product categories using Completer
  Future<List<dynamic>> items() async {
    final completer = Completer<List<dynamic>>();

    final url = '$baseUrl/produits';

    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        // Return the result.
        completer.complete(res['data']);
      } else {
        completer.completeError('Failed to load product categories');
      }
    }).catchError((error) {
      completer.completeError(error.toString());
    });

    return completer.future;
  }

  Future<List<dynamic>> dynamicItems(String apiUri) async {
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

  Future<List<dynamic>> search(String keyword) async {
    final completer = Completer<List<dynamic>>();

    String url = AppApi.search;

    // Initial request
    http
        .post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {'search': keyword},
      ),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        completer.complete(res['data']['produits']);
      } else {
        completer.complete([]);
      }
    }).catchError((error) {
      completer.complete([]);
    });

    return completer.future;
  }

  Future<List<dynamic>> searchByCategory(int id) async {
    final completer = Completer<List<dynamic>>();

    // Load the initial request.
    http.get(Uri.parse('$baseUrl/produits/categorie/$id')).then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        // Save to cache.
        completer.complete(res['data']);
      } else {
        completer.complete([]);
      }
    }).catchError((error) {
      completer.complete([]);
    });

    return completer.future;
  }
}
