class DashboardStats {
  final int totalUsers;
  final int verifiedSPs;
  final int activeBookings;
  final double revenue;

  DashboardStats({
    required this.totalUsers,
    required this.verifiedSPs,
    required this.activeBookings,
    required this.revenue,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalUsers: json['totalUsers'] ?? 0,
      verifiedSPs: json['verifiedSPs'] ?? 0,
      activeBookings: json['activeBookings'] ?? 0,
      revenue: (json['revenue'] ?? 0).toDouble(),
    );
  }
}
