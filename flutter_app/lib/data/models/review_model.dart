class Review {
  final String reviewId;
  final String bookingId;
  final String homeownerId;
  final String homeownerName;
  final String spId;
  final String spName;
  final double rating;
  final String? reviewText;
  final DateTime createdAt;
  final String status;

  Review({
    required this.reviewId,
    required this.bookingId,
    required this.homeownerId,
    required this.homeownerName,
    required this.spId,
    required this.spName,
    required this.rating,
    this.reviewText,
    required this.createdAt,
    required this.status,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['review_id'] ?? '',
      bookingId: json['booking_id'] ?? '',
      homeownerId: json['homeowner_id'] ?? '',
      homeownerName:
          json['homeowner_name'] ??
          json['homeowner']?['full_name'] ??
          'Anonymous',
      spId: json['sp_id'] ?? '',
      spName:
          json['sp_name'] ??
          json['service_provider']?['user']?['full_name'] ??
          '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewText: json['review_text'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      status: json['status'] ?? 'visible',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'sp_id': spId,
      'rating': rating,
      'review_text': reviewText,
    };
  }
}
