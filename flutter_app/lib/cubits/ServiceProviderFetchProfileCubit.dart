import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ra7a/core/config/backend_config.dart';

@immutable
abstract class ServiceProviderProfileState {}

class ProfileInitial extends ServiceProviderProfileState {}

class ProfileLoading extends ServiceProviderProfileState {}

class ProfileLoaded extends ServiceProviderProfileState {
  final Map<String, dynamic> profile;
  ProfileLoaded(this.profile);
}

class ProfileError extends ServiceProviderProfileState {
  final String message;
  ProfileError(this.message);
}

class ServiceProviderProfileCubit extends Cubit<ServiceProviderProfileState> {
  ServiceProviderProfileCubit() : super(ProfileInitial());

  Future<void> fetchProfile(String spId) async {
    emit(ProfileLoading());

    try {
      final url = Uri.parse(
        "${BackendConfig.baseUrl}/homeowner/getServiceProviderProfile?sp_id=$spId",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        emit(ProfileLoaded(json.decode(response.body)));
      } else {
        emit(ProfileError("Failed to load profile"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
