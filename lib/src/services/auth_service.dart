import 'dart:async';
import 'package:ebom/src/config/app_api.dart';
import 'package:ebom/src/services/connexion_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

class RegisterData {
  final String appareil;
  final String? nom;
  final String? naissance;
  final String? sexe;
  final String telephone;
  final String? email;
  final String role;

  RegisterData({
    required this.appareil,
    required this.telephone,
    required this.role,
    this.nom,
    this.naissance,
    this.sexe,
    this.email,
  });
}

class OTPResponse {
  final bool status;
  final String message;

  OTPResponse({required this.status, required this.message});
}

class LoginResponse {
  final bool newSession;
  final bool status;
  final String message;

  LoginResponse({
    required this.status,
    required this.message,
    this.newSession = true,
  });
}

class AuthService {
  final String? baseUrl;

  AuthService({this.baseUrl = AppApi.account});

  Future<OTPResponse> verifyOTP(
    String code,
    RegisterData data,
    String mode,
  ) async {
    final Completer<OTPResponse> completer = Completer();

    // Simulating an HTTP request to verify the OTP
    http
        .post(
      Uri.parse('$baseUrl/auth/$mode/confirm/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'code': code,
        'role': data.role,
        'telephone': data.telephone,
        'appareil': data.appareil,
      }),
    )
        .then((response) async {
      final responseBody = json.decode(response.body);

      switch (responseBody['data']) {
        case '0':
          completer.completeError(
            OTPResponse(status: false, message: 'Code invalide'),
          );
          break;
        case '-1':
          completer.completeError(
            OTPResponse(
              status: false,
              message: "Une erreur c'est produite",
            ),
          );
          break;
        default:
          // Enregister la connexion dans la session.
          // Store a new connexion into shared preferences.
          ConnexionService conn = ConnexionService();
          await conn.create(responseBody['data']);

          // Complete the future.
          completer.complete(OTPResponse(status: true, message: 'Code valid'));
          break;
      }
    }).catchError((error) {
      completer.completeError('Network error: $error'); // Handle network errors
    });

    return completer.future;
  }

  Future<LoginResponse> login(RegisterData data) {
    final Completer<LoginResponse> completer = Completer<LoginResponse>();

    final url = Uri.parse(
      '$baseUrl/auth/login/client',
    );

    http
        .post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'appareil': data.appareil,
          'telephone': data.telephone,
        },
      ),
    )
        .then((response) async {
      final responseBody = json.decode(response.body);

      if (responseBody['data'] is String) {
        switch (responseBody['data']) {
          case '0':
            completer.completeError(
              'Numero de telephone incorrecte',
            );
            break;
          case '-1':
            completer.completeError(
              'compte bloque',
            );
            break;
          default:
            completer.complete(
              LoginResponse(status: true, message: ''),
            );
            break;
        }
      } else {
        if (responseBody['data']['email'] == null) {
          // Is a new session creation.
          // use will redirect to code asking page.
          completer.complete(
            LoginResponse(status: true, message: ''),
          );
        } else {
          // It's not a new session. User redirect to home page.
          ConnexionService conn = ConnexionService();
          await conn.create(responseBody['data']);
          completer.complete(
            LoginResponse(status: true, message: '', newSession: false),
          );
        }
      }
    }).catchError((error) {
      // completer.completeError(
      //   "Une erreur s'est produite",
      // ); // Handle network error
      completer.completeError(error.toString());
    });
    return completer.future;
  }

  Future<bool> register(RegisterData data) {
    final Completer<bool> completer = Completer<bool>();
    final url = Uri.parse(
      '$baseUrl/auth/register/client',
    );

    http
        .post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'appareil': data.appareil,
          'nom': data.nom,
          'sexe': data.sexe,
          'naissance': data.naissance,
          'telephone': data.telephone,
          'email': data.email,
          'role': 'client',
        },
      ),
    )
        .then((response) {
      final responseBody = json.decode(response.body);
      //print(responseBody);

      if (responseBody['data'] is String) {
        switch (responseBody['data']) {
          case '0':
            completer.completeError(
              "Un probleme  d'enregistrement  est survenu",
            );
            break;
          case '-1':
            completer.completeError(
              'Addresse email est deja utilise',
            );
            break;
          case '-2':
            completer.completeError(
              'Le telephone est deja utilise',
            );
            break;
          default:
            completer.complete(true);
            break;
        }
      } else {
        if (responseBody['data']['telephone'] != null) {
          completer.complete(true);
        } else {
          completer.completeError('Verifiez votre connexion internet. E1');
        }
      }
    }).catchError((error) {
      // print(error);
      completer.completeError(
        'Verifiez votre connexion internet.E2',
      ); // Handle network error
    });
    return completer.future;
  }

  Future<String> getDeviseId(BuildContext context) async {
    final Completer<String> completer = Completer<String>();

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String device = prefs.getString('ebom_device') ?? '';

    if (device == '') {
      // ignore: use_build_context_synchronously
      if (Theme.of(context).platform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        device =
            '${androidInfo.model}${androidInfo.manufacturer}${androidInfo.version.release}${androidInfo.device}${DateTime.now().millisecondsSinceEpoch}';
        // ignore: use_build_context_synchronously
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        device =
            '${iosInfo.model}${iosInfo.systemName}${iosInfo.systemVersion}${iosInfo.name}${DateTime.now().millisecondsSinceEpoch}';
      }

      await prefs.setString('ebom_device', device);
    }

    completer.complete(device);

    return completer.future;
  }
}
