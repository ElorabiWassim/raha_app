import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/reports_repository.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ReportsRepository repository;

  ReportsCubit({required this.repository}) : super(ReportsInitial());

  Future<void> loadReports({String? status}) async {
    emit(ReportsLoading());

    print('Loading reports with filter: $status');
    final response = await repository.getReports(status: status);

    if (response.success && response.data != null) {
      print('Loaded ${response.data!.length} reports with filter: $status');
      emit(ReportsLoaded(response.data!, activeFilter: status));
    } else {
      emit(ReportsError(response.error ?? 'Failed to load reports'));
    }
  }

  Future<void> loadReportById(String reportId) async {
    emit(ReportsLoading());

    final response = await repository.getReportById(reportId);

    if (response.success && response.data != null) {
      emit(ReportDetailsLoaded(response.data!));
    } else {
      emit(ReportsError(response.error ?? 'Failed to load report details'));
    }
  }

  Future<void> updateReportStatus(String reportId, String status) async {
    // Get current active filter before updating
    final currentState = state;
    String? activeFilter;

    if (currentState is ReportsLoaded) {
      activeFilter = currentState.activeFilter;
      print('Current active filter before update: $activeFilter');
      print('Current reports count: ${currentState.reports.length}');
    }

    emit(ReportStatusUpdating());

    final response = await repository.updateReportStatus(reportId, status);

    if (response.success) {
      print('Status update successful. Reloading with filter: $activeFilter');
      emit(ReportStatusUpdated('Report status updated successfully'));
      // Reload reports with the same filter to remove the updated report from current view
      await loadReports(status: activeFilter);
    } else {
      emit(ReportsError(response.error ?? 'Failed to update report status'));
    }
  }

  Future<void> filterReports(String? status) async {
    await loadReports(status: status);
  }

  Future<void> refreshReports() async {
    final currentState = state;
    String? activeFilter;

    if (currentState is ReportsLoaded) {
      activeFilter = currentState.activeFilter;
    }

    await loadReports(status: activeFilter);
  }
}
