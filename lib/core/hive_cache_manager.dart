import 'package:hive/hive.dart';
import 'package:http/http.dart';

import '../data/model/cached_data_model.dart';

class HiveCache {
  final Box _cacheBox = Hive.box('cacheBox');

  CachedData? get(String key) {
    return _cacheBox.get(key);
  }

  void set(String key, Response response) {
    final eTag = response.headers['etag'];
    final lastModified = response.headers['last-modified'];
    _cacheBox.put(
        key,
        CachedData(
          body: response.body,
          statusCode: response.statusCode,
          eTag: eTag,
          lastModified: lastModified,
        ));
  }

  void clear() => _cacheBox.clear();
}
