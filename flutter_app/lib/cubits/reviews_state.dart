import 'package:equatable/equatable.dart';
import '../data/models/review_model.dart';

abstract class ReviewsState extends Equatable {
  const ReviewsState();

  @override
  List<Object?> get props => [];
}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final List<Review> reviews;
  final double? averageRating;

  const ReviewsLoaded(this.reviews, {this.averageRating});

  @override
  List<Object?> get props => [reviews, averageRating];
}

class SubmittingReview extends ReviewsState {}

class ReviewSubmitted extends ReviewsState {
  final String message;

  const ReviewSubmitted(this.message);

  @override
  List<Object?> get props => [message];
}

class ReviewsError extends ReviewsState {
  final String message;

  const ReviewsError(this.message);

  @override
  List<Object?> get props => [message];
}
