import 'package:equatable/equatable.dart';

abstract class DemandDetailsState extends Equatable {
  const DemandDetailsState();

  @override
  List<Object?> get props => [];
}

class DemandDetailsInitial extends DemandDetailsState {}

class DemandDetailsLoading extends DemandDetailsState {}

class DemandDetailsLoaded extends DemandDetailsState {
  final Map<String, dynamic> demand;

  const DemandDetailsLoaded(this.demand);

  @override
  List<Object?> get props => [demand];
}

class DemandDetailsError extends DemandDetailsState {
  final String message;

  const DemandDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
