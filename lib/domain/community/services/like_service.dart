import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/like_model.dart';

class LikeService {
  final String baseUrl;
  final String? authToken;

  LikeService({required this.baseUrl, this.authToken});

  Future<List<LikeModel>> getLikes(String imageId, {int page = 1, int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/images/$imageId/likes?page=$page&limit=$limit'),
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> likesData = data['data'];
          return likesData.map((json) => LikeModel.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load likes');
        }
      } else {
        throw Exception('Failed to load likes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load likes: $e');
    }
  }

  Future<LikeModel> addLike(String imageId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/images/$imageId/like'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return LikeModel.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to add like');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to add like: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add like: $e');
    }
  }

  Future<void> removeLike(String imageId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/images/$imageId/like'),
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to remove like: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to remove like: $e');
    }
  }

  Future<bool> isLiked(String imageId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/images/$imageId/likes/check'),
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data']['isLiked'] ?? false;
        } else {
          throw Exception(data['message'] ?? 'Failed to check like status');
        }
      } else {
        throw Exception('Failed to check like status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to check like status: $e');
    }
  }

  Future<int> getLikeCount(String imageId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/images/$imageId/likes/count'),
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data']['likeCount'] ?? 0;
        } else {
          throw Exception(data['message'] ?? 'Failed to get like count');
        }
      } else {
        throw Exception('Failed to get like count: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get like count: $e');
    }
  }
}