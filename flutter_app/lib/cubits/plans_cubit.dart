import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/plans_repository.dart';
import 'plans_state.dart';

class PlansCubit extends Cubit<PlansState> {
  final PlansRepository repository;

  PlansCubit({required this.repository}) : super(PlansInitial());

  Future<void> loadPlans() async {
    emit(PlansLoading());

    final response = await repository.getPlans();

    if (response.success && response.data != null) {
      emit(PlansLoaded(response.data!));
    } else {
      emit(PlansError(response.error ?? 'Failed to load plans'));
    }
  }

  Future<void> loadPlanById(String planId) async {
    emit(PlansLoading());

    final response = await repository.getPlanById(planId);

    if (response.success && response.data != null) {
      emit(PlanDetailsLoaded(response.data!));
    } else {
      emit(PlansError(response.error ?? 'Failed to load plan details'));
    }
  }

  Future<void> subscribeToPlan(String userId, String planId) async {
    emit(SubscribingToPlan());

    final response = await repository.subscribeToPlan(userId, planId);

    if (response.success) {
      emit(SubscribedToPlan('Successfully subscribed to plan'));
      // Reload current subscription
      await loadCurrentSubscription(userId);
    } else {
      emit(PlansError(response.error ?? 'Failed to subscribe to plan'));
    }
  }

  Future<void> loadCurrentSubscription(String userId) async {
    emit(PlansLoading());

    final response = await repository.getCurrentSubscription(userId);

    if (response.success && response.data != null) {
      emit(CurrentSubscriptionLoaded(response.data!));
    } else {
      emit(PlansError(response.error ?? 'Failed to load current subscription'));
    }
  }

  Future<void> refreshPlans() async {
    await loadPlans();
  }
}
