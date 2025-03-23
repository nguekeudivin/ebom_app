import 'dart:async';
import 'dart:convert';
import 'package:ebom/src/config/app_api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentService {
  final String baseUrl;

  PaymentService({this.baseUrl = AppApi.payment});

  Future<List<dynamic>> methods() {
    final completer = Completer<List<dynamic>>();

    http.get(Uri.parse('$baseUrl/services-paiements')).then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        // Return the result.
        completer.complete(res['data']);
      } else {
        completer.completeError('Failed to load paiements services');
      }
    }).catchError((error) {
      completer.completeError(error.toString());
    });

    return completer.future;
  }

  Future<dynamic> init(
    String deviseId,
    String phoneNumber,
    int subscriptionTypeId,
    int amount,
  ) async {
    final Completer<dynamic> completer = Completer();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('ebom_token') as String;

    http
        .post(
      Uri.parse('$baseUrl/service/paiement/init'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'userKey': token,
      },
      body: jsonEncode({
        'appareil': deviseId,
        'telephone': phoneNumber,
        'service_paiement': subscriptionTypeId,
        'montant': amount,
      }),
    )
        .then((response) async {
      // print(jsonEncode({
      //   'appareil': deviseId,
      //   'telephone': phoneNumber,
      //   'service_paiement': subscriptionTypeId,
      //   'montant': amount
      // }));
      switch (response.statusCode) {
        case 200:
          final responseBody = json.decode(response.body);
          completer.complete(responseBody['data']);
          break;
        case 401:
          completer.completeError(
            "Une erreur s'est produite aucours de l'initialisation du paiement.",
          );
        case 404:
          completer.completeError(
            "Une erreur s'est produite aucours de l'initialisation du paiement.",
          );
          break;
        case 405:
          completer.completeError(
            "Une erreur s'est produite aucours de l'initialisation du paiement.",
          );
          break;
      }
    }).catchError((error) {
      completer.completeError(
        "Une erreur s'est produite",
      );
    });

    return completer.future;
  }

  Future<String> status(
    String deviseId,
    String transactionId,
  ) async {
    final Completer<String> completer = Completer();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('ebom_token') as String;

    http
        .post(
      Uri.parse('$baseUrl/service/paiement/status'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'userKey': token,
      },
      body: jsonEncode({'appareil': deviseId, 'transaction_id': transactionId}),
    )
        .then((response) async {
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        // The transaction id.
        completer.complete(responseBody['data']);
      } else if (response.statusCode == 404) {
        final responseBody = json.decode(response.body);
        if (responseBody['data'] == '1') {
          // Return empty transaction id for running transaction.
          completer.complete('');
        } else {
          if (responseBody['data'] == '-1') {
            completer.completeError('La transaction a échoué');
          }

          if (responseBody['data'] == '-2') {
            completer.completeError('La transaction a été annulée');
          }

          if (responseBody['data'] == '-3') {
            completer.completeError('La délai est dépassé');
          }
        }
      } else {
        completer.completeError("Une erreur c'est produite");
      }
    }).catchError((error) {
      completer.completeError(
        "Une erreur c'est produite",
      );
    });

    return completer.future;
  }
}
