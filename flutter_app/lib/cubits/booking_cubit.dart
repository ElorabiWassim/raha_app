import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookServiceRequest {
  //we will use this class to construct the request
  final String description;
  final String serviceId;
  final String homeownerId;
  final String spId;
  final String date;
  final String time;
  final String location;
  final List<String> photosPaths;

  BookServiceRequest({
    required this.description,
    required this.serviceId,
    required this.homeownerId,
    required this.spId,
    required this.date,
    required this.time,
    required this.location,
    required this.photosPaths,
  });
}

abstract class BookServiceState {}

class BookServiceInitial extends BookServiceState {}

class BookServiceLoading extends BookServiceState {}

class BookServiceSuccess extends BookServiceState {}

class BookServiceFailure extends BookServiceState {
  final String message;
  BookServiceFailure(this.message);
}

class BookServiceCubit extends Cubit<BookServiceState> {
  BookServiceCubit() : super(BookServiceInitial());

  final dio = Dio();

  Future<void> bookService(BookServiceRequest data) async {
    emit(BookServiceLoading());

    try {
      // Convert images to MultipartFile list
      List<MultipartFile> photoFiles = [];

      for (String path in data.photosPaths) {
        photoFiles.add(await MultipartFile.fromFile(path));
      }

      // Build FormData to match your screenshot
      final formData = FormData.fromMap({
        "description": data.description,
        "service_id": data.serviceId,
        "homeowner_id": data.homeownerId,
        "sp_id": data.spId,
        "date": data.date,
        "time": data.time,
        "location": data.location,
        "photos": photoFiles,
      });

      // Send request
      final response = await dio.post(
        "http://10.10.15.243.27.2.2:5000/homeowner/bookService",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      emit(BookServiceSuccess());
    } catch (e) {
      emit(BookServiceFailure(e.toString()));
    }
  }
}
