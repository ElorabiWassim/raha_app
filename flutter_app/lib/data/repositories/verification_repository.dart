import '../services/api_service.dart';
import '../models/verification_document.dart';
import '../models/api_response.dart';

class VerificationRepository {
  final ApiService apiService;

  VerificationRepository({required this.apiService});

  Future<ApiResponse<void>> submitVerification(
    VerificationData verificationData,
  ) async {
    final response = await apiService.post(
      '/api/admin/applications',
      verificationData.toJson(),
    );

    if (response['success'] == true) {
      return ApiResponse(success: true, data: response['data']);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to submit verification',
      );
    }
  }

  Future<ApiResponse<String>> uploadDocument(
    String documentType,
    String filePath,
  ) async {
    // This would typically use multipart/form-data
    // For now, we'll simulate with a simple API call
    final response = await apiService.post('/api/sp/upload-document', {
      'document_type': documentType,
      'file_path': filePath,
    });

    if (response['success'] == true) {
      final documentUrl = response['data']['document_url'] ?? '';
      return ApiResponse(success: true, data: documentUrl);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to upload document',
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getVerificationStatus(
    String userId,
  ) async {
    final response = await apiService.get(
      '/api/sp/verification-status/$userId',
    );

    if (response['success'] == true) {
      return ApiResponse(success: true, data: response['data']);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to get verification status',
      );
    }
  }
}
