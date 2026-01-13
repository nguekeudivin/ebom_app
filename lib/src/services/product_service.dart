import 'dart:async';
import 'dart:convert';
import 'package:ebom/src/config/app_api.dart';
import 'package:http/http.dart' as http;
import 'cache_service.dart';

class ProductService {
  final String baseUrl;
  final CacheService cacheService = CacheService();

  ProductService({this.baseUrl = AppApi.data});

  // 🔹 Stream pour notifier l'UI
  final StreamController<List<dynamic>> _streamController = StreamController.broadcast();
  Stream<List<dynamic>> get cacheStream => _streamController.stream;

  void _notifyCache(List<dynamic> data) {
    _streamController.add(data);
  }

  // 🔹 Fonction pour comparer deux listes
  bool _listEquals(List<dynamic>? a, List<dynamic>? b) {
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (jsonEncode(a[i]) != jsonEncode(b[i])) return false;
    }
    return true;
  }

  // 🔹 Tous les produits
  Future<List<dynamic>> items() async {
    final cacheKey = 'items';
    final cached = cacheService.get(cacheKey);
    if (cached != null) _notifyCache(cached);

    try {
      final response = await http.get(Uri.parse('$baseUrl/produits'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (!_listEquals(cached, data)) {
          cacheService.save(cacheKey, data);
          _notifyCache(data);
        }
        return data;
      }
    } catch (e) {
      return cached ?? [];
    }

    return cached ?? [];
  }

  // 🔹 Produits dynamiques
  Future<List<dynamic>> dynamicItems(String apiUri) async {
    final cacheKey = 'dynamic_$apiUri';
    final cached = cacheService.get(cacheKey);
    if (cached != null) _notifyCache(cached);

    try {
      final response = await http.get(Uri.parse('$baseUrl/$apiUri'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (!_listEquals(cached, data)) {
          cacheService.save(cacheKey, data);
          _notifyCache(data);
        }
        return data;
      }
    } catch (e) {
      return cached ?? [];
    }

    return cached ?? [];
  }

  // 🔹 Recherche par mot clé
  Future<List<dynamic>> search(String keyword) async {
    final cacheKey = 'search_$keyword';
    final cached = cacheService.get(cacheKey);
    if (cached != null) _notifyCache(cached);

    try {
      final response = await http.post(
        Uri.parse(AppApi.search),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'search': keyword}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']['produits'];
        if (!_listEquals(cached, data)) {
          cacheService.save(cacheKey, data);
          _notifyCache(data);
        }
        return data;
      }
    } catch (e) {
      return cached ?? [];
    }

    return cached ?? [];
  }

  // 🔹 Recherche par catégorie
  Future<List<dynamic>> searchByCategory(int id) async {
    final cacheKey = 'category_$id';
    final cached = cacheService.get(cacheKey);
    if (cached != null) _notifyCache(cached);

    try {
      final response = await http.get(Uri.parse('$baseUrl/produits/categorie/$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (!_listEquals(cached, data)) {
          cacheService.save(cacheKey, data);
          _notifyCache(data);
        }
        return data;
      }
    } catch (e) {
      return cached ?? [];
    }

    return cached ?? [];
  }
}
