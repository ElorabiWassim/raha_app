import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import 'package:ra7a/modules/authentication/screens/splash.dart';
import 'logic/cubits/auth/auth_cubit.dart';
import 'logic/cubits/localization/localization_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocalizationCubit()),
        BlocProvider(create: (context) => AuthCubit()),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: state.locale,
          supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            if (state is! LocalizationInitial) return state.locale;
            for (final locale in supportedLocales) {
              if (locale.languageCode == deviceLocale?.languageCode) {
                return locale;
              }
            }
            return const Locale('en');
          },
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          home: SplashScreen(
            key: ValueKey('splash_${state.locale.languageCode}'),
            onLocaleChanged: (locale) {
              context.read<LocalizationCubit>().changeLanguage(
                locale.languageCode,
              );
            },
          ),
        );
      },
    );
  }
}
