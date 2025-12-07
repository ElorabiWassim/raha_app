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
    required String phone,
    required String city,
    required String neighborhood,
    String? propertyType,
  }) async {
    emit(SignupLoading());
    try {
      await _authApi.signupHomeowner(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phone,
        homeAddress: '$city, $neighborhood',
        dateOfBirth: DateTime.now().toIso8601String(),
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
    required String phone,
    required String city,
    required String neighborhood,
    required String serviceType,
  }) async {
    emit(SignupLoading());
    try {
      await _authApi.signupProvider(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phone,
        workingAddress: '$city, $neighborhood',
        dateOfBirth: DateTime.now().toIso8601String(),
        // TODO: replace this hardcoded UUID with the real
        // category_id from Supabase once categories are wired.
        serviceType: serviceType,
      );
      emit(const SignupSuccess('serviceprovider'));
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
