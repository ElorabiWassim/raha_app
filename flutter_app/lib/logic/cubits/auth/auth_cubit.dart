import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ra7a/data/local/local_cache_repository.dart';
import 'package:ra7a/data/local/local_models.dart';

// State
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String username;
  final String role; // 'homeowner', 'serviceprovider', 'admin'
  const AuthAuthenticated(this.username, this.role);
  @override
  List<Object> get props => [username, role];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object> get props => [message];
}

// Cubit
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required LocalCacheRepository cacheRepository})
    : _cacheRepository = cacheRepository,
      super(AuthInitial());

  final LocalCacheRepository _cacheRepository;

  Future<void> restoreSession() async {
    emit(AuthLoading());
    try {
      final tokens = await _cacheRepository.getAuthTokens();
      final profile = await _cacheRepository.getUserProfile();

      if (tokens != null) {
        emit(
          AuthAuthenticated(
            profile?.fullName ?? tokens.userId,
            profile?.role ?? tokens.userRole,
          ),
        );
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> authenticate({
    required String username,
    required String role,
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? profileImageUrl,
  }) async {
    emit(AuthLoading());
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final tokens = AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId ?? username,
        userRole: role,
        updatedAt: now,
      );
      await _cacheRepository.saveAuthTokens(tokens);

      final profile = LocalUserProfile(
        userId: userId ?? username,
        fullName: username,
        role: role,
        profileImageUrl: profileImageUrl,
        updatedAt: now,
      );
      await _cacheRepository.saveUserProfile(profile);

      // Also save token to SharedPreferences for ApiService
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', accessToken);

      emit(AuthAuthenticated(username, role));
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> logout() async {
    await _cacheRepository.clearAuthData();

    // Also clear token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');

    emit(AuthUnauthenticated());
  }
}
