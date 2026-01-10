import 'package:flutter/foundation.dart' show kIsWeb;

class BackendConfig {
  static const String baseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: kIsWeb
        ? 'http://10.242.249.27:5000'
        : 'http://10.242.249.27:5000',
  );
}
