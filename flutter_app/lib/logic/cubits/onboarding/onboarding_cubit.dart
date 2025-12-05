import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ra7a/data/local/preferences_service.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required PreferencesService preferences})
    : _preferences = preferences,
      super(OnboardingInitial());

  final PreferencesService _preferences;

  void pageChanged(int index) {
    emit(OnboardingPageChanged(index));
  }

  Future<void> completeOnboarding() async {
    await _preferences.setOnboardingSeen(true);
    emit(OnboardingCompleted());
  }
}
