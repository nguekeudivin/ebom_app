import 'dart:async';
import 'dart:convert';
import 'package:ebom/src/config/app_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubscriptionProvider extends ChangeNotifier {
  List<dynamic> _ongoing = [];

  List<dynamic> get ongoing => _ongoing;

  void setOngoing(List<dynamic> values) {
    _ongoing = values;
    notifyListeners();
  }

  bool canChat() {
    // Look is the is an ongoing freemium

    // If there is no ongoing freemium then look if the is an ongoing chat service.
    return false;
  }

  bool canSearch() {
    // Look is the is an ongoing freemium

    // If there is no ongoing freemium then look if the is an ongoing search service.
    return false;
  }
}

class SubscriptionService {
  final String baseUrl;

  SubscriptionService({this.baseUrl = AppApi.subscription});

  Future<List<dynamic>> items() {
    final completer = Completer<List<dynamic>>();

    http.get(Uri.parse('$baseUrl/services-abonnements')).then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        // Return the result.
        completer.complete(res['data']);
      } else {
        completer.completeError('Failed to load subscription plans');
      }
    }).catchError((error) {
      completer.completeError(error.toString());
    });

    return completer.future;
  }

  Future<List<dynamic>> ongoing(deviceId) {
    final completer = Completer<List<dynamic>>();

    http
        .get(Uri.parse('$baseUrl/abonnements/ongoing/$deviceId'))
        .then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        // Return the result.
        completer.complete(res['data']);
      } else {
        completer.completeError('Failed to load subscription plans');
      }
    }).catchError((error) {
      completer.completeError(error.toString());
    });

    return completer.future;
  }
}
