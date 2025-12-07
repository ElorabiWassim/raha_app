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

      // Support both snake_case (from DB) and camelCase (from API) keys
      String fullName =
          (user['full_name'] as String?) ??
          (user['fullName'] as String?) ??
          email;
      String emailValue = user['email'] as String? ?? email;
      String? phoneNumber =
          (user['phone_number'] as String?) ?? (user['phoneNumber'] as String?);
      // Prefer home address for homeowners, working for providers; support both key styles
      String? address =
          (user['home_address'] as String?) ??
          (user['homeAddress'] as String?) ??
          (user['working_address'] as String?) ??
          (user['workingAddress'] as String?);

      final now = DateTime.now().millisecondsSinceEpoch;
      final tokens = AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
        userRole: role,
        updatedAt: now,
      );
      await _cacheRepository.saveAuthTokens(tokens);

      // Try to enrich from profile endpoint (includes role-specific fields like home/working address)
      try {
        final profileResponse = await _authApi.getProfile(
          accessToken: accessToken,
        );
        final profileData =
            (profileResponse['profile'] as Map<String, dynamic>?) ?? {};

        fullName =
            (profileData['full_name'] as String?) ??
            (profileData['fullName'] as String?) ??
            fullName;
        emailValue = (profileData['email'] as String?) ?? emailValue;
        phoneNumber =
            (profileData['phone_number'] as String?) ??
            (profileData['phoneNumber'] as String?) ??
            phoneNumber;
        address =
            (profileData['home_address'] as String?) ??
            (profileData['homeAddress'] as String?) ??
            (profileData['working_address'] as String?) ??
            (profileData['workingAddress'] as String?) ??
            address;
      } catch (_) {
        // Ignore profile fetch errors; fall back to login payload
      }

      final profile = LocalUserProfile(
        userId: userId,
        fullName: fullName,
        role: role,
        email: emailValue,
        phoneNumber: phoneNumber,
        address: address,
        profileImageUrl: null,
        updatedAt: now,
      );
      await _cacheRepository.saveUserProfile(profile);

      emit(
        LoginSuccess(
          username: fullName,
          role: role,
          userId: userId,
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
      );
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
