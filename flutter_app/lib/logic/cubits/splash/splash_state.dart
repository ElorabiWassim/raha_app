import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashNavigateToOnboarding extends SplashState {}

class SplashNavigateToLogin extends SplashState {}

class SplashNavigateToHome extends SplashState {
  final String role;
  const SplashNavigateToHome(this.role);

  @override
  List<Object> get props => [role];
}

class SplashError extends SplashState {
  final String message;
  const SplashError(this.message);

  @override
  List<Object> get props => [message];
}
