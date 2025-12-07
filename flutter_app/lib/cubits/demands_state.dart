import 'package:equatable/equatable.dart';
import '../data/models/demand_model.dart';

abstract class DemandsState extends Equatable {
  const DemandsState();

  @override
  List<Object?> get props => [];
}

class DemandsInitial extends DemandsState {}

class DemandsLoading extends DemandsState {}

class DemandsLoaded extends DemandsState {
  final List<Demand> demands;
  final String? serviceTypeFilter;
  final String? wilayaFilter;

  const DemandsLoaded(
    this.demands, {
    this.serviceTypeFilter,
    this.wilayaFilter,
  });

  @override
  List<Object?> get props => [demands, serviceTypeFilter, wilayaFilter];
}

class DemandDetailsLoaded extends DemandsState {
  final Demand demand;

  const DemandDetailsLoaded(this.demand);

  @override
  List<Object?> get props => [demand];
}

class SubmittingOffer extends DemandsState {}

class OfferSubmitted extends DemandsState {
  final String message;

  const OfferSubmitted(this.message);

  @override
  List<Object?> get props => [message];
}

class DemandsError extends DemandsState {
  final String message;

  const DemandsError(this.message);

  @override
  List<Object?> get props => [message];
}
