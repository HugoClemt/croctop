import 'dart:convert';

import 'package:croctop/models/api_response.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String _baseUrl = 'http://api.croc-top.com';

  Future<ApiResponse> showProfile(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/me'),
      headers: {
        'Content-Type': 'application',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response from API: ${response.body}');
    print('Response status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse);
    } else {
      return ApiResponse(
        success: false,
        message: 'Failed to show profile',
      );
    }
  }
}
