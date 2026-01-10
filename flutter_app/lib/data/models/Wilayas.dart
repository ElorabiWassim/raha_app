import 'service_provider_model.dart';

class Wilaya {
  final String name;
  String? wilaya_name;
  final Map<String, List<ServiceProvider>> serviceProvidersByCategory;

  Wilaya({
    required this.name,
    required this.serviceProvidersByCategory,
    this.wilaya_name,
  });
}
