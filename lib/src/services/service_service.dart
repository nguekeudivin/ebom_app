import 'dart:async';
import 'dart:convert';
import 'package:ebom/src/config/app_api.dart';
import 'package:ebom/src/models/service.dart';
import 'package:http/http.dart' as http;

class ServiceService {
  final String baseUrl;

  ServiceService({this.baseUrl = AppApi.data});

  // Method to get all product categories using Completer
  Future<List<Service>> items() {
    final completer = Completer<List<Service>>();

    http.get(Uri.parse('$baseUrl/services')).then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        List<Service> list = [];
        for (int i = 0; i < res['data'].length; i++) {
          list.add(Service.fromDynamic(res['data'][i]));
        }
        completer.complete(list);
      } else {
        completer.completeError('Failed to load product categories');
      }
    }).catchError((error) {
      completer.completeError(error.toString());
    });

    return completer.future;
  }

  // Method to get all product categories using Completer
  Future<List<Service>> dynamicItems(String apiUri) {
    final completer = Completer<List<Service>>();

    http.get(Uri.parse('$baseUrl/$apiUri')).then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        List<Service> list = [];
        for (int i = 0; i < res['data'].length; i++) {
          list.add(Service.fromDynamic(res['data'][i]));
        }
        completer.complete(list);
      } else {
        completer.completeError('Failed to load product categories');
      }
    }).catchError((error) {
      completer.completeError(error.toString());
    });

    return completer.future;
  }

  Future<List<Service>> search(String keyword) {
    final completer = Completer<List<Service>>();
    String url = AppApi.search;
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
        List<Service> list = [];
        for (int i = 0; i < res['data']['services'].length; i++) {
          list.add(Service.fromDynamic(res['data']['services'][i]));
        }
        completer.complete(list);
      } else {
        completer.complete([]);
        // completer.completeError('Failed to load product categories');
      }
    }).catchError((error) {
      completer.complete([]);
      //completer.completeError(error.toString());
    });

    return completer.future;
  }

  Future<List<Service>> searchByCategory(int id) {
    final completer = Completer<List<Service>>();
    http
        .get(
      Uri.parse('$baseUrl/services/categorie/$id'),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        List<Service> list = [];
        for (int i = 0; i < res['data'].length; i++) {
          list.add(Service.fromDynamic(res['data'][i]));
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
