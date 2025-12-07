import '../services/api_service.dart';
import '../models/demand_model.dart';
import '../models/api_response.dart';

class DemandsRepository {
  final ApiService apiService;

  DemandsRepository({required this.apiService});

  Future<ApiResponse<List<Demand>>> getDemands({
    String? serviceType,
    String? wilaya,
    String? status,
  }) async {
    String endpoint = '/api/sp/demands';
    List<String> queryParams = [];

    if (serviceType != null && serviceType.isNotEmpty) {
      queryParams.add('service_type=$serviceType');
    }
    if (wilaya != null && wilaya.isNotEmpty) {
      queryParams.add('wilaya=$wilaya');
    }
    if (status != null && status.isNotEmpty) {
      queryParams.add('status=$status');
    }

    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }

    final response = await apiService.get(endpoint);

    if (response['success'] == true) {
      final List<dynamic> demandsJson = response['data'] ?? [];
      final demands = demandsJson.map((json) => Demand.fromJson(json)).toList();
      return ApiResponse(success: true, data: demands);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to load demands',
      );
    }
  }

  Future<ApiResponse<Demand>> getDemandById(String demandId) async {
    final response = await apiService.get('/api/sp/demands/$demandId');

    if (response['success'] == true) {
      final demand = Demand.fromJson(response['data']);
      return ApiResponse(success: true, data: demand);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to load demand',
      );
    }
  }

  Future<ApiResponse<void>> submitOffer(
    String demandId,
    String spId,
    Map<String, dynamic> offerData,
  ) async {
    final response = await apiService.post('/api/sp/demands/$demandId/offers', {
      'sp_id': spId,
      ...offerData,
    });

    if (response['success'] == true) {
      return ApiResponse(success: true);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to submit offer',
      );
    }
  }
}
