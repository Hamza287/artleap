import 'package:dio/dio.dart';
import '../../../shared/constants/app_api_paths.dart';
import '../../api_services/api_response.dart';
import '../../api_services/handling_response.dart';
import '../../base_repo/base.dart';
import '../models/comment_model.dart';

abstract class CommentRepo extends Base {
  Future<ApiResponse> getComments(String imageId, {int page, int limit, String sort});
  Future<ApiResponse> addComment({required String imageId, required String comment});
  Future<ApiResponse> deleteComment(String commentId);
  Future<ApiResponse> updateComment({required String commentId, required String comment});
  Future<ApiResponse> getCommentCount(String imageId);
  Future<ApiResponse> getUserComments();
}


class CommentRepoImpl extends CommentRepo {

  Future<ApiResponse> getComments(String imageId,
      {int page = 1, int limit = 20, String sort = 'newest'}) async {
    try {
      final path =
          AppApiPaths.getImageComments.replaceFirst(':imageId', imageId);
      final queryParams = {
        'page': page,
        'limit': limit,
        'sort': sort,
      };

      Response res =
          await artleapApiService.get(path, queryParameters: queryParams);
      ApiResponse result = HandlingResponse.returnResponse(res);

      if (result.status == Status.completed) {
        final commentsData = res.data['data'] as List<dynamic>;
        final comments =
            commentsData.map((json) => CommentModel.fromJson(json)).toList();
        return ApiResponse.completed(comments);
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse> addComment({
    required String imageId,
    required String comment,
  }) async {
    try {
      final path = AppApiPaths.addComment.replaceFirst(':imageId', imageId);
      final body = {
        'comment': comment,
      };

      Response res = await artleapApiService.postJson(path, body);
      ApiResponse result = HandlingResponse.returnResponse(res);

      if (result.status == Status.completed) {
        final commentData = res.data['data'];
        final newComment = CommentModel.fromJson(commentData);
        return ApiResponse.completed(newComment);
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse> deleteComment(String commentId) async {
    try {
      final path = AppApiPaths.deleteComment.replaceFirst(':commentId', commentId);

      Response res = await artleapApiService.delete(path);
      ApiResponse result = HandlingResponse.returnResponse(res);

      if (result.status == Status.completed) {
        return ApiResponse.completed(true);
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse> updateComment({
    required String commentId,
    required String comment,
  }) async {
    try {
      final path =
          AppApiPaths.updateComment.replaceFirst(':commentId', commentId);
      final body = {
        'comment': comment,
      };

      Response res = await artleapApiService.putJson(path, body);
      ApiResponse result = HandlingResponse.returnResponse(res);

      if (result.status == Status.completed) {
        final commentData = res.data['data'];
        final updatedComment = CommentModel.fromJson(commentData);
        return ApiResponse.completed(updatedComment);
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse> getCommentCount(String imageId) async {
    try {
      final path =
          AppApiPaths.getCommentCount.replaceFirst(':imageId', imageId);

      Response res = await artleapApiService.get(path);
      ApiResponse result = HandlingResponse.returnResponse(res);

      if (result.status == Status.completed) {
        final count = res.data['data']['commentCount'] ?? 0;
        return ApiResponse.completed(count);
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse> getUserComments() async {
    try {
      Response res =
          await artleapApiService.get(AppApiPaths.getUserComments);
      ApiResponse result = HandlingResponse.returnResponse(res);

      if (result.status == Status.completed) {
        final commentsData = res.data['data'] as List<dynamic>;
        final comments =
            commentsData.map((json) => CommentModel.fromJson(json)).toList();
        return ApiResponse.completed(comments);
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }
}
