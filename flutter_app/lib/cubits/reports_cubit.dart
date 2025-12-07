import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/reports_repository.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ReportsRepository repository;

  ReportsCubit({required this.repository}) : super(ReportsInitial());

  Future<void> loadReports({String? status}) async {
    emit(ReportsLoading());

    final response = await repository.getReports(status: status);

    if (response.success && response.data != null) {
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
    emit(ReportStatusUpdating());

    final response = await repository.updateReportStatus(reportId, status);

    if (response.success) {
      emit(ReportStatusUpdated('Report status updated successfully'));
      // Reload reports after update
      await loadReports();
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
