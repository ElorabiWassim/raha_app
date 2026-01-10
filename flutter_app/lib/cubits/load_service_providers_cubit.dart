import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/fetched_service_provider.dart';
import 'package:ra7a/core/config/backend_config.dart';

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

  Future<void> fetchTopNProviders({
    required String categoryId,
    required String location,
    required int topN,
  }) async {
    emit(ServiceProviderLoading());

    try {
      final url = Uri.parse(
        '${BackendConfig.baseUrl}/homeowner/getServiceProvidersTopN?category_id=$categoryId&location=$location&top_n=$topN',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);

        final providers = jsonList
            .map((element) => FetchedServiceProvider.fromJson(element))
            .toList();

        emit(ServiceProviderLoaded(providers));
      } else {
        emit(
          ServiceProviderError('No service providers are available indeed.'),
        );
      }
    } catch (e) {
      emit(ServiceProviderError(e.toString()));
    }
  }

  Future<void> fetchProviders({
    required String categoryId,
    required String location,
  }) async {
    emit(ServiceProviderLoading());

    try {
      final url = Uri.parse(
        '${BackendConfig.baseUrl}/homeowner/getServiceProviders?category_id=$categoryId&location=$location',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);

        final providers = jsonList
            .map((element) => FetchedServiceProvider.fromJson(element))
            .toList();

        emit(ServiceProviderLoaded(providers));
      } else {
        emit(ServiceProviderError('No service providers are availabe.'));
      }
    } catch (e) {
      emit(ServiceProviderError(e.toString()));
    }
  }
}
