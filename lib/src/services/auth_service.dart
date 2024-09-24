import 'dart:async';
import 'package:ebom/src/config/app_api.dart';
import 'package:ebom/src/types/auth_types.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String? baseUrl;

  AuthService({this.baseUrl = AppApi.url});

  Future<String> verifyOTP(String otp) {
    final Completer<String> completer = Completer();

    // Simulating an HTTP request to verify the OTP
    http
        .post(
      Uri.parse('$baseUrl/verify-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'otp': otp}),
    )
        .then((response) {
      if (response.statusCode == 200) {
        // Assuming the response body contains a message
        final responseBody = json.decode(response.body);
        completer
            .complete(responseBody['message']); // Resolve with success message
      } else {
        completer.completeError(
          'Verification failed. Please try again.',
        ); // Reject with an error
      }
    }).catchError((error) {
      completer.completeError('Network error: $error'); // Handle network errors
    });

    return completer.future;
  }

  Future<bool> loginWithPhoneNumber(String phoneNumber) {
    final Completer<bool> completer = Completer<bool>();
    final url =
        Uri.parse('$baseUrl/login/phone'); // Adjust the endpoint as needed

    http
        .post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'phone_number': phoneNumber,
      }),
    )
        .then((response) {
      if (response.statusCode == 200) {
        completer.complete(true); // Login successful
      } else {
        completer.complete(false); // Login failed
      }
    }).catchError((error) {
      completer.complete(false); // Handle exceptions
    });

    return completer.future;
  }

  Future<bool> register(RegisterData data) {
    final Completer<bool> completer = Completer<bool>();
    final url = Uri.parse('$baseUrl/register'); // Adjust the endpoint as needed

    http
        .post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': data.name,
        'birthdate': data.birthdate,
        'gender': data.gender,
        'phone_number': data.phoneNumber,
        'email': data.email,
      }),
    )
        .then((response) {
      if (response.statusCode == 201) {
        completer.complete(true); // Registration successful
      } else {
        completer.complete(false); // Registration failed
      }
    }).catchError((error) {
      completer.complete(false); // Handle network error
    });

    return completer.future;
  }
}
