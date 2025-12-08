import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/fetched_service_provider.dart';

@immutable
abstract class ServiceProviderState {}

class ServiceProviderInitial extends ServiceProviderState {}

class ServiceProviderLoading extends ServiceProviderState {}

class ServiceProviderLoaded extends ServiceProviderState {
  final List<FetchedServiceProvider> providers;
  ServiceProviderLoaded(this.providers);
}

class ServiceProviderError extends ServiceProviderState {
  final String message;
  ServiceProviderError(this.message);
}

class ServiceProviderCubit extends Cubit<ServiceProviderState> {
  ServiceProviderCubit() : super(ServiceProviderInitial());

  Future<void> fetchProviders({
    required String categoryId,
    required String location,
  }) async {
    emit(ServiceProviderLoading());

    try {
      final url = Uri.parse(
        'http://localhost:5000/homeowner/getServiceProviders?category_id=$categoryId&location=$location',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);

        final providers = jsonList
            .map((element) => FetchedServiceProvider.fromJson(element))
            .toList();

        emit(ServiceProviderLoaded(providers));
      } else {
        emit(ServiceProviderError('Failed to load service providers'));
      }
    } catch (e) {
      emit(ServiceProviderError(e.toString()));
    }
  }
}
