import 'package:equatable/equatable.dart';
import '../data/models/sp_request_model.dart';

abstract class RequestsState extends Equatable {
  const RequestsState();

  @override
  List<Object?> get props => [];
}

class RequestsInitial extends RequestsState {}

class RequestsLoading extends RequestsState {}

class RequestsLoaded extends RequestsState {
  final List<SPRequest> requests;
  final String? activeFilter;

  const RequestsLoaded(this.requests, {this.activeFilter});

  @override
  List<Object?> get props => [requests, activeFilter];
}

class RequestDetailsLoaded extends RequestsState {
  final SPRequest request;

  const RequestDetailsLoaded(this.request);

  @override
  List<Object?> get props => [request];
}

class RequestStatusUpdating extends RequestsState {}

class RequestStatusUpdated extends RequestsState {
  final String message;

  const RequestStatusUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class RequestsError extends RequestsState {
  final String message;

  const RequestsError(this.message);

  @override
  List<Object?> get props => [message];
}
