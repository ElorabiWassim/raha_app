import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ra7a/cubits/language_cubit.dart';
import 'package:ra7a/data/local/preferences_service.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import 'package:ra7a/modules/authentication/screens/splash.dart';
import 'package:ra7a/modules/authentication/screens/onboarding.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Splash: select language navigates to onboarding', (
    tester,
  ) async {
    // PreferencesService.create() relies on SharedPreferences.
    SharedPreferences.setMockInitialValues({});
    final preferences = await PreferencesService.create();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<PreferencesService>.value(value: preferences),
          BlocProvider(create: (_) => LanguageCubit()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale('en'),
          home: const SplashScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Grab localized language label from the widget tree.
    final splashElement = tester.element(find.byType(SplashScreen));
    final l10n = AppLocalizations.of(splashElement);

    // Tap "English" button (in current locale).
    final englishLabel = l10n.languageEnglish;
    await tester.tap(find.text(englishLabel));

    // Splash uses a Future.delayed(300ms) before navigation.
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
