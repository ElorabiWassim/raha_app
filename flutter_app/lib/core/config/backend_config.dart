import 'package:flutter/foundation.dart' show kIsWeb;

class BackendConfig {
  static const String baseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: kIsWeb ? 'http://localhost:5000' : 'http://10.0.2.2:5000',
  );
}
