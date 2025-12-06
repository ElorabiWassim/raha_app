import 'service_provider_model.dart';

class Wilaya {
  final String name;
  final Map<String, List<ServiceProvider>> serviceProvidersByCategory;

  Wilaya({required this.name, required this.serviceProvidersByCategory});
}
