import '../services/api_service.dart';
import '../models/subscription_plan.dart';
import '../models/api_response.dart';

class PlansRepository {
  final ApiService apiService;

  PlansRepository({required this.apiService});

  Future<ApiResponse<List<SubscriptionPlan>>> getPlans() async {
    final response = await apiService.get('/api/sp/plans');

    if (response['success'] == true) {
      final List<dynamic> plansJson = response['data'] ?? [];
      final plans = plansJson
          .map((json) => SubscriptionPlan.fromJson(json))
          .toList();
      return ApiResponse(success: true, data: plans);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to load plans',
      );
    }
  }

  Future<ApiResponse<SubscriptionPlan>> getPlanById(String planId) async {
    final response = await apiService.get('/api/sp/plans/$planId');

    if (response['success'] == true) {
      final plan = SubscriptionPlan.fromJson(response['data']);
      return ApiResponse(success: true, data: plan);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to load plan',
      );
    }
  }

  Future<ApiResponse<void>> subscribeToPlan(
    String userId,
    String planId,
  ) async {
    final response = await apiService.post('/api/sp/subscribe', {
      'user_id': userId,
      'plan_id': planId,
    });

    if (response['success'] == true) {
      return ApiResponse(success: true, data: response['data']);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to subscribe to plan',
      );
    }
  }

  Future<ApiResponse<SubscriptionPlan>> getCurrentSubscription(
    String userId,
  ) async {
    final response = await apiService.get('/api/sp/subscription/$userId');

    if (response['success'] == true) {
      final plan = SubscriptionPlan.fromJson(response['data']);
      return ApiResponse(success: true, data: plan);
    } else {
      return ApiResponse(
        success: false,
        error: response['error'] ?? 'Failed to load subscription',
      );
    }
  }
}
