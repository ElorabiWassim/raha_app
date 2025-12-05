import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  AuthCubit() : super(AuthInitial());

  void authenticate(String username, String role) {
    emit(AuthAuthenticated(username, role));
  }

  void logout() {
    emit(AuthUnauthenticated());
  }
}
