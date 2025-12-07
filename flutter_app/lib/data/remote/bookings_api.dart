import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingsApi {
  final String baseUrl;
  
  BookingsApi({this.baseUrl = 'http://10.162.71.174:3000'});
  
  Future<List<Map<String, dynamic>>> fetchMyBookings({
    required String userId,
    required String accessToken,
  }) async {
    final url = Uri.parse('$baseUrl/api/bookings/my-bookings');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    ).timeout(const Duration(seconds: 10));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['bookings'] ?? []);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized - Please login again');
    } else {
      throw Exception('Failed to fetch bookings: ${response.statusCode}');
    }
  }
  
  Future<void> submitRating({
    required String bookingId,
    required int rating,
    required String review,
    required String accessToken,
  }) async {
    final url = Uri.parse('$baseUrl/api/bookings/$bookingId/rating');
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'rating': rating,
        'review': review,
      }),
    ).timeout(const Duration(seconds: 10));
    
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to submit rating: ${response.statusCode}');
    }
  }
}
