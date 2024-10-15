import 'dart:async';
import 'dart:convert';
import 'package:ebom/src/config/app_api.dart';
import 'package:ebom/src/models/entreprise.dart';
import 'package:http/http.dart' as http;

class EntrepriseService {
  final String baseUrl;

  EntrepriseService({this.baseUrl = AppApi.data});

  // Method to get all product categories using Completer
  Future<List<Entreprise>> items() async {
    final completer = Completer<List<Entreprise>>();

    http.get(Uri.parse('$baseUrl/entreprises')).then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        List<Entreprise> list = [];
        for (int i = 0; i < 5; i++) {
          list.add(Entreprise.fromDynamic(res['data'][i]));
        }
        completer.complete(list);
      } else {
        completer.completeError("Une erreur c'est produite");
      }
    }).catchError((error) {
      completer.completeError(error.toString());
    });

    return completer.future;
  }

  Future<Entreprise> getEntreprise(int id) async {
    final completer = Completer<Entreprise>();

    http.get(Uri.parse('$baseUrl/marketplace/entreprise/$id')).then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        completer.complete(Entreprise.fromDynamic(res['data']));
      } else {
        completer.completeError("Une erreur c'est produite");
      }
    }).catchError((error) {
      completer.completeError(error.toString());
    });

    return completer.future;
  }
}
