import '../../api_services/api_response.dart';
import '../models/comment_model.dart';
import '../repo_impl/comment_repo_impl.dart';

class CommentRepository {
  final CommentRepo _commentRepo;

  CommentRepository({required CommentRepo commentRepo})
      : _commentRepo = commentRepo;

  Future<List<CommentModel>> getComments(String imageId, {int page = 1, int limit = 20, String sort = 'newest'}) async {
    final response = await _commentRepo.getComments(imageId, page: page, limit: limit, sort: sort);

    if (response.status == Status.completed) {
      return response.data as List<CommentModel>;
    } else {
      throw Exception(response.message ?? 'Failed to load comments');
    }
  }

  Future<CommentModel> addComment({
    required String imageId,
    required String comment,
  }) async {
    final response = await _commentRepo.addComment(
      imageId: imageId,
      comment: comment,
    );

    if (response.status == Status.completed) {
      return response.data as CommentModel;
    } else {
      throw Exception(response.message ?? 'Failed to add comment');
    }
  }

  Future<void> deleteComment(String commentId) async {
    final response = await _commentRepo.deleteComment(commentId);

    if (response.status != Status.completed) {
      throw Exception(response.message ?? 'Failed to delete comment');
    }
  }

  Future<CommentModel> updateComment({
    required String commentId,
    required String comment,
  }) async {
    final response = await _commentRepo.updateComment(
      commentId: commentId,
      comment: comment,
    );

    if (response.status == Status.completed) {
      return response.data as CommentModel;
    } else {
      throw Exception(response.message ?? 'Failed to update comment');
    }
  }

  Future<int> getCommentCount(String imageId) async {
    final response = await _commentRepo.getCommentCount(imageId);

    if (response.status == Status.completed) {
      return response.data as int;
    } else {
      throw Exception(response.message ?? 'Failed to get comment count');
    }
  }

  Future<List<CommentModel>> getUserComments() async {
    final response = await _commentRepo.getUserComments();

    if (response.status == Status.completed) {
      return response.data as List<CommentModel>;
    } else {
      throw Exception(response.message ?? 'Failed to load user comments');
    }
  }
}