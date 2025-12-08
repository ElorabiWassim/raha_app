import 'package:get_it/get_it.dart';

// Services
import 'services/api_service.dart';

// Repositories
import 'data/repositories/dashboard_repository.dart';
import 'data/repositories/applications_repository.dart';
import 'data/repositories/reports_repository.dart';
import 'data/repositories/plans_repository.dart';
import 'data/repositories/requests_repository.dart';
import 'data/repositories/demands_repository.dart';
import 'data/repositories/offers_repository.dart';
import 'data/repositories/verification_repository.dart';
import 'data/repositories/reviews_repository.dart';
import 'data/repositories/conversations_repository.dart';

// Cubits
import 'cubits/dashboard_cubit.dart';
import 'cubits/applications_cubit.dart';
import 'cubits/reports_cubit.dart';
import 'cubits/plans_cubit.dart';
import 'cubits/requests_cubit.dart';
import 'cubits/demands_cubit.dart';
import 'cubits/demand_details_cubit.dart';
import 'cubits/send_offer_cubit.dart';
import 'cubits/verification_cubit.dart';
import 'cubits/reviews_cubit.dart';
import 'cubits/conversations_cubit.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies for dependency injection
/// Call this method in main.dart before runApp()
Future<void> setupDependencies({String? baseUrl}) async {
  // Register API Service
  getIt.registerLazySingleton<ApiService>(() => ApiService());

  // Register Repositories
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepository(apiService: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<ApplicationsRepository>(
    () => ApplicationsRepository(apiService: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<ReportsRepository>(
    () => ReportsRepository(apiService: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<PlansRepository>(
    () => PlansRepository(apiService: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<RequestsRepository>(
    () => RequestsRepository(apiService: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<DemandsRepository>(
    () => DemandsRepository(apiService: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<OffersRepository>(
    () => OffersRepository(apiService: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<VerificationRepository>(
    () => VerificationRepository(apiService: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<ReviewsRepository>(
    () => ReviewsRepository(apiService: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<ConversationsRepository>(
    () => ConversationsRepository(apiService: getIt<ApiService>()),
  );

  // Register Cubits (Factory - new instance each time)
  getIt.registerFactory<DashboardCubit>(
    () => DashboardCubit(repository: getIt<DashboardRepository>()),
  );

  getIt.registerFactory<ApplicationsCubit>(
    () => ApplicationsCubit(repository: getIt<ApplicationsRepository>()),
  );

  getIt.registerFactory<ReportsCubit>(
    () => ReportsCubit(repository: getIt<ReportsRepository>()),
  );

  getIt.registerFactory<PlansCubit>(
    () => PlansCubit(repository: getIt<PlansRepository>()),
  );

  getIt.registerFactory<RequestsCubit>(
    () => RequestsCubit(repository: getIt<RequestsRepository>()),
  );

  getIt.registerFactory<DemandsCubit>(
    () => DemandsCubit(repository: getIt<DemandsRepository>()),
  );

  getIt.registerFactory<DemandDetailsCubit>(
    () => DemandDetailsCubit(repository: getIt<DemandsRepository>()),
  );

  getIt.registerFactory<SendOfferCubit>(
    () => SendOfferCubit(repository: getIt<OffersRepository>()),
  );

  getIt.registerFactory<VerificationCubit>(
    () => VerificationCubit(repository: getIt<VerificationRepository>()),
  );

  getIt.registerFactory<ReviewsCubit>(
    () => ReviewsCubit(repository: getIt<ReviewsRepository>()),
  );

  getIt.registerFactory<ConversationsCubit>(
    () => ConversationsCubit(repository: getIt<ConversationsRepository>()),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
