import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

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
    await Future.delayed(const Duration(seconds: 2)); // Simulate API

    // Mock success
    emit(const SignupSuccess('homeowner'));
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
    await Future.delayed(const Duration(seconds: 2)); // Simulate API

    // Mock success
    emit(const SignupSuccess('serviceprovider'));
  }
}
