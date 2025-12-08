import '../services/api_service.dart';
import '../models/api_response.dart';

class OffersRepository {
  final ApiService apiService;

  OffersRepository({required this.apiService});

  Future<ApiResponse<String>> sendOffer({
    required String demandId,
    required String message,
    required double proposedPrice,
    required String proposedDate,
  }) async {
    try {
      final response = await apiService.sendOffer(
        demandId: demandId,
        message: message,
        proposedPrice: proposedPrice,
        proposedDate: proposedDate,
      );

      if (response['message'] != null) {
        return ApiResponse(success: true, data: response['message']);
      } else {
        return ApiResponse(success: false, error: 'Failed to send offer');
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getMyOffers() async {
    try {
      final response = await apiService.get('/api/sp/offers/my');

      if (response['success'] == true) {
        final List<dynamic> offersJson = response['data'] ?? [];
        final offers = offersJson.cast<Map<String, dynamic>>();
        return ApiResponse(success: true, data: offers);
      } else {
        return ApiResponse(
          success: false,
          error: response['error'] ?? 'Failed to load offers',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}
