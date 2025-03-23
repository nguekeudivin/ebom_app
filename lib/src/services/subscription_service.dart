import 'dart:async';
import 'dart:convert';
import 'package:ebom/src/config/app_api.dart';
import 'package:ebom/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Subscription {
  final int id;
  final String reference;
  final int serviceAbonnement;
  final String transactionId;
  final String periode;
  final int duree;
  final String dateDebut;
  final String dateFin;
  final String service;
  final String forfait;
  final String dureeDetails;

  Subscription({
    required this.id,
    required this.reference,
    required this.serviceAbonnement,
    required this.transactionId,
    required this.periode,
    required this.duree,
    required this.dateDebut,
    required this.dateFin,
    required this.service,
    required this.forfait,
    required this.dureeDetails,
  });
}

class SubscriptionProvider extends ChangeNotifier {
  List<dynamic> _ongoing = [];
  List<dynamic> get ongoing => _ongoing;
  List<dynamic> _types = [];
  List<dynamic> _paymentMethods = [];
  bool _hasLoadOngoing = false;

  // Use for subscribtion process
  int _paymentMethodId = 0;
  String _selectedPlan = 'jour';
  int _unitPrice = 1;
  int _amount = 20;
  int _duration = 1;
  String _step = 'success';
  String _phoneNumber = '655660502';
  String _reference = '@chat';
  int _referenceId = 0;
  String _pendingTransactionId = '';

  String get selectedPlan => _selectedPlan;
  int get unitPrice => _unitPrice;
  int get amount => _amount;
  int get duration => _duration;
  String get step => _step;
  String get reference => _reference;
  int get referenceId => _referenceId;
  String get phoneNumber => _phoneNumber;
  List<dynamic> get types => _types;
  List<dynamic> get paymentMethods => _paymentMethods;
  int get paymentMethodId => _paymentMethodId;
  String get pendingTransactionId => _pendingTransactionId;

  List<Map<String, String>> getData() {
    Map<String, String> plans = {
      'jour': 'Jour',
      'annee': 'Annee',
      'semaine': 'Semaine',
      'mois': 'Mois',
    };

    return [
      {'label': 'Forfait', 'value': plans[_selectedPlan]!},
      {
        'label': 'Durée',
        'value':
            '$_duration ${plans[_selectedPlan]}${_duration > 1 && plans[_selectedPlan] != 'mois' ? 's' : ''}',
      },
      {'label': 'Montant à payer', 'value': '$_amount FCFA'},
      {'label': 'Mode de paiement', 'value': getPaymentMethodName()},
      {'label': 'Numéro', 'value': _phoneNumber},
    ];
  }

  int getReferenceId() {
    for (int i = 0; i < _types.length; i++) {
      if (_types[i]['reference'] == _reference) {
        return types[i]['id'];
      }
    }
    return 0;
  }

  String getPaymentMethodName() {
    for (int i = 0; i < _paymentMethods.length; i++) {
      if (_paymentMethods[i]['id'] == _paymentMethodId) {
        return _paymentMethods[i]['nom'];
      }
    }
    return '';
  }

  void setTypes(List<dynamic> types) {
    _types = types;
    notifyListeners();
  }

  void setPaymentMethods(List<dynamic> modes) {
    _paymentMethods = modes;
    _paymentMethodId = modes[0]['id'];
    notifyListeners();
  }

  void setPaymentMethodId(int id) {
    _paymentMethodId = id;
    notifyListeners();
  }

  void setSelectedPlan(String plan) {
    _selectedPlan = plan;
    notifyListeners();
  }

  void setUnitPrice(int unitPrice) {
    _unitPrice = unitPrice;
    notifyListeners();
  }

  void setAmount(int amount) {
    _amount = amount;
    notifyListeners();
  }

  void setDuration(int duration) {
    _duration = duration;
    notifyListeners();
  }

  void setStep(String step) {
    _step = step;
    notifyListeners();
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  void setReferenceId(int refId) {
    _referenceId = refId;
    notifyListeners();
  }

  void setReference(String ref) {
    _reference = ref;
    notifyListeners();
  }

  void start(String ref) {
    _reference = ref;
    _step = 'plan';
    _selectedPlan = 'jour';
    _pendingTransactionId = '';
    // Set has load hasLoadOngoing to false. So that at the end when the user will
    // Start the process again the system will load the current ongoing and that will be good.
    _hasLoadOngoing = false;
    notifyListeners();
  }

  void setPendingTransactionId(String id) {
    _pendingTransactionId = id;
    notifyListeners();
  }

  Future<bool> loadOngoing(BuildContext context) async {
    try {
      SubscriptionService service = SubscriptionService();
      AuthService authService = AuthService();

      // Load subscription types
      _types = await service.types();
      notifyListeners();

      // Get devise id
      // ignore: use_build_context_synchronously
      String deviseId = await authService.getDeviseId(context);

      // Load ongoing subscriptions
      _ongoing = await service.ongoing(deviseId);
      _hasLoadOngoing = true;
      notifyListeners();

      return true;
    } catch (error) {
      _ongoing = [];
      return false;
    }
  }

  void setOngoing(List<dynamic> values) {
    _ongoing = values;
    notifyListeners();
  }

  String getServiceReference(dynamic item) {
    for (int j = 0; j < _types.length; j++) {
      if (_types[j]['id'] == item['service_abonnement']) {
        return _types[j]['reference'];
      }
    }
    return '';
  }

  Future<bool> canChat(BuildContext context) async {
    bool exists = false;

    if (!_hasLoadOngoing) {
      await loadOngoing(context);
    }

    // Look is the is an ongoing freemium
    for (int i = 0; i < _ongoing.length; i++) {
      String serviceReference = getServiceReference(_ongoing[i]);

      // The the service reference indicator or name. example @free, @search.
      if (serviceReference == '@free') {
        exists = true;
      }

      if (serviceReference == '@chat') {
        exists = true;
      }
    }

    return exists;
  }

  Future<bool> canSearch(BuildContext context) async {
    bool exists = false;

    if (!_hasLoadOngoing) {
      await loadOngoing(context);
    }

    for (int i = 0; i < _ongoing.length; i++) {
      String serviceReference = getServiceReference(_ongoing[i]);

      if (serviceReference == '@free') {
        exists = true;
      }

      if (serviceReference == '@recherche') {
        exists = true;
      }
    }

    return exists;
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

  Future<List<dynamic>> ongoing(deviseId) async {
    final completer = Completer<List<dynamic>>();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('ebom_token') as String;

    http.get(
      Uri.parse('$baseUrl/abonnements/ongoing/$deviseId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'userKey': token,
      },
    ).then((response) {
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

  Future<List<dynamic>> types() async {
    final completer = Completer<List<dynamic>>();
    http
        .get(
      Uri.parse('$baseUrl/services-abonnements'),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        // Return the result.
        completer.complete(res['data']);
      } else {
        completer.completeError('Failed to load subscriptions types');
      }
    }).catchError((error) {
      completer.completeError(error.toString());
    });

    return completer.future;
  }

  Future<String> create(
    String deviseId,
    String transactionId,
    int refId,
    String plan,
    int duration,
  ) async {
    final Completer<String> completer = Completer();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('ebom_token') as String;

    http
        .post(
      Uri.parse('$baseUrl/abonnement/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'userKey': token,
      },
      body: jsonEncode({
        'appareil': deviseId,
        'transaction_id': transactionId,
        'service_abonnement': refId,
        'periode': plan,
        'duree': duration,
      }),
    )
        .then((response) async {
      switch (response.statusCode) {
        case 200:
          final responseBody = json.decode(response.body);
          completer.complete(responseBody['data']);
          break;
        default:
          completer.completeError("L'abonnement n'a pas pu etre enregistre");
          break;
      }
    }).catchError((error) {
      completer.completeError(
        "Une erreur c'est produite",
      );
    });

    return completer.future;
  }
}
