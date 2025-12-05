import 'package:flutter_bloc/flutter_bloc.dart';
import 'rate_state.dart';

class RateCubit extends Cubit<RateState> {
  RateCubit() : super(RateInitial());

  Future<void> submitRating({
    required String bookingId,
    required int rating,
    required String feedback,
  }) async {
    emit(RateSubmitting());
    await Future.delayed(const Duration(seconds: 2)); // Simulate API

    // Mock success
    emit(RateSuccess());
  }

  Future<void> submitReport({
    required String bookingId,
    required String reason,
  }) async {
    emit(RateSubmitting());
    await Future.delayed(const Duration(seconds: 2)); // Simulate API

    // Mock success
    emit(RateSuccess());
  }
}
