import 'dart:async';
import 'dart:convert';
import 'package:ebom/src/config/app_api.dart';
import 'package:ebom/src/models/service.dart';
import 'package:http/http.dart' as http;

class MarketService {
  final String baseUrl;

  MarketService({this.baseUrl = AppApi.data});

  // Method to get all product categories using Completer
  Future<List<Service>> items() {
    final completer = Completer<List<Service>>();

    http.get(Uri.parse('$baseUrl/services')).then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        List<Service> list = [];
        for (int i = 0; i < 5; i++) {
          list.add(Service.fromDynamic(res['data'][i]));
        }
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
