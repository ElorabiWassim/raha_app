import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ra7a/cubits/demands_cubits.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import 'package:ra7a/modules/authentication/screens/splash.dart';
import 'package:ra7a/cubits/language_cubit.dart';
import 'package:ra7a/cubits/profile_cubit.dart';
import 'package:ra7a/cubits/booking_cubit.dart';
import 'package:ra7a/presentation/screens/add_demand.dart';
import 'package:ra7a/cubits/serviceprovider_cubit.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LanguageCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => AddDemandCubit(), child: AddDemand()),
        BlocProvider(create: (context) => BookServiceCubit()),
        BlocProvider(create: (context) => ServiceProviderCubit()),
      ],
      child: const MyAppView(),
    );
  }
}

class MyAppView extends StatefulWidget {
  const MyAppView({super.key});

  @override
  State<MyAppView> createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, languageState) {
        return MaterialApp(
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,

          // Use Cubit locale
          locale: languageState.locale,

          supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          localeResolutionCallback: (deviceLocale, supportedLocales) {
            // First check if Cubit has a saved locale
            if (languageState.locale.languageCode.isNotEmpty) {
              return languageState.locale;
            }

            // Otherwise, match device locale
            for (final locale in supportedLocales) {
              if (locale.languageCode == deviceLocale?.languageCode) {
                return locale;
              }
            }

            // Default to English
            return const Locale('en');
          },

          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,

          home: SplashScreen(
            key: ValueKey('splash_${languageState.locale.languageCode}'),
          ),
        );
      },
    );
  }
}
