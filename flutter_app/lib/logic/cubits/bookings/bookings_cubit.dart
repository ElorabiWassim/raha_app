import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/booking_model.dart';

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

  Future<void> loadBookings() async {
    try {
      emit(BookingsLoading());
      await Future.delayed(const Duration(seconds: 1)); // Simulate API

      // Mock Data
      final bookings = [
        Booking(
          id: '1',
          providerName: 'Karim Benzema',
          providerImage: 'https://i.pravatar.cc/150?img=12',
          serviceName: 'Plumbing Repair',
          dateTime: '25 Oct, 10:00 AM',
          price: '5,000 DZD',
          status: BookingStatus.upcoming,
        ),
        Booking(
          id: '2',
          providerName: 'Nadia Belkacem',
          providerImage: 'https://i.pravatar.cc/150?img=47',
          serviceName: 'House Cleaning',
          dateTime: '22 Oct, 02:00 PM',
          price: '3,500 DZD',
          status: BookingStatus.completed,
        ),
        Booking(
          id: '3',
          providerName: 'Ahmed Djebbour',
          providerImage: 'https://i.pravatar.cc/150?img=33',
          serviceName: 'AC Maintenance',
          dateTime: '15 Oct, 09:30 AM',
          price: '6,000 DZD',
          status: BookingStatus.cancelled,
        ),
      ];

      emit(BookingsLoaded(bookings));
    } catch (e) {
      emit(const BookingsError("Failed to load bookings"));
    }
  }
}
