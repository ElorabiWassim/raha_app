import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/sp';
  static const String authBaseUrl = 'http://10.0.2.2:5000/api/auth';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    print('=== _getToken called ===');
    print('Token retrieved: $token');
    return token;
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    print('=== _getHeaders called ===');
    print('Token in headers: $token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000$endpoint'),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000$endpoint'),
        headers: headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5000$endpoint'),
        headers: headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final jsonResponse = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonResponse;
      } else {
        return {
          'success': false,
          'error': jsonResponse['error'] ?? 'Unknown error',
        };
      }
    } catch (e) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true};
      }
      throw Exception('Request failed');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/api/profile'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Failed to load profile: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<List<dynamic>> getImagesByServiceId(String serviceId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/services/$serviceId/images'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['images'] ?? [];
    } else {
      throw Exception('Failed to load images for service $serviceId');
    }
  }

  Future<List<dynamic>> getMyServices() async {
    final headers = await _getHeaders();
    print('📡 Fetching services from: $baseUrl/services/my');
    final response = await http.get(
      Uri.parse('$baseUrl/services/my'),
      headers: headers,
    );

    print('Services response status: ${response.statusCode}');
    print('Services response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['services'] ?? [];
    } else {
      throw Exception(
        'Failed to load services: ${response.statusCode} - ${response.body}',
      );
    }
  }

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
      return data['service']['service_id'];
    } else {
      final error = json.decode(response.body)['error'] ?? 'Unknown error';
      throw Exception('Add service failed: $error');
    }
  }

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

  Future<Map<String, dynamic>> getDemands({
    String? categoryId,
    String status = 'open',
    int page = 1,
    int limit = 20,
  }) async {
    final headers = await _getHeaders();

    final queryParams = {
      'status': status,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (categoryId != null) {
      queryParams['category_id'] = categoryId;
    }

    final uri = Uri.parse(
      '$baseUrl/demands',
    ).replace(queryParameters: queryParams);
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

    final queryParams = {'page': page.toString(), 'limit': limit.toString()};

    final uri = Uri.parse(
      '$baseUrl/demands/wilaya/$wilaya',
    ).replace(queryParameters: queryParams);
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

    final queryParams = {'page': page.toString(), 'limit': limit.toString()};

    final uri = Uri.parse(
      '$baseUrl/demands/category/$categoryId',
    ).replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load demands by category');
    }
  }

  Future<Map<String, dynamic>> sendOffer({
    required String demandId,
    required String message,
    required double proposedPrice,
    required String proposedDate,
  }) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/offers/send'),
      headers: headers,
      body: json.encode({
        'demand_id': demandId,
        'message': message,
        'proposed_price': proposedPrice,
        'proposed_date': proposedDate,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['error'] ?? 'Failed to send offer');
    }
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String role,
    String? homeAddress,
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
    print('=== Login called ===');
    print('Email: $email');

    final response = await http.post(
      Uri.parse('$authBaseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    print('Login response status: ${response.statusCode}');
    print('Login response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('=== Login successful ===');
      print('Response data: $data');

      final token = data['session']?['access_token'] ?? '';
      print('Token to save: $token');

      await _saveToken(token);
      await _saveUserData(data['user']);
      return data;
    } else {
      final error = json.decode(response.body);
      throw Exception(error['error'] ?? 'Login failed');
    }
  }

  Future<Map<String, dynamic>> googleAuth({
    required String idToken,
    String? role,
    String? phoneNumber,
    String? homeAddress,
    String? workingAddress,
  }) async {
    final response = await http.post(
      Uri.parse('$authBaseUrl/google'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'idToken': idToken,
        if (role != null && role.isNotEmpty) 'role': role,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (homeAddress != null) 'home_address': homeAddress,
        if (workingAddress != null) 'working_address': workingAddress,
      }),
    );

    final data = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final token = data['session']?['access_token'] ?? '';
      if (token is String && token.isNotEmpty) {
        await _saveToken(token);
      }
      final user = data['user'];
      if (user is Map<String, dynamic>) {
        await _saveUserData(user);
      }
      return data;
    }

    throw Exception(
      (data['error'] as String?) ?? 'Google authentication failed',
    );
  }

  Future<void> _saveToken(String token) async {
    print('=== _saveToken called ===');
    print('Saving token: $token');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);

    final savedToken = prefs.getString('jwt_token');
    print('Token saved and verified: $savedToken');
  }

  Future<void> _saveUserData(Map<String, dynamic> user) async {
    print('=== _saveUserData called ===');
    print('User data received: $user');

    final prefs = await SharedPreferences.getInstance();
    final userId = user['id'] ?? user['user_id'];
    final fullName = user['full_name'];
    final email = user['email'];
    final role = user['role'];

    print('Extracted values:');
    print('  userId: $userId (null: ${userId == null})');
    print('  fullName: $fullName (null: ${fullName == null})');
    print('  email: $email (null: ${email == null})');
    print('  role: $role (null: ${role == null})');

    if (userId == null) print('WARNING: userId is NULL - using fallback');
    if (fullName == null) {
      print('WARNING: fullName is NULL - using email as fallback');
    }
    if (email == null) print('WARNING: email is NULL');
    if (role == null) {
      print('WARNING: role is NULL - using homeowner as fallback');
    }

    final finalUserId = userId ?? '';
    final finalFullName = fullName ?? email ?? '';
    final finalEmail = email ?? '';
    final finalRole = role ?? 'homeowner';

    if (finalUserId.isNotEmpty) await prefs.setString('user_id', finalUserId);
    if (finalFullName.isNotEmpty) {
      await prefs.setString('full_name', finalFullName);
    }
    if (finalEmail.isNotEmpty) await prefs.setString('email', finalEmail);
    if (finalRole.isNotEmpty) await prefs.setString('role', finalRole);

    print('=== Data saved successfully ===');
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') != null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_id');
    await prefs.remove('full_name');
    await prefs.remove('email');
    await prefs.remove('role');
  }

  Future<void> changePassword({required String newPassword}) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('http://10.0.2.2:5000/api/profile/password'),
      headers: headers,
      body: json.encode({'newPassword': newPassword}),
    );

    if (response.statusCode == 200) return;
    final data = json.decode(response.body);
    throw Exception(data['error'] ?? 'Failed to change password');
  }

  Future<void> deleteAccount() async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:5000/api/profile/account'),
      headers: headers,
    );

    if (response.statusCode == 200) return;
    final data = json.decode(response.body);
    throw Exception(data['error'] ?? 'Failed to delete account');
  }

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

  Future<Map<String, dynamic>> getBookingHistory({
    int page = 1,
    int limit = 20,
  }) async {
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

  Future<Map<String, dynamic>> updateService(
    String serviceId,
    Map<String, dynamic> updates,
  ) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/services/$serviceId'),
      headers: headers,
      body: json.encode(updates),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update service: ${response.body}');
    }
  }

  Future<void> deleteService(String serviceId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/services/$serviceId'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete service: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getServiceById(String serviceId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/services/$serviceId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load service details: ${response.body}');
    }
  }

  Future<void> updateProfile({
    String? name,
    
    String? location,
    String? experience,
  }) async {
    final headers = await _getHeaders();
    final body = <String, dynamic>{};

    if (name != null) body['full_name'] = name;
    if (location != null) body['location'] = location;
    if (experience != null) body['experience_years'] = experience;

  
    final response = await http.put(
      Uri.parse('$baseUrl/profiles/update'),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  Future<String> updateProfilePicture(imageFile) async {
    final headers = await _getHeaders();

    headers.remove('Content-Type');

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl/profiles/update/image'),
    );

    request.headers.addAll(headers);

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return data['imageUrl'] ?? data['profile_picture_url'];
    } else {
      throw Exception('Failed to upload profile picture: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createCategory(
    String name,
    String description,
  ) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: headers,
      body: json.encode({'name': name, 'description': description}),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create category: ${response.body}');
    }
  }

  Future<void> deleteServiceImage(String imageId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/images/$imageId'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete image: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateServiceImage({
    required String imageId,
    required http.MultipartFile image,
  }) async {
    final headers = await _getHeaders();
    headers.remove('Content-Type');

    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl/images/$imageId'),
    );

    request.headers.addAll(headers);
    request.files.add(image);

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return json.decode(responseBody);
    } else {
      throw Exception('Failed to update image: $responseBody');
    }
  }

  Future<Map<String, dynamic>> getDemandDetails(String demandId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/demands/$demandId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load demand details: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getMyOffers({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final headers = await _getHeaders();

    final queryParams = {'page': page.toString(), 'limit': limit.toString()};
    if (status != null) {
      queryParams['status'] = status;
    }

    final uri = Uri.parse(
      '$baseUrl/offers/my',
    ).replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load my offers: ${response.body}');
    }
  }

  Future<List<dynamic>> getSubscriptionPlans() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/plans'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['plans'] ?? [];
    } else {
      throw Exception('Failed to load plans: ${response.body}');
    }
  }

  Future<void> subscribeToPlan(String tierName) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/plans/subscribe'),
      headers: headers,
      body: json.encode({'tier': tierName, 'payment_method': 'credit_card'}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to upgrade plan: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> searchDemands({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    final headers = await _getHeaders();
    final queryParams = {
      'query': query,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    final uri = Uri.parse(
      '$baseUrl/demands/title',
    ).replace(queryParameters: queryParams);

    print(' Searching URL: $uri');

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      if (response.statusCode == 400) {
        final error = json.decode(response.body)['error'];
        throw Exception(error);
      }
      throw Exception('Failed to search demands: ${response.body}');
    }
  }
}
