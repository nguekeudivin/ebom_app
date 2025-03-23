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
        for (int i = 0; i < res['data'].length; i++) {
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

  Future<Entreprise> getSimpleEntreprise(int id) async {
    final completer = Completer<Entreprise>();

    http.get(Uri.parse('$baseUrl/entreprises/$id')).then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);

        if (res['data']['id'] == null) {
          completer.completeError('Aucune information');
        } else {
          if (res['data']['id'] is String) {
            if (res['data']['id'] == '0') {
              completer.completeError('Aucune information');
            } else {
              completer.complete(Entreprise.fromDynamic(res['data']));
            }
          } else {
            if (res['data']['id'] == 0) {
              completer.completeError('Aucune information');
            } else {
              completer.complete(Entreprise.fromDynamic(res['data']));
            }
          }
        }
      } else {
        completer.completeError("Un probleme est survenu c'est produite");
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

        if (res['data']['id'] == null) {
          completer.completeError('Aucune information');
        } else {
          completer.complete(Entreprise.fromDynamic(res['data']));

          // if (res['data']['id'] is String) {
          //   if (res['data']['id'] == '0') {
          //     completer.completeError('Aucune information');
          //   } else {
          //     completer.complete(Entreprise.fromDynamic(res['data']));
          //   }
          // } else {
          //   if (res['data']['id'] == 0) {
          //     completer.completeError('Aucune information');
          //   } else {
          //     completer.complete(Entreprise.fromDynamic(res['data']));
          //   }
          // }
        }
      } else {
        completer.completeError("Un probleme est survenu c'est produite");
      }
    }).catchError((error) {
      completer.completeError(error.toString());
    });

    return completer.future;
  }

  Future<List<Entreprise>> search(String keyword) {
    final completer = Completer<List<Entreprise>>();
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
        List<Entreprise> list = [];
        for (int i = 0; i < res['data']['entreprises'].length; i++) {
          list.add(Entreprise.fromDynamic(res['data']['entreprises'][i]));
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

  Future<List<Entreprise>> searchByCategory(int id) {
    final completer = Completer<List<Entreprise>>();
    http
        .get(
      Uri.parse('$baseUrl/type_entreprise/$id/entreprises'),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        List<Entreprise> list = [];
        for (int i = 0; i < res['data'].length; i++) {
          list.add(Entreprise.fromDynamic(res['data'][i]));
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
