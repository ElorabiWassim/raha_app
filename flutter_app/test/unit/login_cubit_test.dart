import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ra7a/data/local/local_cache_repository.dart';
import 'package:ra7a/data/remote/auth_api.dart';
import 'package:ra7a/logic/cubits/login/login_cubit.dart';
import 'package:ra7a/logic/cubits/login/login_state.dart';

class _MockAuthApi extends Mock implements AuthApi {}

class _MockLocalCacheRepository extends Mock implements LocalCacheRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('LoginCubit (Unit)', () {
    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginSuccess] and saves jwt_token on success',
      build: () {
        final authApi = _MockAuthApi();
        final cache = _MockLocalCacheRepository();

        when(
          () => authApi.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {
          return {
            'session': {
              'access_token': 'jwt_123',
              'refresh_token': 'refresh_123',
            },
            'user': {
              'id': 'user_1',
              'role': 'homeowner',
              'full_name': 'Test User',
              'email': 'test@example.com',
            },
          };
        });

        when(() => cache.saveAuthTokens(any())).thenAnswer((_) async {});
        when(() => cache.saveUserProfile(any())).thenAnswer((_) async {});

        return LoginCubit(authApi: authApi, cacheRepository: cache);
      },
      act: (cubit) async {
        await cubit.login('test@example.com', 'password123');
      },
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginSuccess>()
            .having((s) => s.username, 'username', 'Test User')
            .having((s) => s.role, 'role', 'homeowner'),
      ],
      verify: (_) async {
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('jwt_token'), 'jwt_123');
      },
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginFailure] when API throws',
      build: () {
        final authApi = _MockAuthApi();
        final cache = _MockLocalCacheRepository();

        when(
          () => authApi.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('Login failed'));

        return LoginCubit(authApi: authApi, cacheRepository: cache);
      },
      act: (cubit) async {
        await cubit.login('test@example.com', 'wrong');
      },
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginFailure>().having(
          (s) => s.message,
          'message',
          contains('Login failed'),
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginFailure] when response is missing session/user',
      build: () {
        final authApi = _MockAuthApi();
        final cache = _MockLocalCacheRepository();

        when(
          () => authApi.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => <String, dynamic>{});

        return LoginCubit(authApi: authApi, cacheRepository: cache);
      },
      act: (cubit) async {
        await cubit.login('test@example.com', 'password123');
      },
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginFailure>().having(
          (s) => s.message,
          'message',
          contains('Invalid login response'),
        ),
      ],
    );
  });
}
