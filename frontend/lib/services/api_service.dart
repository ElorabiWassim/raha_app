import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/sp';
  static const String authBaseUrl = 'http://10.0.2.2:5000/api/auth'; 
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }
  
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ============ PROFILE ENDPOINTS ============
  
  Future<Map<String, dynamic>> getProfile() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  // ============ SERVICES ENDPOINTS ============
  // Add this inside your ApiService class
Future<List<dynamic>> getImagesByServiceId(String serviceId) async {
  final headers = await _getHeaders();
  final response = await http.get(
    Uri.parse('$baseUrl/services/$serviceId/images'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['images'] ?? []; // returns list of image objects
  } else {
    throw Exception('Failed to load images for service $serviceId');
  }
}
  Future<List<dynamic>> getMyServices() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/services/my'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['services'];
    } else {
      throw Exception('Failed to load services');
    }
  }
  
  // 1. Add Service
Future<String> addService({
  required String name,
  required String description,
  required String categoryId,
  required String priceType,
  required double priceAmount,
}) async {
  final headers = await _getHeaders();
  final response = await http.post(
    Uri.parse('$baseUrl/services'),
    headers: headers,
    body: json.encode({
      'name': name,
      'description': description,
      'category_id': categoryId,
      'price_type': priceType,
      'price_amount': priceAmount,
    }),
  );

  if (response.statusCode == 201) {
    final data = json.decode(response.body);
    return data['service']['service_id']; // ← Return service_id
  } else {
    final error = json.decode(response.body)['error'] ?? 'Unknown error';
    throw Exception('Add service failed: $error');
  }
}

// 2. Upload Images for a Service
Future<void> uploadServiceImages({
  required String serviceId,
  required List<http.MultipartFile> images,
}) async {
  final headers = await _getHeaders();
  final request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/services/$serviceId/images'),
  );
  request.headers.addAll(headers);
  request.files.addAll(images);

  final response = await request.send();
  if (response.statusCode != 201) {
    throw Exception('Image upload failed');
  }
}
  // ============ DEMANDS ENDPOINTS ============
  
  Future<Map<String, dynamic>> getDemands({
    String? categoryId,
    String status = 'open',
    int page = 1,
    int limit = 20,
  }) async {
    final headers = await _getHeaders();
    
    // Build query parameters
    final queryParams = {
      'status': status,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (categoryId != null) {
      queryParams['category_id'] = categoryId;
    }
    
    final uri = Uri.parse('$baseUrl/demands').replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: headers);
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load demands');
    }
  }
  
  Future<Map<String, dynamic>> getDemandsByWilaya({
    required String wilaya,
    int page = 1,
    int limit = 20,
  }) async {
    final headers = await _getHeaders();
    
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    final uri = Uri.parse('$baseUrl/demands/wilaya/$wilaya')
        .replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: headers);
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load demands by wilaya');
    }
  }
  Future<Map<String, dynamic>> getDemandsByCategory({
    required String categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    final headers = await _getHeaders();
    
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    final uri = Uri.parse('$baseUrl/demands/category/$categoryId')
        .replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: headers);
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load demands by category');
    }
  }

  // ============ AUTHENTICATION ENDPOINTS ============
  
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String role, // 'service_provider' or 'homeowner'
    String? homeAddress, // Only for homeowner
  }) async {
    final response = await http.post(
      Uri.parse('$authBaseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'role': role,
        if (homeAddress != null) 'home_address': homeAddress,
      }),
    );
    
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      // Save token
      await _saveToken(data['token']);
      return data;
    } else {
      final error = json.decode(response.body);
      throw Exception(error['error'] ?? 'Registration failed');
    }
  }
  
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$authBaseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Save token and user data
      await _saveToken(data['token']);
      await _saveUserData(data['user']);
      return data;
    } else {
      final error = json.decode(response.body);
      throw Exception(error['error'] ?? 'Login failed');
    }
  }
  
  // Save token to SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }
  
  // Save user data to SharedPreferences
  Future<void> _saveUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user['user_id']);
    await prefs.setString('full_name', user['full_name']);
    await prefs.setString('email', user['email']);
    await prefs.setString('role', user['role']);
  }
  
  // Get user role
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') != null;
  }
  
  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_id');
    await prefs.remove('full_name');
    await prefs.remove('email');
    await prefs.remove('role');
  }
  // Add these methods to your existing ApiService class

// ============ BOOKINGS ENDPOINTS ============

Future<Map<String, dynamic>> getMyBookings() async {
  final headers = await _getHeaders();
  
  final response = await http.get(
    Uri.parse('$baseUrl/bookings'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load bookings: ${response.body}');
  }
}

Future<Map<String, dynamic>> getBookingHistory({int page = 1, int limit = 20}) async {
  final headers = await _getHeaders();
  
  final response = await http.get(
    Uri.parse('$baseUrl/bookings/history?page=$page&limit=$limit'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load booking history: ${response.body}');
  }
}

Future<Map<String, dynamic>> acceptBooking(String bookingId) async {
  final headers = await _getHeaders();
  
  final response = await http.put(
    Uri.parse('$baseUrl/bookings/$bookingId/accept'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to accept booking: ${response.body}');
  }
}

Future<Map<String, dynamic>> declineBooking(String bookingId) async {
  final headers = await _getHeaders();
  
  final response = await http.put(
    Uri.parse('$baseUrl/bookings/$bookingId/decline'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to decline booking: ${response.body}');
  }
}

Future<Map<String, dynamic>> completeBooking(String bookingId) async {
  final headers = await _getHeaders();
  
  final response = await http.put(
    Uri.parse('$baseUrl/bookings/$bookingId/complete'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to complete booking: ${response.body}');
  }
}
}