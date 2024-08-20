import 'package:hive/hive.dart';
import 'package:http/http.dart';

part 'cached_data_model.g.dart';

@HiveType(typeId: 1)
class CachedData {
  @HiveField(0)
  final String body;
  @HiveField(1)
  final int statusCode;
  @HiveField(2)
  final String? eTag;
  @HiveField(3)
  final String? lastModified;

  CachedData({
    required this.body,
    required this.statusCode,
    this.eTag,
    this.lastModified,
  });

  Response toHttpResponse() {
    return Response(body, statusCode);
  }
}
