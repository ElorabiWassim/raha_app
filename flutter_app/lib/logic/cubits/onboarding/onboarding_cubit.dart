import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  void pageChanged(int index) {
    emit(OnboardingPageChanged(index));
  }

  void completeOnboarding() {
    // Save to shared prefs that onboarding is done
    emit(OnboardingCompleted());
  }
}
