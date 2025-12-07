class SubscriptionPlan {
  final String id;
  final String name;
  final String price;
  final String period;
  final List<String> features;
  final bool isRecommended;
  final String? description;
  final int maxRequests;
  final bool priority;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    required this.features,
    required this.isRecommended,
    this.description,
    this.maxRequests = 10,
    this.priority = false,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['plan_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price']?.toString() ?? '0',
      period: json['period'] ?? 'monthly',
      features: List<String>.from(json['features'] ?? []),
      isRecommended: json['is_recommended'] ?? false,
      description: json['description'],
      maxRequests: json['max_requests'] ?? 10,
      priority: json['priority'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_id': id,
      'name': name,
      'price': price,
      'period': period,
      'features': features,
      'is_recommended': isRecommended,
      'description': description,
      'max_requests': maxRequests,
      'priority': priority,
    };
  }
}
