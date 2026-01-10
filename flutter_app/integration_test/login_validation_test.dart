import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ra7a/l10n/app_localizations.dart';
import 'package:ra7a/modules/authentication/screens/login.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login form validation (Integration)', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('en'),
        home: const LoginScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Tap login with empty fields -> should show validators.
    final loginButton = find.byType(ElevatedButton).first;
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);

    // Enter invalid email and valid password -> email validator should trigger.
    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));

    await tester.enterText(fields.at(0), 'not-an-email');
    await tester.enterText(fields.at(1), '123456');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Email must be valid'), findsOneWidget);

    // Enter valid email and short password -> password length validator.
    await tester.enterText(fields.at(0), 'test@example.com');
    await tester.enterText(fields.at(1), '123');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });
}
