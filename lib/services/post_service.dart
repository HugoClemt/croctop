import 'dart:convert';

import 'package:croctop/models/api_response.dart';
import 'package:croctop/services/authentification_service.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PostService {
  final String _baseUrl = 'http://api.croc-top.com';

  Future<ApiResponse> createRecipes(
    String title,
    String prepTime,
    String cookTime,
    String category,
    List<String> steps,
    List<Map<String, String>> ingredients,
    List<String> allergens,
    List<XFile> imageUrls,
  ) async {
    final token = await AuthentificationService().getToken();
    final uri = Uri.parse('$_baseUrl/posts');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['title'] = title
      ..fields['prepTime'] = prepTime
      ..fields['cookTime'] = cookTime
      ..fields['category'] = category;

    for (var i = 0; i < steps.length; i++) {
      request.fields['prepSteps[$i]'] = steps[i];
    }

    for (var i = 0; i < ingredients.length; i++) {
      request.fields['ingredients[$i][name]'] = ingredients[i]['name']!;
      request.fields['ingredients[$i][quantity]'] = ingredients[i]['quantity']!;
      request.fields['ingredients[$i][unit]'] = ingredients[i]['unit']!;
    }

    for (var i = 0; i < allergens.length; i++) {
      request.fields['allergens[$i]'] = allergens[i];
    }

    for (var file in imageUrls) {
      request.files.add(await http.MultipartFile.fromPath('photos', file.path));
    }

    print('Request to API: ${request.fields}');

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print('Response from API: ${response.body}');
    print('Response status code: ${response.statusCode}');

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse);
    } else {
      return ApiResponse(
        success: false,
        message: 'Failed to create recipes',
      );
    }
  }
}
