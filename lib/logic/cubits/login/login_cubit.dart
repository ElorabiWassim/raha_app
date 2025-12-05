import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(String username, String password) async {
    emit(LoginLoading());
    await Future.delayed(const Duration(seconds: 1)); // Simulate API

    final lowerUser = username.toLowerCase().trim();
    if (lowerUser == 'homeowner' ||
        lowerUser == 'serviceprovider' ||
        lowerUser == 'admin') {
      emit(LoginSuccess(username: username, role: lowerUser));
    } else {
      // For demo purposes, treat any other user as homeowner if not empty
      if (username.isNotEmpty && password.isNotEmpty) {
        emit(LoginSuccess(username: username, role: 'homeowner'));
      } else {
        emit(const LoginFailure("Invalid credentials"));
      }
    }
  }
}
