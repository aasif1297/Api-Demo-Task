import '../utils/config.dart';

class BasePaths {
  const BasePaths._();

  static const baseProdUrl = "https://dummyjson.com";
  static const baseTestUrl = "https://dummyjson.com";
  static const baseUrl = AppConfig.devMode ? baseTestUrl : baseProdUrl;
}
