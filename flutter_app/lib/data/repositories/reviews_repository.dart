import '../services/api_service.dart';
import '../models/review_model.dart';
import '../models/api_response.dart';

class ReviewsRepository {
  final ApiService apiService;

  ReviewsRepository({required this.apiService});

  Future<ApiResponse<List<Review>>> getReviews({
    String? spId,
    String? homeownerId,
  }) async {
    String endpoint = '/api/reviews';
    List<String> queryParams = [];

    if (spId != null && spId.isNotEmpty) {
      queryParams.add('sp_id=$spId');
    }
    if (homeownerId != null && homeownerId.isNotEmpty) {
      queryParams.add('homeowner_id=$homeownerId');
    }

    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }

    final response = await apiService.get(endpoint);

    if (response['success'] == true) {
      final List<dynamic> reviewsJson = response['data'] ?? [];
      final reviews = reviewsJson.map((json) => Review.fromJson(json)).toList();
      return ApiResponse(success: true, data: reviews);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to load reviews',
      );
    }
  }

  Future<ApiResponse<void>> submitReview(Review review) async {
    final response = await apiService.post('/api/reviews', review.toJson());

    if (response['success'] == true) {
      return ApiResponse(success: true, data: response['data']);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to submit review',
      );
    }
  }

  Future<ApiResponse<double>> getAverageRating(String spId) async {
    final response = await apiService.get('/api/reviews/average/$spId');

    if (response['success'] == true) {
      final rating = (response['data']['average_rating'] ?? 0).toDouble();
      return ApiResponse(success: true, data: rating);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to get average rating',
      );
    }
  }
}
