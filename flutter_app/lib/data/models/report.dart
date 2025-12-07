class Report {
  final String reportId;
  final String homeownerName;
  final String providerName;
  final String issue;
  final String description;
  final String status;
  final DateTime createdAt;

  Report({
    required this.reportId,
    required this.homeownerName,
    required this.providerName,
    required this.issue,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      reportId: json['report_id'] ?? '',
      homeownerName: json['homeowner']?['user']?['full_name'] ?? '',
      providerName: json['service_provider']?['user']?['full_name'] ?? '',
      issue: json['issue'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'new',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
