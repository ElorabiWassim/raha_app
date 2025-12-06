import 'package:flutter_bloc/flutter_bloc.dart';

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

      final session = response['session'] as Map<String, dynamic>;
      final user = response['user'] as Map<String, dynamic>;

      final accessToken = session['access_token'] as String? ?? '';
      final refreshToken = session['refresh_token'] as String? ?? '';
      final userId = user['id'] as String? ?? '';
      final role = (user['role'] as String? ?? 'homeowner');
      final fullName = user['full_name'] as String? ?? email;

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

      emit(LoginSuccess(username: fullName, role: role));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
