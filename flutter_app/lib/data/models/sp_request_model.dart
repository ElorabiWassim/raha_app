enum RequestStatus { pending, accepted, rejected, completed, cancelled }

class SPRequest {
  final String requestId;
  final String bookingId;
  final String homeownerId;
  final String homeownerName;
  final String homeownerPhone;
  final String serviceName;
  final String serviceDescription;
  final String location;
  final String wilaya;
  final DateTime scheduledDate;
  final String? scheduledTime;
  final double? offeredPrice;
  final RequestStatus status;
  final DateTime createdAt;
  final String? notes;

  SPRequest({
    required this.requestId,
    required this.bookingId,
    required this.homeownerId,
    required this.homeownerName,
    required this.homeownerPhone,
    required this.serviceName,
    required this.serviceDescription,
    required this.location,
    required this.wilaya,
    required this.scheduledDate,
    this.scheduledTime,
    this.offeredPrice,
    required this.status,
    required this.createdAt,
    this.notes,
  });

  factory SPRequest.fromJson(Map<String, dynamic> json) {
    return SPRequest(
      requestId: json['request_id'] ?? json['booking_id'] ?? '',
      bookingId: json['booking_id'] ?? '',
      homeownerId: json['homeowner_id'] ?? '',
      homeownerName: json['homeowner']?['user']?['full_name'] ?? '',
      homeownerPhone: json['homeowner']?['user']?['phone_number'] ?? '',
      serviceName: json['service']?['service_name'] ?? '',
      serviceDescription: json['service']?['description'] ?? '',
      location: json['location'] ?? '',
      wilaya: json['wilaya'] ?? '',
      scheduledDate: DateTime.parse(
        json['scheduled_date'] ?? DateTime.now().toIso8601String(),
      ),
      scheduledTime: json['scheduled_time'],
      offeredPrice: json['offered_price']?.toDouble(),
      status: _parseStatus(json['status']),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      notes: json['notes'],
    );
  }

  static RequestStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return RequestStatus.accepted;
      case 'rejected':
        return RequestStatus.rejected;
      case 'completed':
        return RequestStatus.completed;
      case 'cancelled':
        return RequestStatus.cancelled;
      default:
        return RequestStatus.pending;
    }
  }

  String get statusString {
    switch (status) {
      case RequestStatus.pending:
        return 'pending';
      case RequestStatus.accepted:
        return 'accepted';
      case RequestStatus.rejected:
        return 'rejected';
      case RequestStatus.completed:
        return 'completed';
      case RequestStatus.cancelled:
        return 'cancelled';
    }
  }

  Map<String, dynamic> toJson() {
    return {'booking_id': bookingId, 'status': statusString, 'notes': notes};
  }
}
