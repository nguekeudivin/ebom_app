import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  Future<void> saveToCache(String key, dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data);
    await prefs.setString(key, jsonString);
  }

  dynamic getFromCache(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }

  Future<void> clearCache(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
