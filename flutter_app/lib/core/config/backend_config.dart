import 'package:flutter/foundation.dart' show kIsWeb;

class BackendConfig {
  static const String baseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: kIsWeb
        ? 'http://172.20.10.2:5000'
        : 'http://172.20.10.2:5000',
  );
}
