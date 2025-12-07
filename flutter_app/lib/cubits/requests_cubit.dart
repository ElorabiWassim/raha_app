import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/requests_repository.dart';
import 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  final RequestsRepository repository;

  RequestsCubit({required this.repository}) : super(RequestsInitial());

  Future<void> loadRequests({String? spId, String? status}) async {
    emit(RequestsLoading());

    final response = await repository.getRequests(spId: spId, status: status);

    if (response.success && response.data != null) {
      emit(RequestsLoaded(response.data!, activeFilter: status));
    } else {
      emit(RequestsError(response.error ?? 'Failed to load requests'));
    }
  }

  Future<void> loadRequestById(String requestId) async {
    emit(RequestsLoading());

    final response = await repository.getRequestById(requestId);

    if (response.success && response.data != null) {
      emit(RequestDetailsLoaded(response.data!));
    } else {
      emit(RequestsError(response.error ?? 'Failed to load request details'));
    }
  }

  Future<void> acceptRequest(String requestId) async {
    emit(RequestStatusUpdating());

    final response = await repository.acceptRequest(requestId);

    if (response.success) {
      emit(RequestStatusUpdated('Request accepted successfully'));
      // Reload requests after update
      await _reloadWithCurrentFilter();
    } else {
      emit(RequestsError(response.error ?? 'Failed to accept request'));
    }
  }

  Future<void> rejectRequest(String requestId, String reason) async {
    emit(RequestStatusUpdating());

    final response = await repository.rejectRequest(requestId, reason);

    if (response.success) {
      emit(RequestStatusUpdated('Request rejected'));
      // Reload requests after update
      await _reloadWithCurrentFilter();
    } else {
      emit(RequestsError(response.error ?? 'Failed to reject request'));
    }
  }

  Future<void> completeRequest(String requestId) async {
    emit(RequestStatusUpdating());

    final response = await repository.completeRequest(requestId);

    if (response.success) {
      emit(RequestStatusUpdated('Request marked as completed'));
      // Reload requests after update
      await _reloadWithCurrentFilter();
    } else {
      emit(RequestsError(response.error ?? 'Failed to complete request'));
    }
  }

  Future<void> filterRequests(String? spId, String? status) async {
    await loadRequests(spId: spId, status: status);
  }

  Future<void> refreshRequests({String? spId}) async {
    final currentState = state;
    String? activeFilter;

    if (currentState is RequestsLoaded) {
      activeFilter = currentState.activeFilter;
    }

    await loadRequests(spId: spId, status: activeFilter);
  }

  Future<void> _reloadWithCurrentFilter() async {
    final currentState = state;
    if (currentState is RequestsLoaded) {
      await loadRequests(status: currentState.activeFilter);
    } else {
      await loadRequests();
    }
  }
}
