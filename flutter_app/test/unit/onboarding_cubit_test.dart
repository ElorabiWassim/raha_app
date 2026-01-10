import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ra7a/data/local/preferences_service.dart';
import 'package:ra7a/logic/cubits/onboarding/onboarding_cubit.dart';
import 'package:ra7a/logic/cubits/onboarding/onboarding_state.dart';

class _MockPreferencesService extends Mock implements PreferencesService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OnboardingCubit (Unit)', () {
    late _MockPreferencesService prefs;

    blocTest<OnboardingCubit, OnboardingState>(
      'pageChanged emits OnboardingPageChanged',
      build: () {
        prefs = _MockPreferencesService();
        return OnboardingCubit(preferences: prefs);
      },
      act: (cubit) => cubit.pageChanged(2),
      expect: () => [const OnboardingPageChanged(2)],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'completeOnboarding sets onboardingSeen=true and emits OnboardingCompleted',
      build: () {
        prefs = _MockPreferencesService();
        when(() => prefs.setOnboardingSeen(true)).thenAnswer((_) async {});
        return OnboardingCubit(preferences: prefs);
      },
      act: (cubit) => cubit.completeOnboarding(),
      expect: () => [isA<OnboardingCompleted>()],
      verify: (_) {
        verify(() => prefs.setOnboardingSeen(true)).called(1);
      },
    );
  });
}
