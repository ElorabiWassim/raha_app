import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/local/local_cache_repository.dart';
import '../../../data/remote/bookings_api.dart';

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
  final bool isOnline;
  
  const BookingsLoaded(this.bookings, {this.isOnline = true});
  
  @override
  List<Object> get props => [bookings, isOnline];
}

class BookingsError extends BookingsState {
  final String message;
  const BookingsError(this.message);
  @override
  List<Object> get props => [message];
}

// Cubit
class BookingsCubit extends Cubit<BookingsState> {
  final LocalCacheRepository? cacheRepository;
  final BookingsApi? bookingsApi;
  final String? userId;
  final String? accessToken;
  
  BookingsCubit({
    this.cacheRepository,
    this.bookingsApi,
    this.userId,
    this.accessToken,
  }) : super(BookingsInitial());

  Future<void> loadBookings() async {
    try {
      emit(BookingsLoading());
      
      // Strategy: Try online first, fallback to cache if fails
      bool loadedFromBackend = false;
      List<Booking> bookings = [];
      
      // Try to fetch from backend if API and credentials are available
      if (bookingsApi != null && userId != null && accessToken != null) {
        try {
          final backendData = await bookingsApi!.fetchMyBookings(
            userId: userId!,
            accessToken: accessToken!,
          );
          
          // Convert backend data to Booking objects
          bookings = backendData.map((data) => Booking(
            id: data['id'] as String,
            providerName: data['providerName'] as String,
            providerImage: data['providerImage'] as String? ?? '',
            serviceName: data['serviceName'] as String,
            dateTime: data['dateTime'] as String,
            price: data['price'] as String,
            status: _parseStatus(data['status'] as String),
          )).toList();
          
          // Save to cache for offline use
          if (cacheRepository != null && userId != null) {
            await cacheRepository!.saveBookings(userId!, backendData);
          }
          
          loadedFromBackend = true;
        } catch (e) {
          // Network/API error - will fallback to cache
          print('Failed to fetch bookings from backend: $e');
        }
      }
      
      // If backend fetch failed or not available, try cache
      if (!loadedFromBackend) {
        if (cacheRepository != null && userId != null) {
          final hasCached = await cacheRepository!.hasCachedBookings(userId!);
          if (hasCached) {
            final cachedData = await cacheRepository!.getBookings(userId!);
            bookings = cachedData.map((data) => Booking(
              id: data['id'] as String,
              providerName: data['providerName'] as String,
              providerImage: data['providerImage'] as String,
              serviceName: data['serviceName'] as String,
              dateTime: data['dateTime'] as String,
              price: data['price'] as String,
              status: _parseStatus(data['status'] as String),
            )).toList();
            
            emit(BookingsLoaded(bookings, isOnline: false));
            return;
          }
        }
        
        // No cache available, use dummy data as fallback
        bookings = _getDummyBookings();
        
        // Save dummy data to cache
        if (cacheRepository != null && userId != null) {
          final bookingsData = bookings.map((b) => {
            'id': b.id,
            'providerName': b.providerName,
            'providerImage': b.providerImage,
            'serviceName': b.serviceName,
            'dateTime': b.dateTime,
            'price': b.price,
            'status': b.status.toString(),
          }).toList();
          await cacheRepository!.saveBookings(userId!, bookingsData);
        }
      }

      emit(BookingsLoaded(bookings, isOnline: loadedFromBackend));
    } catch (e) {
      emit(BookingsError("Failed to load bookings: ${e.toString()}"));
    }
  }
  
  List<Booking> _getDummyBookings() {
    return [
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
  }
  
  BookingStatus _parseStatus(String status) {
    if (status.contains('upcoming')) return BookingStatus.upcoming;
    if (status.contains('completed')) return BookingStatus.completed;
    if (status.contains('cancelled')) return BookingStatus.cancelled;
    return BookingStatus.upcoming;
  }
}
