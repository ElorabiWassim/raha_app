import 'package:equatable/equatable.dart';
import '../data/models/subscription_plan.dart';

abstract class PlansState extends Equatable {
  const PlansState();

  @override
  List<Object?> get props => [];
}

class PlansInitial extends PlansState {}

class PlansLoading extends PlansState {}

class PlansLoaded extends PlansState {
  final List<SubscriptionPlan> plans;

  const PlansLoaded(this.plans);

  @override
  List<Object?> get props => [plans];
}

class PlanDetailsLoaded extends PlansState {
  final SubscriptionPlan plan;

  const PlanDetailsLoaded(this.plan);

  @override
  List<Object?> get props => [plan];
}

class CurrentSubscriptionLoaded extends PlansState {
  final SubscriptionPlan plan;

  const CurrentSubscriptionLoaded(this.plan);

  @override
  List<Object?> get props => [plan];
}

class SubscribingToPlan extends PlansState {}

class SubscribedToPlan extends PlansState {
  final String message;

  const SubscribedToPlan(this.message);

  @override
  List<Object?> get props => [message];
}

class PlansError extends PlansState {
  final String message;

  const PlansError(this.message);

  @override
  List<Object?> get props => [message];
}
