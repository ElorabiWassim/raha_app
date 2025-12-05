import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ra7a/data/local/local_cache_repository.dart';
import 'package:ra7a/data/local/preferences_service.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required LocalCacheRepository cacheRepository,
    required PreferencesService preferences,
  }) : _cacheRepository = cacheRepository,
       _preferences = preferences,
       super(SplashInitial());

  final LocalCacheRepository _cacheRepository;
  final PreferencesService _preferences;

  Future<void> initialize() async {
    emit(SplashLoading());
    try {
      final tokens = await _cacheRepository.getAuthTokens();

      if (tokens != null) {
        emit(SplashNavigateToHome(tokens.userRole));
        return;
      }

      if (_preferences.onboardingSeen) {
        emit(SplashNavigateToLogin());
      } else {
        emit(SplashInitial());
      }
    } catch (error) {
      emit(SplashError(error.toString()));
    }
  }

  void continueToOnboarding() {
    emit(SplashNavigateToOnboarding());
  }
}
