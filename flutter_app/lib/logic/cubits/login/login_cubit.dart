import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ra7a/data/local/local_cache_repository.dart';
import 'package:ra7a/data/local/local_models.dart';
import 'package:ra7a/data/remote/auth_api.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required AuthApi authApi,
    required LocalCacheRepository cacheRepository,
  }) : _authApi = authApi,
       _cacheRepository = cacheRepository,
       super(LoginInitial());

  final AuthApi _authApi;
  final LocalCacheRepository _cacheRepository;

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final response = await _authApi.login(email: email, password: password);

      print('Login response: $response');

      final session = response['session'] as Map<String, dynamic>?;
      final user = response['user'] as Map<String, dynamic>?;

      print('Session: $session');
      print('User: $user');

      if (session == null || user == null) {
        throw Exception('Invalid login response: missing session or user data');
      }

      final accessToken = (session['access_token'] as String?) ?? '';
      final refreshToken = (session['refresh_token'] as String?) ?? '';
      final userId = (user['id'] as String?) ?? '';
      final role = (user['role'] as String?) ?? 'homeowner';
      final fullName =
          (user['full_name'] as String?) ?? (user['email'] as String?) ?? email;

      print(
        'Extracted values - userId: $userId, role: $role, fullName: $fullName, accessToken length: ${accessToken.length}',
      );

      final now = DateTime.now().millisecondsSinceEpoch;
      final tokens = AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
        userRole: role,
        updatedAt: now,
      );
      await _cacheRepository.saveAuthTokens(tokens);

      final profile = LocalUserProfile(
        userId: userId,
        fullName: fullName,
        role: role,
        profileImageUrl: null,
        updatedAt: now,
      );
      await _cacheRepository.saveUserProfile(profile);

      // Also save token to SharedPreferences for ApiService
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', accessToken);

      emit(LoginSuccess(username: fullName, role: role));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
