import '../../services/api_service.dart';
import '../models/sp_request_model.dart';
import '../models/api_response.dart';

class RequestsRepository {
  final ApiService apiService;

  RequestsRepository({required this.apiService});

  Future<ApiResponse<List<SPRequest>>> getRequests({
    String? spId,
    String? status,
  }) async {
    String endpoint = '/api/sp/requests';
    List<String> queryParams = [];

    if (spId != null && spId.isNotEmpty) {
      queryParams.add('sp_id=$spId');
    }
    if (status != null && status.isNotEmpty) {
      queryParams.add('status=$status');
    }

    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }

    final response = await apiService.get(endpoint);

    if (response['success'] == true) {
      final List<dynamic> requestsJson = response['data'] ?? [];
      final requests = requestsJson
          .map((json) => SPRequest.fromJson(json))
          .toList();
      return ApiResponse(success: true, data: requests);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to load requests',
      );
    }
  }

  Future<ApiResponse<SPRequest>> getRequestById(String requestId) async {
    final response = await apiService.get('/api/sp/requests/$requestId');

    if (response['success'] == true) {
      final request = SPRequest.fromJson(response['data']);
      return ApiResponse(success: true, data: request);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to load request',
      );
    }
  }

  Future<ApiResponse<void>> updateRequestStatus(
    String requestId,
    String status, {
    String? notes,
  }) async {
    final response = await apiService.put(
      '/api/sp/requests/$requestId/status',
      {'status': status, if (notes != null) 'notes': notes},
    );

    if (response['success'] == true) {
      return ApiResponse(success: true);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to update request status',
      );
    }
  }

  Future<ApiResponse<void>> acceptRequest(String requestId) async {
    return updateRequestStatus(requestId, 'accepted');
  }

  Future<ApiResponse<void>> rejectRequest(
    String requestId,
    String reason,
  ) async {
    return updateRequestStatus(requestId, 'rejected', notes: reason);
  }

  Future<ApiResponse<void>> completeRequest(String requestId) async {
    return updateRequestStatus(requestId, 'completed');
  }
}
