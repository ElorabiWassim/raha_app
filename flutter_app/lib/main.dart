import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ra7a/cubits/demands_cubits.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import 'package:ra7a/modules/authentication/screens/splash.dart';
import 'package:ra7a/cubits/language_cubit.dart';
import 'package:ra7a/cubits/profile_cubit.dart';
import 'package:ra7a/service_locator.dart';
import 'package:ra7a/cubits/booking_cubit.dart';
import 'package:ra7a/presentation/screens/add_demand.dart';
import 'package:ra7a/data/local/preferences_service.dart';
import 'package:ra7a/data/local/local_cache_repository.dart';
import 'package:ra7a/cubits/serviceprovider_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize PreferencesService
  final preferencesService = await PreferencesService.create();

  // Initialize LocalCacheRepository (only on mobile, not on web)
  LocalCacheRepository? localCacheRepository;
  if (!kIsWeb) {
    localCacheRepository = LocalCacheRepository();
    await localCacheRepository.init();
  }

  // Setup dependency injection for Cubit architecture
  // Update the baseUrl to match your backend URL
  await setupDependencies(baseUrl: 'http://10.15.243.27:5000');

  runApp(
    MyApp(
      preferencesService: preferencesService,
      localCacheRepository: localCacheRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final PreferencesService preferencesService;
  final LocalCacheRepository? localCacheRepository;

  const MyApp({
    super.key,
    required this.preferencesService,
    required this.localCacheRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PreferencesService>.value(value: preferencesService),
        if (localCacheRepository != null)
          Provider<LocalCacheRepository>.value(value: localCacheRepository!),
        BlocProvider(create: (context) => LanguageCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => AddDemandCubit(), child: AddDemand()),
        BlocProvider(create: (context) => BookServiceCubit()),
        BlocProvider(create: (context) => ServiceProviderCubit()),
      ],
      child: MultiBlocProvider(
        providers: [
          // App-level Cubits that persist across the entire app
          BlocProvider(create: (context) => LanguageCubit()),
          BlocProvider(create: (context) => ProfileCubit()),

          // Feature Cubits from GetIt (use getIt to get instances)
          // These are provided globally for easy access throughout the app
          // Note: For specific pages, you can also provide them locally
          BlocProvider(
            create: (context) => AddDemandCubit(),
            child: AddDemand(),
          ),
          BlocProvider(create: (context) => BookServiceCubit()),
        ],
        child: const MyAppView(),
      ),
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
