import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comment_model.dart';

class CommentService {
  final String baseUrl;
  final String? authToken;

  CommentService({required this.baseUrl, this.authToken});

  Future<List<CommentModel>> getComments(String imageId, {int page = 1, int limit = 20, String sort = 'newest'}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/images/$imageId/comments?page=$page&limit=$limit&sort=$sort'),
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> commentsData = data['data'];
          return commentsData.map((json) => CommentModel.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load comments');
        }
      } else {
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load comments: $e');
    }
  }

  Future<CommentModel> addComment({
    required String imageId,
    required String comment,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/images/$imageId/comments'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'comment': comment,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return CommentModel.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to add comment');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to add comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/comments/$commentId'),
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to delete comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  Future<CommentModel> updateComment({
    required String commentId,
    required String comment,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/comments/$commentId'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'comment': comment,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return CommentModel.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to update comment');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }

  Future<int> getCommentCount(String imageId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/images/$imageId/comments/count'),
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data']['commentCount'] ?? 0;
        } else {
          throw Exception(data['message'] ?? 'Failed to get comment count');
        }
      } else {
        throw Exception('Failed to get comment count: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get comment count: $e');
    }
  }
}