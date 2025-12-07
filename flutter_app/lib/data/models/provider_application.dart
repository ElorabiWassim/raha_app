class ProviderApplication {
  final String applicationId;
  final String userId;
  final String fullName;
  final String email;
  final String status;
  final List<String> services;
  final DateTime submittedAt;

  ProviderApplication({
    required this.applicationId,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.status,
    required this.services,
    required this.submittedAt,
  });

  factory ProviderApplication.fromJson(Map<String, dynamic> json) {
    return ProviderApplication(
      applicationId: json['application_id'] ?? '',
      userId: json['user_id'] ?? '',
      fullName: json['user']?['full_name'] ?? '',
      email: json['user']?['email'] ?? '',
      status: json['status'] ?? 'pending',
      services: List<String>.from(json['services'] ?? []),
      submittedAt: DateTime.parse(json['submitted_at']),
    );
  }
}
