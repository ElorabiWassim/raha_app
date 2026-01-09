class ServiceProvider {
  String name;
  String profession;
  String location;
  double? rating;
  int? reviewCount;
  String jobsDone;
  String experience;
  String? responseTime;
  int? pendingRequests;
  int? confirmedJobs;
  int? totalEarnings;
  List<Service> services;
  String? profileImageUrl;
  

  ServiceProvider({
    required this.name,
    required this.profession,
    required this.location,
     this.rating,
     this.reviewCount,
    required this.jobsDone,
    required this.experience,
     this.responseTime,
    this.pendingRequests,
     this.confirmedJobs,
     this.totalEarnings,
    required this.services,
    required this.profileImageUrl
  });
}

// Service Model
class Service {
  final String id;
  String title;
  String price;
  bool isActive;
  String category;
  String description;
  String pricingModel;
  final List<String> images;


  Service({
    required this.id,
    required this.title,
    required this.price,
    required this.isActive,
    this.category = 'Plumbing',
    this.description = '',
    this.pricingModel = 'Fixed Price',
    this.images = const [],
  });
}