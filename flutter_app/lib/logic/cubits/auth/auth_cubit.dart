import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final String userId;
  final String accessToken;

  const AuthAuthenticated({
    required this.username,
    required this.role,
    required this.userId,
    required this.accessToken,
  });

  @override
  List<Object> get props => [username, role, userId, accessToken];
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
      if (tokens != null) {
        final profile = await _cacheRepository.getUserProfile(
          userId: tokens.userId,
        );

        emit(
          AuthAuthenticated(
            username: profile?.fullName ?? tokens.userId,
            role: profile?.role ?? tokens.userRole,
            userId: tokens.userId,
            accessToken: tokens.accessToken,
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

      emit(
        AuthAuthenticated(
          username: username,
          role: role,
          userId: userId ?? username,
          accessToken: accessToken,
        ),
      );
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> logout() async {
    await _cacheRepository.clearAuthData();
    emit(AuthUnauthenticated());
  }
}
