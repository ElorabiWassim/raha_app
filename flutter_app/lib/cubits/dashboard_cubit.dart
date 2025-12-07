import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/dashboard_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository repository;

  DashboardCubit({required this.repository}) : super(DashboardInitial());

  Future<void> loadDashboardStats() async {
    emit(DashboardLoading());

    final response = await repository.getDashboardStats();

    if (response.success && response.data != null) {
      emit(DashboardLoaded(response.data!));
    } else {
      emit(DashboardError(response.error ?? 'Failed to load stats'));
    }
  }

  Future<void> refreshStats() async {
    await loadDashboardStats();
  }
}
