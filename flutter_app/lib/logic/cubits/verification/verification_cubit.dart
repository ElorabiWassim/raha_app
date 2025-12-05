import 'package:flutter_bloc/flutter_bloc.dart';
import 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  VerificationCubit() : super(const VerificationInitial());

  void uploadId() {
    if (state is VerificationInitial) {
      final currentState = state as VerificationInitial;
      emit(currentState.copyWith(idUploaded: !currentState.idUploaded));
    }
  }

  void uploadCert() {
    if (state is VerificationInitial) {
      final currentState = state as VerificationInitial;
      emit(currentState.copyWith(certUploaded: !currentState.certUploaded));
    }
  }

  void uploadPhoto() {
    if (state is VerificationInitial) {
      final currentState = state as VerificationInitial;
      emit(currentState.copyWith(photoUploaded: !currentState.photoUploaded));
    }
  }

  Future<void> submit() async {
    if (state is VerificationInitial) {
      final currentState = state as VerificationInitial;
      if (currentState.idUploaded &&
          currentState.certUploaded &&
          currentState.photoUploaded) {
        emit(VerificationSubmitting());
        await Future.delayed(const Duration(seconds: 2)); // Simulate API
        emit(VerificationSuccess());
      } else {
        emit(
          const VerificationFailure("Please upload all required documents."),
        );
        // Revert to initial state to allow retry/editing
        emit(currentState);
      }
    }
  }

  void reset() {
    emit(const VerificationInitial());
  }
}
