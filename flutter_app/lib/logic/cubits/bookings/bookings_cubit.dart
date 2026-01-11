import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/booking_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ra7a/core/config/backend_config.dart';

// State
abstract class BookingsState extends Equatable {
  const BookingsState();
  @override
  List<Object> get props => [];
}

class BookingsInitial extends BookingsState {}

class BookingsLoading extends BookingsState {}

class BookingsLoaded extends BookingsState {
  final List<Booking> bookings;
  const BookingsLoaded(this.bookings);
  @override
  List<Object> get props => [bookings];
}

class BookingsError extends BookingsState {
  final String message;
  const BookingsError(this.message);
  @override
  List<Object> get props => [message];
}

// Cubit
class BookingsCubit extends Cubit<BookingsState> {
  BookingsCubit() : super(BookingsInitial());

  BookingStatus _parseStatus(dynamic status) {
    final s = (status ?? '').toString().toLowerCase();
    if (s.contains('cancel')) return BookingStatus.cancelled;
    if (s.contains('complete')) return BookingStatus.completed;
    return BookingStatus.upcoming;
  }

  Future<void> loadBookings() async {
    try {
      emit(BookingsLoading());
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      if (userId == null || userId.isEmpty) {
        emit(const BookingsError('Please login to view bookings'));
        return;
      }

      final url = Uri.parse(
        '${BackendConfig.baseUrl}/homeowner/getBookingOfUser/$userId',
      );
      final response = await http.get(url);

      if (response.statusCode != 200) {
        emit(const BookingsError('Failed to load bookings'));
        return;
      }

      final decoded = jsonDecode(response.body);
      final rawBookings = (decoded is Map && decoded['bookings'] is List)
          ? decoded['bookings'] as List
          : <dynamic>[];

      final bookings = rawBookings.map((b) {
        final map = (b as Map).cast<String, dynamic>();
        final serviceProvider =
            map['service_provider'] as Map<String, dynamic>?;
        final username = serviceProvider?['username'] as Map<String, dynamic>?;
        final serviceCategory =
            serviceProvider?['service_category'] as Map<String, dynamic>?;
        final priceObj = map['price'] as Map<String, dynamic>?;

        final providerName = (username?['full_name'] ?? '').toString();
        final serviceName = (serviceCategory?['name'] ?? '').toString();
        final date = (map['date'] ?? '').toString();
        final time = (map['time'] ?? '').toString();
        final priceAmount = priceObj?['price_amount'];

        return Booking(
          id: (map['booking_id'] ?? '').toString(),
          providerName: providerName.isNotEmpty ? providerName : '—',
          providerImage: '',
          serviceName: serviceName.isNotEmpty ? serviceName : '—',
          dateTime: [date, time].where((e) => e.isNotEmpty).join(' '),
          price: priceAmount != null ? '${priceAmount.toString()} DZD' : '',
          status: _parseStatus(map['status']),
        );
      }).toList();

      emit(BookingsLoaded(bookings));
    } catch (e) {
      emit(const BookingsError("Failed to load bookings"));
    }
  }
}
