import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/offers_repository.dart';
import 'send_offer_state.dart';

class SendOfferCubit extends Cubit<SendOfferState> {
  final OffersRepository repository;

  SendOfferCubit({required this.repository}) : super(SendOfferInitial());

  Future<void> sendOffer({
    required String demandId,
    required String message,
    required double proposedPrice,
    required String proposedDate,
  }) async {
    emit(SendOfferLoading());

    try {
      final response = await repository.sendOffer(
        demandId: demandId,
        message: message,
        proposedPrice: proposedPrice,
        proposedDate: proposedDate,
      );

      if (response.success) {
        emit(SendOfferSuccess(response.data ?? 'Offer sent successfully'));
      } else {
        emit(SendOfferError(response.error ?? 'Failed to send offer'));
      }
    } catch (e) {
      emit(SendOfferError('An error occurred: $e'));
    }
  }
}
