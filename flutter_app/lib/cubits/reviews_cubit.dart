import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/reviews_repository.dart';
import '../data/models/review_model.dart';
import 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsRepository repository;

  ReviewsCubit({required this.repository}) : super(ReviewsInitial());

  Future<void> loadReviews({String? spId, String? homeownerId}) async {
    emit(ReviewsLoading());

    final response = await repository.getReviews(
      spId: spId,
      homeownerId: homeownerId,
    );

    if (response.success && response.data != null) {
      double? averageRating;

      // If loading reviews for a specific SP, get average rating
      if (spId != null) {
        final ratingResponse = await repository.getAverageRating(spId);
        if (ratingResponse.success && ratingResponse.data != null) {
          averageRating = ratingResponse.data;
        }
      }

      emit(ReviewsLoaded(response.data!, averageRating: averageRating));
    } else {
      emit(ReviewsError(response.error ?? 'Failed to load reviews'));
    }
  }

  Future<void> submitReview(Review review) async {
    emit(SubmittingReview());

    final response = await repository.submitReview(review);

    if (response.success) {
      emit(ReviewSubmitted('Review submitted successfully'));
      // Reload reviews for the service provider
      await loadReviews(spId: review.spId);
    } else {
      emit(ReviewsError(response.error ?? 'Failed to submit review'));
    }
  }

  Future<void> loadReviewsForSP(String spId) async {
    await loadReviews(spId: spId);
  }

  Future<void> loadReviewsByHomeowner(String homeownerId) async {
    await loadReviews(homeownerId: homeownerId);
  }

  Future<void> refreshReviews({String? spId, String? homeownerId}) async {
    await loadReviews(spId: spId, homeownerId: homeownerId);
  }
}
