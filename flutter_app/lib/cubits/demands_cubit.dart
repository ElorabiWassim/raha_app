import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/demands_repository.dart';
import 'demands_state.dart';

class DemandsCubit extends Cubit<DemandsState> {
  final DemandsRepository repository;

  DemandsCubit({required this.repository}) : super(DemandsInitial());

  Future<void> loadDemands({
    String? serviceType,
    String? wilaya,
    String? status,
  }) async {
    emit(DemandsLoading());

    final response = await repository.getDemands(
      serviceType: serviceType,
      wilaya: wilaya,
      status: status,
    );

    if (response.success && response.data != null) {
      emit(
        DemandsLoaded(
          response.data!,
          serviceTypeFilter: serviceType,
          wilayaFilter: wilaya,
        ),
      );
    } else {
      emit(DemandsError(response.error ?? 'Failed to load demands'));
    }
  }

  Future<void> loadDemandById(String demandId) async {
    emit(DemandsLoading());

    final response = await repository.getDemandById(demandId);

    if (response.success && response.data != null) {
      emit(DemandDetailsLoaded(response.data!));
    } else {
      emit(DemandsError(response.error ?? 'Failed to load demand details'));
    }
  }

  Future<void> submitOffer(
    String demandId,
    String spId,
    Map<String, dynamic> offerData,
  ) async {
    emit(SubmittingOffer());

    final response = await repository.submitOffer(demandId, spId, offerData);

    if (response.success) {
      emit(OfferSubmitted('Offer submitted successfully'));
      // Reload demands after submitting offer
      await _reloadWithCurrentFilters();
    } else {
      emit(DemandsError(response.error ?? 'Failed to submit offer'));
    }
  }

  Future<void> filterDemands({String? serviceType, String? wilaya}) async {
    await loadDemands(serviceType: serviceType, wilaya: wilaya);
  }

  Future<void> refreshDemands() async {
    final currentState = state;
    String? serviceTypeFilter;
    String? wilayaFilter;

    if (currentState is DemandsLoaded) {
      serviceTypeFilter = currentState.serviceTypeFilter;
      wilayaFilter = currentState.wilayaFilter;
    }

    await loadDemands(serviceType: serviceTypeFilter, wilaya: wilayaFilter);
  }

  Future<void> _reloadWithCurrentFilters() async {
    final currentState = state;
    if (currentState is DemandsLoaded) {
      await loadDemands(
        serviceType: currentState.serviceTypeFilter,
        wilaya: currentState.wilayaFilter,
      );
    } else {
      await loadDemands();
    }
  }
}
