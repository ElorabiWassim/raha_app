enum BookingStatus { upcoming, completed, cancelled }

class Booking {
  final String id;
  final String providerName;
  final String providerImage;
  final String serviceName;
  final String dateTime;
  final String price;
  final BookingStatus status;

  Booking({
    required this.id,
    required this.providerName,
    required this.providerImage,
    required this.serviceName,
    required this.dateTime,
    required this.price,
    required this.status,
  });
}
