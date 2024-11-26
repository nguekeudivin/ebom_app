import 'dart:async';
import 'dart:convert';
import 'package:ebom/src/config/app_api.dart';
import 'package:ebom/src/models/connexion.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ConnexionService {
  Future<Connexion?> getConnexion() async {
    final Completer<Connexion?> completer = Completer<Connexion?>();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String connexionJsonString = prefs.getString('ebom_connexion') ?? '';

    if (connexionJsonString == '') {
      completer.complete(null);
    } else {
      completer.complete(Connexion.fromJsonString(connexionJsonString));
    }

    return completer.future;
  }

  Future<bool> logout() async {
    final Completer<bool> completer = Completer<bool>();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('ebom_connexion');
    //await prefs.remove('ebom_device');
    await prefs.remove('ebom_token');

    completer.complete(true);

    return completer.future;
  }

  Future<void> create(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Connexion connexion = Connexion(
      nom: data['nom'],
      sigle: data['sigle'],
      email: data['email'],
      telephone: data['telephone'],
      image: data['image'],
      role: data['role'],
    );
    prefs.setString('ebom_connexion', connexion.toJsonString());
    prefs.setString('ebom_token', data['token']);
  }

  Future<dynamic> checkConnexionStatus() async {
    Completer<bool> completer = Completer();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String device = prefs.getString('ebom_device') as String;

    String baseUrl = AppApi.account;
    http
        .get(Uri.parse('$baseUrl/connexion/$device/active'))
        .then((response) async {
      if (response.statusCode == 200) {
        completer.complete(true);
      } else {
        completer.complete(false);
      }
    }).catchError((error) {
      completer.completeError("une erreur s'est produite");
    });

    return completer.future;
  }

  Future<dynamic> getUser() async {
    Connexion connexion = await getConnexion() as Connexion;
    Completer<dynamic> completer = Completer();

    // Get the token from preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('ebom_token') as String;

    String device = prefs.getString('ebom_device') as String;
    String baseUrl = AppApi.account;

    http
        .post(
      Uri.parse('$baseUrl/auth/infos/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'userKey': token,
      },
      body: jsonEncode(
        {
          'appareil': device,
          'email': connexion.email,
        },
      ),
    )
        .then((response) async {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        completer.complete(res['data']);
      } else {
        completer.completeError("Une erreur s'est produite.");
      }
    }).catchError((error) {
      completer.completeError("une erreur s'est produite");
    });

    return completer.future;
  }

  Future<bool> updateUser(dynamic data) async {
    Completer<bool> completer = Completer();

    String baseUrl = AppApi.account;

    // Get token and device.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('ebom_token') as String;

    http
        .post(
      Uri.parse('$baseUrl/auth/update/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'userKey': token,
      },
      body: data,
    )
        .then((response) async {
      if (response.statusCode == 200) {
        completer.complete(true);
      } else {
        completer.completeError(
          "Une erreur c'est produite veuillez ressayez plus tard",
        );
      }
    }).catchError((error) {
      //completer.completeError("une erreur s'est produite");
      completer.completeError(error.toString());
    });

    return completer.future;
  }
}

class ConnexionProvider extends ChangeNotifier {
  Connexion? _connexion;

  Connexion? get connexion => _connexion;

  void loadConnexion() async {
    ConnexionService connservice = ConnexionService();
    connservice.getConnexion().then((conn) {
      _connexion = conn;
      notifyListeners();
    });
  }

  void removeConnexion() {
    _connexion = null;
    notifyListeners();
  }
}
