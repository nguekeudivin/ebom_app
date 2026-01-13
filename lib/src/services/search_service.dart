import 'dart:async';
import 'dart:convert';

import 'package:ebom/src/config/app_api.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class ResultItem {
  String type;
  dynamic data;
  ResultItem({required this.type, required this.data});
}

class SearchProvider extends ChangeNotifier {
  String _keyword = '';
  int _categoryId = 0;
  String _currentScreen = '';

  final Map<String, List<String>> _filters = {
    'products_screen': [],
    'entreprises_screen': [],
    'services_screen': [],
  };

  String get keyword => _keyword;
  int get categoryId => _categoryId;
  String get currentScreen => _currentScreen;
  Map<String, List<String>> get filters => _filters;

  void setKeyword(String value) {
    _keyword = value;
    notifyListeners();
  }

  void setCategoryId(int value) {
    _categoryId = value;
    notifyListeners();
  }

  void setCurrentScreen(String value) {
    _currentScreen = value;
    notifyListeners();
  }

  void setFilters(String screen, List<String> values) {
    _filters[screen] = values;
    notifyListeners();
  }

  void toggleFilters(String screen, String id) {
    if (_filters[screen]!.contains(id)) {
      _filters[screen]!.remove(id);
    } else {
      _filters[screen]!.add(id);
    }
    notifyListeners();
  }
}

class SearchService {
  // Map de flux et cache par type
  final Map<String, StreamController<List<ResultItem>>> _controllers = {};
  final Map<String, List<ResultItem>> _cache = {};

  // Accès au flux selon le type
  Stream<List<ResultItem>> stream(String type) {
    if (!_controllers.containsKey(type)) {
      _controllers[type] = StreamController<List<ResultItem>>.broadcast();
      _cache[type] = [];
      _loadCacheFromHive(type);
    }
    return _controllers[type]!.stream;
  }

  // Rechercher et mettre à jour le cache
  Future<List<ResultItem>> search(Map<String, dynamic> params) async {
    final type = params['type'] as String?;

    // Si aucun type n'est fourni, pas de cache
    if (type == null || type.isEmpty) {
      try {
        final response = await http.post(
          Uri.parse(AppApi.search),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(params),
        );

        if (response.statusCode == 200) {
          final res = json.decode(response.body);
          final List<ResultItem> list = [];

          // On peut retourner tous les types mélangés ici
          if (res['data']['produits'] != null) {
            list.addAll((res['data']['produits'] as List)
                .map((item) => ResultItem(type: 'Produit', data: item)));
          }
          if (res['data']['services'] != null) {
            list.addAll((res['data']['services'] as List)
                .map((item) => ResultItem(type: 'Service', data: item)));
          }
          if (res['data']['entreprises'] != null) {
            list.addAll((res['data']['entreprises'] as List)
                .map((item) => ResultItem(type: 'Entreprise', data: item)));
          }

          return list; // pas de cache
        }
      } catch (e) {
        return []; // en cas d'erreur, retourne une liste vide
      }
    } else {
      // --- cas normal avec type fourni → cache et flux ---
      if (!_controllers.containsKey(type)) {
        _controllers[type] = StreamController<List<ResultItem>>.broadcast();
        _cache[type] = [];
        _loadCacheFromHive(type);
      }

      // Retour immédiat du cache via flux
      _controllers[type]!.add(_cache[type]!);

      try {
        final response = await http.post(
          Uri.parse(AppApi.search),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(params),
        );

        if (response.statusCode == 200) {
          final res = json.decode(response.body);
          List<ResultItem> list = [];

          switch (type) {
            case 'produits':
              if (res['data']['produits'] != null) {
                list = (res['data']['produits'] as List)
                    .map((item) => ResultItem(type: 'Produit', data: item))
                    .toList();
              }
              break;
            case 'services':
              if (res['data']['services'] != null) {
                list = (res['data']['services'] as List)
                    .map((item) => ResultItem(type: 'Service', data: item))
                    .toList();
              }
              break;
            case 'entreprises':
              if (res['data']['entreprises'] != null) {
                list = (res['data']['entreprises'] as List)
                    .map((item) => ResultItem(type: 'Entreprise', data: item))
                    .toList();
              }
              break;
          }

          // Mettre à jour cache mémoire et Hive
          _cache[type] = list;
          _saveCacheToHive(type, list);

          // Émettre via le flux
          _controllers[type]!.add(list);
        }
      } catch (e) {
        _controllers[type]!.add(_cache[type]!);
      }
    }

    return []; // Retour vide si erreur ou rien à renvoyer
  }

  // --- Méthodes Hive ---
  Future<void> _loadCacheFromHive(String type) async {
    final boxName = _getBoxName(type);
    final box = await Hive.openBox(boxName);
    final cachedData = box.get('data'); // chaque box stocke juste sa data
    if (cachedData != null) {
      final list = (cachedData as List)
          .map((e) => ResultItem(type: e['type'], data: e['data']))
          .toList();
      _cache[type] = list;
      _controllers[type]?.add(list);
    }
  }

  Future<void> _saveCacheToHive(String type, List<ResultItem> list) async {
    final boxName = _getBoxName(type);
    final box = await Hive.openBox(boxName);
    final dataToSave = list.map((e) => {'type': e.type, 'data': e.data}).toList();
    await box.put('data', dataToSave);
  }

  String _getBoxName(String type) {
    switch (type) {
      case 'produits':
        return 'productsCache';
      case 'services':
        return 'servicesCache';
      case 'entreprises':
        return 'entreprisesCache';
      default:
        return 'defaultCache';
    }
  }
}
