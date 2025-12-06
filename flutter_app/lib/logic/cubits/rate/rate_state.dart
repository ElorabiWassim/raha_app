import 'package:equatable/equatable.dart';

abstract class RateState extends Equatable {
  const RateState();

  @override
  List<Object> get props => [];
}

class RateInitial extends RateState {}

class RateSubmitting extends RateState {}

class RateSuccess extends RateState {}

class RateFailure extends RateState {
  final String error;
  const RateFailure(this.error);

  @override
  List<Object> get props => [error];
}
