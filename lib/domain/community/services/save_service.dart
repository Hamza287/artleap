import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/save_model.dart';

class SaveService {
  final String baseUrl;
  final String? authToken;

  SaveService({required this.baseUrl, this.authToken});

  Future<List<SaveModel>> getSavedPosts({int page = 1, int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/saved?page=$page&limit=$limit'),
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> savedData = data['data'];
          return savedData.map((json) => SaveModel.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load saved posts');
        }
      } else {
        throw Exception('Failed to load saved posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load saved posts: $e');
    }
  }

  Future<SaveModel> savePost(String imageId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/images/$imageId/save'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return SaveModel.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to save post');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to save post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to save post: $e');
    }
  }

  Future<void> unsavePost(String imageId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/images/$imageId/save'),
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to unsave post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to unsave post: $e');
    }
  }

  Future<bool> isSaved(String imageId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/images/$imageId/save/check'),
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data']['isSaved'] ?? false;
        } else {
          throw Exception(data['message'] ?? 'Failed to check save status');
        }
      } else {
        throw Exception('Failed to check save status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to check save status: $e');
    }
  }

  Future<int> getSavedCount() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/saved/count'),
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data']['savedCount'] ?? 0;
        } else {
          throw Exception(data['message'] ?? 'Failed to get saved count');
        }
      } else {
        throw Exception('Failed to get saved count: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get saved count: $e');
    }
  }
}