import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/local/local_cache_repository.dart';
import '../../../data/local/local_models.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final LocalCacheRepository cacheRepository;

  ProfileCubit({required this.cacheRepository}) : super(ProfileInitial());

  Future<void> loadProfile() async {
    try {
      emit(ProfileLoading());

      final tokens = await cacheRepository.getAuthTokens();
      // Load profile from local database filtered by the current user
      final profile = tokens != null
          ? await cacheRepository.getUserProfile(userId: tokens.userId)
          : null;

      if (tokens == null || profile == null) {
        emit(const ProfileError('No profile data found. Please login again.'));
        return;
      }

      // For now, we don't have email/phone/address in local_models.dart
      // We'll use dummy values until we extend the schema or fetch from backend
      emit(
        ProfileLoaded(
          userId: profile.userId,
          fullName: profile.fullName,
          email:
              'user@example.com', // TODO: Get from backend or extend local model
          phone:
              '+213 XXX XXX XXX', // TODO: Get from backend or extend local model
          address: 'Algeria', // TODO: Get from backend or extend local model
          profileImageUrl: profile.profileImageUrl,
          role: profile.role,
        ),
      );
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String phone,
    required String address,
    String? profileImageUrl,
  }) async {
    try {
      final currentState = state;
      if (currentState is! ProfileLoaded) return;

      emit(ProfileLoading());

      // Update in local database
      final updatedProfile = LocalUserProfile(
        userId: currentState.userId,
        fullName: fullName,
        role: currentState.role,
        profileImageUrl: profileImageUrl,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      await cacheRepository.saveUserProfile(updatedProfile);

      // TODO: When backend is ready, also update on server
      // await profileApi.updateProfile(userId, data);

      // Emit updated state
      emit(
        ProfileLoaded(
          userId: currentState.userId,
          fullName: fullName,
          email: email,
          phone: phone,
          address: address,
          profileImageUrl: profileImageUrl,
          role: currentState.role,
        ),
      );
    } catch (e) {
      emit(ProfileError('Failed to update profile: ${e.toString()}'));
    }
  }
}
