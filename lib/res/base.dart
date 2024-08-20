import '../utils/config.dart';

class BasePaths {
  const BasePaths._();

  static const baseImagePath = "assets/images";
  static const baseAnimationPath = "assets/animations";
  static const baseIconPath = "assets/icons";
  static const basePlaceholderPath = "assets/placeholders";
  static const baseProdUrl = "http://3.143.226.11";
  static const baseTestUrl = "http://3.143.226.11";
  static const baseUrl = AppConfig.devMode ? baseTestUrl : baseProdUrl;
}
