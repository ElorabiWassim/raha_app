import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String username;
  final String role;
  final String userId;
  final String accessToken;
  final String refreshToken;

  const LoginSuccess({
    required this.username,
    required this.role,
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object> get props => [username, role, userId, accessToken, refreshToken];
}

class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);

  @override
  List<Object> get props => [message];
}
