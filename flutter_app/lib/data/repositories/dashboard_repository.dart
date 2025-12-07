import '../services/api_service.dart';
import '../models/dashboard_stats.dart';
import '../models/api_response.dart';

class DashboardRepository {
  final ApiService apiService;

  DashboardRepository({required this.apiService});

  Future<ApiResponse<DashboardStats>> getDashboardStats() async {
    final response = await apiService.get('/api/admin/stats');

    if (response['success'] == true) {
      final stats = DashboardStats.fromJson(response['data']);
      return ApiResponse(success: true, data: stats);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to load stats',
      );
    }
  }
}
