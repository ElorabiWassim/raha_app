import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;
  final http.Client client;

  ApiService({this.baseUrl = 'http://localhost:3000', http.Client? client})
    : client = client ?? http.Client();

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonResponse;
    } else {
      return {
        'success': false,
        'error': jsonResponse['error'] ?? 'Unknown error',
      };
    }
  }
}
