import 'package:hive/hive.dart';

class CacheService {
  final Box box = Hive.box('cacheBox');

  void save(String key, List<dynamic> data) {
    box.put(key, data);
  }

  List<dynamic>? get(String key) {
    return box.get(key)?.cast<dynamic>();
  }
}
