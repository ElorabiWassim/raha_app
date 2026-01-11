import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ra7a/cubits/language_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LanguageCubit (Unit)', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state defaults to en', () {
      final cubit = LanguageCubit();
      expect(cubit.state.locale.languageCode, 'en');
      cubit.close();
    });

    blocTest<LanguageCubit, LanguageState>(
      'loads saved language from SharedPreferences on startup',
      build: () {
        SharedPreferences.setMockInitialValues({'selected_language': 'fr'});
        return LanguageCubit();
      },
      wait: const Duration(milliseconds: 50),
      expect: () => [const LanguageState(Locale('fr'))],
    );

    blocTest<LanguageCubit, LanguageState>(
      'changeLanguage emits new locale and persists it',
      build: () => LanguageCubit(),
      act: (cubit) async {
        await cubit.changeLanguage('ar');
      },
      expect: () => [const LanguageState(Locale('ar'))],
      verify: (_) async {
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('selected_language'), 'ar');
      },
    );
  });
}
