import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/demands_repository.dart';
import 'demand_details_state.dart';

class DemandDetailsCubit extends Cubit<DemandDetailsState> {
  final DemandsRepository repository;

  DemandDetailsCubit({required this.repository})
    : super(DemandDetailsInitial());

  Future<void> loadDemandDetails(String demandId) async {
    emit(DemandDetailsLoading());

    try {
      final response = await repository.getDemandById(demandId);

      if (response.success && response.data != null) {
        // Convert Demand model to Map for easier access
        final demandMap = response.data!.toJson();
        // Add additional fields from backend response if available
        emit(DemandDetailsLoaded(demandMap));
      } else {
        emit(
          DemandDetailsError(response.error ?? 'Failed to load demand details'),
        );
      }
    } catch (e) {
      emit(DemandDetailsError('An error occurred: $e'));
    }
  }
}
