import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ra7a/data/remote/auth_api.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({required AuthApi authApi})
    : _authApi = authApi,
      super(SignupInitial());

  final AuthApi _authApi;

  Future<void> signupHomeowner({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String homeAddress,
    required DateTime dateOfBirth,
  }) async {
    emit(SignupLoading());
    try {
      await _authApi.signupHomeowner(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        homeAddress: homeAddress,
        dateOfBirth: dateOfBirth.toIso8601String(),
      );
      emit(const SignupSuccess('homeowner'));
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }

  Future<void> signupProvider({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String workingAddress,
    required DateTime dateOfBirth,
    required String serviceType,
  }) async {
    emit(SignupLoading());
    try {
      await _authApi.signupProvider(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        workingAddress: workingAddress,
        dateOfBirth: dateOfBirth.toIso8601String(),
        serviceType: serviceType,
      );
      emit(const SignupSuccess('service_provider'));
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
