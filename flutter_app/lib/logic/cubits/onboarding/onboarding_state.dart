import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingPageChanged extends OnboardingState {
  final int index;
  const OnboardingPageChanged(this.index);

  @override
  List<Object> get props => [index];
}

class OnboardingCompleted extends OnboardingState {}
