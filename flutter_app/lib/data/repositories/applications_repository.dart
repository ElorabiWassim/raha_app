import '../../services/api_service.dart';
import '../models/provider_application.dart';
import '../models/api_response.dart';

class ApplicationsRepository {
  final ApiService apiService;

  ApplicationsRepository({required this.apiService});

  Future<ApiResponse<List<ProviderApplication>>> getApplications({
    String? status,
    String? search,
  }) async {
    String endpoint = '/api/admin/applications?';
    if (status != null) endpoint += 'status=$status&';
    if (search != null) endpoint += 'search=$search';

    final response = await apiService.get(endpoint);

    if (response['success'] == true) {
      final List<ProviderApplication> applications = (response['data'] as List)
          .map((e) => ProviderApplication.fromJson(e))
          .toList();

      return ApiResponse(success: true, data: applications);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to load applications',
      );
    }
  }

  Future<ApiResponse<void>> approveApplication(String id) async {
    final response = await apiService.put(
      '/api/admin/applications/$id/approve',
      {},
    );

    return ApiResponse(
      success: response['success'] ?? false,
      error: response['error'],
    );
  }

  Future<ApiResponse<void>> rejectApplication(String id) async {
    final response = await apiService.put(
      '/api/admin/applications/$id/reject',
      {},
    );

    return ApiResponse(
      success: response['success'] ?? false,
      error: response['error'],
    );
  }
}
