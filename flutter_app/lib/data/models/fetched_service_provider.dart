class FetchedServiceProvider {
  final String id;
  final String name;
  final String profession;
  final String workingAddress;
  final String profile_picture_url;
  final double rating;

  FetchedServiceProvider({
    required this.id,
    required this.name,
    required this.profession,
    required this.workingAddress,
    required this.profile_picture_url,
    required this.rating,
  });

  factory FetchedServiceProvider.fromJson(Map<String, dynamic> json) {
    return FetchedServiceProvider(
      id: json['sp_id'] ?? '',
      name: json['users']?['full_name'] ?? 'Unknown',
      profession: json['service_type']?['name'] ?? '',
      workingAddress: json['working_address'] ?? '',
      profile_picture_url: json['profile_picture_url'] ?? '',
      rating: (json['average_rating'] ?? 0).toDouble(),
    );
  }
}
