import 'package:equatable/equatable.dart';
import '../data/models/provider_application.dart';

abstract class ApplicationsState extends Equatable {
  const ApplicationsState();

  @override
  List<Object?> get props => [];
}

class ApplicationsInitial extends ApplicationsState {}

class ApplicationsLoading extends ApplicationsState {}

class ApplicationsLoaded extends ApplicationsState {
  final List<ProviderApplication> applications;

  const ApplicationsLoaded(this.applications);

  @override
  List<Object> get props => [applications];
}

class ApplicationsError extends ApplicationsState {
  final String message;

  const ApplicationsError(this.message);

  @override
  List<Object> get props => [message];
}

class ApplicationActionSuccess extends ApplicationsState {
  final String message;

  const ApplicationActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}
