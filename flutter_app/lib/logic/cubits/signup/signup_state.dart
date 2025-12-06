import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final String role;
  const SignupSuccess(this.role);
  @override
  List<Object> get props => [role];
}

class SignupFailure extends SignupState {
  final String error;
  const SignupFailure(this.error);
  @override
  List<Object> get props => [error];
}
