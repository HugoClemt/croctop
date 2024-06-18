import 'dart:convert';

import 'package:croctop/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthentificationService {
  final String _baseUrl = 'http://api.croc-top.com';

  Future<ApiResponse> signin(String identifier, String password) async {
    final Map<String, String> data = {
      'email': identifier.contains('@') ? identifier : '',
      'username': identifier.contains('@') ? '' : identifier,
      'password': password,
    };

    final String jsonBody = jsonEncode(data);

    print('Sending data to API: $jsonBody');

    final response = await http.post(
      Uri.parse('$_baseUrl/signin'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );

    print('Response from API: ${response.body}');
    print('Response status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['accessToken'] != null) {
        print('Saving token: ${jsonResponse['accessToken']}');
        await saveToken(jsonResponse['accessToken']);
      }
      return ApiResponse.fromJson(jsonResponse);
    } else {
      return ApiResponse(
        success: false,
        message: jsonDecode(response.body)['message'] ?? 'Failed to login',
      );
    }
  }

  Future<ApiResponse> signup(String firstname, String lastname, String username,
      String email, String password, DateTime birthday) async {
    final Map<String, dynamic> data = {
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'email': email,
      'password': password,
      'birthday': birthday.toIso8601String(),
    };

    final String jsonBody = jsonEncode(data);

    print('Sending data to API: $jsonBody');

    final response = await http.post(
      Uri.parse('$_baseUrl/signup'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );

    print('Response from API: ${response.body}');
    print('Response status code: ${response.statusCode}');

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['accessToken'] != null) {
        print('Saving token: ${jsonResponse['accessToken']}');
        await saveToken(jsonResponse['accessToken']);
      }
      return ApiResponse.fromJson(jsonResponse);
    } else {
      return ApiResponse(
        success: false,
        message: 'Failed to register',
      );
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> signout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
