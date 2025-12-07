import 'dart:convert';
import 'package:http/http.dart' as http;

class DemandsApi {
  final String baseUrl;
  
  DemandsApi({this.baseUrl = 'http://10.162.71.174:3000'});
  
  Future<List<Map<String, dynamic>>> fetchMyDemands({
    required String userId,
    required String accessToken,
  }) async {
    final url = Uri.parse('$baseUrl/api/demands/my-demands');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    ).timeout(const Duration(seconds: 10));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['demands'] ?? []);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized - Please login again');
    } else {
      throw Exception('Failed to fetch demands: ${response.statusCode}');
    }
  }
  
  Future<List<Map<String, dynamic>>> getDemandApplicants({
    required String demandId,
    required String accessToken,
  }) async {
    final url = Uri.parse('$baseUrl/api/demands/$demandId/applicants');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    ).timeout(const Duration(seconds: 10));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['applicants'] ?? []);
    } else {
      throw Exception('Failed to fetch applicants: ${response.statusCode}');
    }
  }
  
  Future<void> updateDemand({
    required String demandId,
    required Map<String, dynamic> demandData,
    required String accessToken,
  }) async {
    final url = Uri.parse('$baseUrl/api/demands/$demandId');
    
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(demandData),
    ).timeout(const Duration(seconds: 10));
    
    if (response.statusCode != 200) {
      throw Exception('Failed to update demand: ${response.statusCode}');
    }
  }
  
  Future<void> cancelDemand({
    required String demandId,
    required String accessToken,
  }) async {
    final url = Uri.parse('$baseUrl/api/demands/$demandId');
    
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    ).timeout(const Duration(seconds: 10));
    
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to cancel demand: ${response.statusCode}');
    }
  }
}
