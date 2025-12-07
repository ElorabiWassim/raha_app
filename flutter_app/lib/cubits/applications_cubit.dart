import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/applications_repository.dart';
import 'applications_state.dart';

class ApplicationsCubit extends Cubit<ApplicationsState> {
  final ApplicationsRepository repository;

  ApplicationsCubit({required this.repository}) : super(ApplicationsInitial());

  Future<void> loadApplications({String? status, String? search}) async {
    emit(ApplicationsLoading());

    final response = await repository.getApplications(
      status: status,
      search: search,
    );

    if (response.success && response.data != null) {
      emit(ApplicationsLoaded(response.data!));
    } else {
      emit(ApplicationsError(response.error ?? 'Failed to load applications'));
    }
  }

  Future<void> approveApplication(String id) async {
    final response = await repository.approveApplication(id);

    if (response.success) {
      emit(const ApplicationActionSuccess('Application approved'));
      await loadApplications();
    } else {
      emit(ApplicationsError(response.error ?? 'Failed to approve'));
    }
  }

  Future<void> rejectApplication(String id) async {
    final response = await repository.rejectApplication(id);

    if (response.success) {
      emit(const ApplicationActionSuccess('Application rejected'));
      await loadApplications();
    } else {
      emit(ApplicationsError(response.error ?? 'Failed to reject'));
    }
  }
}
