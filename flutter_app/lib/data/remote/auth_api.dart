import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthApi {
  AuthApi({required this.baseUrl});

  final String baseUrl;

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<Map<String, dynamic>> signupHomeowner({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String homeAddress,
    required String dateOfBirth,
  }) async {
    final response = await http.post(
      _uri('/api/auth/signup/homeowner'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'homeAddress': homeAddress,
        'dateOfBirth': dateOfBirth,
      }),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> signupProvider({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String workingAddress,
    required String dateOfBirth,
    required String serviceType,
  }) async {
    final response = await http.post(
      _uri('/api/auth/signup/provider'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'workingAddress': workingAddress,
        'dateOfBirth': dateOfBirth,
        'serviceType': serviceType,
        'experienceYears': 0,
        'description': '',
        'documentsUrls': <String, dynamic>{},
      }),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      _uri('/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> requestPasswordReset({
    required String email,
  }) async {
    final response = await http.post(
      _uri('/api/auth/password-reset/request'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final response = await http.post(
      _uri('/api/auth/password-reset/confirm'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'new_password': newPassword}),
    );
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final dynamic decoded = jsonDecode(response.body);
    if (statusCode >= 200 && statusCode < 300) {
      return decoded as Map<String, dynamic>;
    }
    if (decoded is Map<String, dynamic>) {
      final error = decoded['error']?.toString();
      final details = decoded['details'];
      if (details is List && details.isNotEmpty) {
        final messages = details
            .map((e) {
              if (e is Map<String, dynamic>) {
                final msg = e['msg']?.toString();
                final field = (e['path'] ?? e['param'])?.toString();
                if (msg != null && msg.isNotEmpty) {
                  return field != null && field.isNotEmpty
                      ? '$field: $msg'
                      : msg;
                }
              }
              return e.toString();
            })
            .where((m) => m.trim().isNotEmpty)
            .toList();
        if (messages.isNotEmpty) {
          throw Exception(messages.join('\n'));
        }
      }

      if (error != null && error.isNotEmpty) {
        throw Exception(error);
      }
    }
    throw Exception('Request failed with status $statusCode');
  }
}
