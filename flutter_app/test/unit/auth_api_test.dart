import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:ra7a/data/remote/auth_api.dart';
import '../helpers/fake_http_overrides.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthApi (Unit)', () {
    test('login returns decoded json on 200', () async {
      final api = AuthApi(baseUrl: 'http://localhost:5000');

      final overrides = FakeHttpOverrides(
        routes: {
          RegExp(r'/api/auth/login$'): FakeHttpResponse(
            statusCode: 200,
            body: jsonEncode({
              'session': {'access_token': 't', 'refresh_token': 'r'},
              'user': {'id': 'u1', 'role': 'homeowner', 'full_name': 'X'},
            }),
          ),
        },
      );

      final result = await HttpOverrides.runZoned(
        () => api.login(email: 'a@b.com', password: '123456'),
        createHttpClient: overrides.createHttpClient,
      );

      expect(result['session'], isA<Map<String, dynamic>>());
      expect(result['user'], isA<Map<String, dynamic>>());
    });

    test('login throws formatted validation details when present', () async {
      final api = AuthApi(baseUrl: 'http://localhost:5000');

      final overrides = FakeHttpOverrides(
        routes: {
          RegExp(r'/api/auth/login$'): FakeHttpResponse(
            statusCode: 400,
            body: jsonEncode({
              'error': 'Validation failed',
              'details': [
                {'msg': 'Email is required', 'path': 'email'},
                {'msg': 'Password is required', 'path': 'password'},
              ],
            }),
          ),
        },
      );

      await expectLater(
        () => HttpOverrides.runZoned(
          () => api.login(email: '', password: ''),
          createHttpClient: overrides.createHttpClient,
        ),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('email: Email is required') &&
                e.toString().contains('password: Password is required'),
          ),
        ),
      );
    });

    test('login throws error field when details missing', () async {
      final api = AuthApi(baseUrl: 'http://localhost:5000');

      final overrides = FakeHttpOverrides(
        routes: {
          RegExp(r'/api/auth/login$'): FakeHttpResponse(
            statusCode: 403,
            body: jsonEncode({'error': 'Account not verified'}),
          ),
        },
      );

      await expectLater(
        () => HttpOverrides.runZoned(
          () => api.login(email: 'a@b.com', password: '123456'),
          createHttpClient: overrides.createHttpClient,
        ),
        throwsA(
          predicate(
            (e) =>
                e is Exception && e.toString().contains('Account not verified'),
          ),
        ),
      );
    });
  });
}
