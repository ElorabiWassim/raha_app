import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ra7a/core/config/backend_config.dart';

@immutable
abstract class AddDemandState {}

class AddDemandInitial extends AddDemandState {}

class AddDemandLoading extends AddDemandState {}

class AddDemandSuccess extends AddDemandState {
  final String message;
  AddDemandSuccess({required this.message});
}

class AddDemandFailure extends AddDemandState {
  final String message;
  AddDemandFailure({required this.message});
}

class AddDemandCubit extends Cubit<AddDemandState> {
  AddDemandCubit() : super(AddDemandInitial());

  Future<void> addDemand({
    required String homeownerId,
    required String categoryName,
    required String title,
    required String location,
    required String date,
    required String time,
    required String description,
  }) async {
    emit(AddDemandLoading());

    final url = Uri.parse(
      "${BackendConfig.baseUrl}/homeowner/addDemand",
    ); // Use emulator IP
    final body = {
      "homeowner_id": homeownerId,
      "category_name": categoryName,
      "title": title,
      "location": location,
      "date": date,
      "time": time,
      "description": description,
    };

    try {
      // Print the request body for debugging
      print("Sending request to backend:");
      print(jsonEncode(body));

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      // Print status and raw response
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Try to parse response JSON safely
      String serverMessage = response.body;
      try {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is Map && jsonResponse.containsKey('message')) {
          serverMessage = jsonResponse['message'];
        }
      } catch (_) {
        // If response is not JSON, just keep raw body
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(AddDemandSuccess(message: serverMessage));
      } else {
        emit(AddDemandFailure(message: "Error: $serverMessage"));
      }
    } catch (e) {
      print("Exception occurred: $e");
      emit(AddDemandFailure(message: "Failed to connect to server: $e"));
    }
  }

  Future<void> editDemand({
    required String demandId,
    required String categoryName,
    required String title,
    required String location,
    required String date,
    required String time,
    required String description,
  }) async {
    emit(AddDemandLoading());

    final url = Uri.parse("${BackendConfig.baseUrl}/homeowner/editDemand");
    final body = {
      'demand_id': demandId,
      'category_name': categoryName,
      'title': title,
      'location': location,
      'date': date,
      'time': time,
      'description': description,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      String serverMessage = response.body;
      try {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is Map && jsonResponse.containsKey('message')) {
          serverMessage = jsonResponse['message'];
        }
      } catch (_) {}

      if (response.statusCode >= 200 && response.statusCode < 300) {
        emit(AddDemandSuccess(message: serverMessage));
      } else {
        emit(AddDemandFailure(message: "Error: $serverMessage"));
      }
    } catch (e) {
      emit(AddDemandFailure(message: "Failed to connect to server: $e"));
    }
  }
}

@immutable
abstract class UserDemandsState {}

class UserDemandsInitial extends UserDemandsState {}

class UserDemandsLoading extends UserDemandsState {}

class UserDemandsSuccess extends UserDemandsState {
  final List<dynamic> demands;
  UserDemandsSuccess({required this.demands});
}

class UserDemandsFailure extends UserDemandsState {
  final String message;
  UserDemandsFailure({required this.message});
}

class UserDemandsCubit extends Cubit<UserDemandsState> {
  UserDemandsCubit() : super(UserDemandsInitial());

  Future<void> fetchUserDemands({required String homeownerId}) async {
    emit(UserDemandsLoading());

    final url = Uri.parse(
      "${BackendConfig.baseUrl}/homeowner/getUserDemands?homeowner_id=$homeownerId",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Fetched user demands: $data");
        emit(UserDemandsSuccess(demands: data));
      } else {
        emit(UserDemandsFailure(message: "Error: ${response.body}"));
      }
    } catch (e) {
      emit(UserDemandsFailure(message: "Failed to connect to server: $e"));
    }
  }
}
