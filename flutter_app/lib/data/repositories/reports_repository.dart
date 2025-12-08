import '../../services/api_service.dart';
import '../models/report.dart';
import '../models/api_response.dart';

class ReportsRepository {
  final ApiService apiService;

  ReportsRepository({required this.apiService});

  Future<ApiResponse<List<Report>>> getReports({String? status}) async {
    String endpoint = '/api/admin/reports';
    if (status != null && status.isNotEmpty) {
      endpoint += '?status=$status';
    }

    final response = await apiService.get(endpoint);

    if (response['success'] == true) {
      final List<dynamic> reportsJson = response['data'] ?? [];
      final reports = reportsJson.map((json) => Report.fromJson(json)).toList();
      return ApiResponse(success: true, data: reports);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to load reports',
      );
    }
  }

  Future<ApiResponse<Report>> getReportById(String reportId) async {
    final response = await apiService.get('/api/admin/reports/$reportId');

    if (response['success'] == true) {
      final report = Report.fromJson(response['data']);
      return ApiResponse(success: true, data: report);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to load report',
      );
    }
  }

  Future<ApiResponse<void>> updateReportStatus(
    String reportId,
    String status,
  ) async {
    final response = await apiService.put(
      '/api/admin/reports/$reportId/status',
      {'status': status},
    );

    if (response['success'] == true) {
      return ApiResponse(success: true);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to update report status',
      );
    }
  }
}
