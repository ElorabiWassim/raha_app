import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String userId;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String? profileImageUrl;
  final String role;
  
  const ProfileLoaded({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    this.profileImageUrl,
    required this.role,
  });
  
  @override
  List<Object?> get props => [
    userId,
    fullName,
    email,
    phone,
    address,
    profileImageUrl,
    role,
  ];
}

class ProfileError extends ProfileState {
  final String message;
  
  const ProfileError(this.message);
  
  @override
  List<Object> get props => [message];
}
