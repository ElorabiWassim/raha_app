class ServiceProvider {
  String name;
  String profession;
  String location;
  double rating;
  int reviewCount;
  String jobsDone;
  String experience;
  String responseTime;
  int pendingRequests;
  int confirmedJobs;
  int totalEarnings;
  List<Service> services;

  ServiceProvider({
    required this.name,
    required this.profession,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.jobsDone,
    required this.experience,
    required this.responseTime,
    required this.pendingRequests,
    required this.confirmedJobs,
    required this.totalEarnings,
    required this.services,
  });
}

// Service Model
class Service {
  String title;
  String price;
  bool isActive;
  String category;
  String description;
  String pricingModel;
  final List<String> images;


  Service({
    required this.title,
    required this.price,
    required this.isActive,
    this.category = 'Plumbing',
    this.description = '',
    this.pricingModel = 'Fixed Price',
    this.images = const [],
  });
}