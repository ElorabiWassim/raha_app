import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/profile_data.dart';
import '../services/api_service.dart';

// Profile State
abstract class ProfileState extends Equatable {
  final ProfileData profileData;

  const ProfileState(this.profileData);

  @override
  List<Object> get props => [profileData];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial(super.profileData);
}

class ProfileLoading extends ProfileState {
  const ProfileLoading(super.profileData);
}

class ProfileUpdated extends ProfileState {
  const ProfileUpdated(super.profileData);
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(super.profileData, this.message);

  @override
  List<Object> get props => [profileData, message];
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
    : super(
        ProfileInitial(
          ProfileData(name: '', email: '', phone: '', address: ''),
        ),
      );

  Future<void> fetchProfile() async {
    emit(ProfileLoading(state.profileData));

    try {
      final data = await ApiService().getProfile();
      final profile = (data['profile'] is Map)
          ? (data['profile'] as Map)
          : <String, dynamic>{};

      final name = profile['full_name']?.toString() ?? '';
      final email = profile['email']?.toString() ?? '';
      final phone = profile['phone_number']?.toString() ?? '';
      final address = profile['home_address']?.toString() ?? '';
      final rawImageUrl =
          (profile['profile_picture_url'] ?? profile['image_url'])?.toString();
      final profileImageUrl =
          (rawImageUrl != null && rawImageUrl.trim().isNotEmpty)
          ? rawImageUrl.trim()
          : null;

      emit(
        ProfileUpdated(
          ProfileData(
            name: name,
            email: email,
            phone: phone,
            address: address,
            profileImageUrl: profileImageUrl,
          ),
        ),
      );
    } catch (e) {
      emit(ProfileError(state.profileData, e.toString()));
    }
  }

  void updateProfile(ProfileData newProfileData) {
    emit(ProfileLoading(state.profileData));

    Future.delayed(Duration(milliseconds: 500), () {
      emit(ProfileUpdated(newProfileData));
    });
  }

  void resetToInitial() {
    emit(ProfileInitial(state.profileData));
  }
}
