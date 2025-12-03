import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/profile_data.dart';

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

// Profile Cubit
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : super(ProfileInitial(ProfileData(
          name: 'Mohamed RGB',
          email: 'Mohammedrgb89@email.com',
          phone: '0555897465',
          address: '123 Main Draria, Algiers, Algeria',
        )));

  void updateProfile(ProfileData newProfileData) {
    emit(ProfileLoading(state.profileData));
    
    // Simulate API call delay
    Future.delayed(Duration(milliseconds: 500), () {
      emit(ProfileUpdated(newProfileData));
    });
  }

  void resetToInitial() {
    emit(ProfileInitial(state.profileData));
  }
}