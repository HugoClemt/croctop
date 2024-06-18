import 'dart:convert';

import 'package:croctop/models/api_response.dart';
import 'package:croctop/services/authentification_service.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String _baseUrl = 'http://api.croc-top.com';

  Future<Map<String, dynamic>?> getUserInfo() async {
    final String? token = await AuthentificationService().getToken();
    if (token == null) {
      throw Exception('Token is null');
    }
    final response = await http.get(
      Uri.parse('$_baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      print('Failed to load user info: ${response.body}');
      return null;
    }
  }

  Future<ApiResponse> updateProfile(Map<String, dynamic> data) async {
    final String? token = await AuthentificationService().getToken();
    if (token == null) {
      throw Exception('Token is null');
    }
    final jsonBody = jsonEncode(data);
    final response = await http.put(
      Uri.parse('$_baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    print('Response from API: ${response.body}');
    print('Response status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse);
    } else {
      return ApiResponse(
        success: false,
        message: 'Failed to update profile',
      );
    }
  }
}
