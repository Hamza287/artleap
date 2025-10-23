import 'package:dio/dio.dart';
import '../../../shared/constants/app_api_paths.dart';
import '../../api_services/api_response.dart';
import '../../api_services/handling_response.dart';
import '../../base_repo/base.dart';
import '../models/like_model.dart';


abstract class LikeRepo extends Base {
  Future<ApiResponse> getLikes(String imageId, {int page, int limit});
  Future<ApiResponse> addLike(String imageId);
  Future<ApiResponse> removeLike(String imageId);
  Future<ApiResponse> isLiked(String imageId);
  Future<ApiResponse> getLikeCount(String imageId);
  Future<ApiResponse> getUserLikes();
}


class LikeRepoImpl extends LikeRepo {
  @override
  Future<ApiResponse> getLikes(String imageId, {int page = 1, int limit = 20}) async {
    try {
      final path = AppApiPaths.getImageLikes.replaceFirst(':imageId', imageId);
      final queryParams = {
        'page': page,
        'limit': limit,
      };

      Response res = await artleapApiService.get(path, queryParameters: queryParams);
      ApiResponse result = HandlingResponse.returnResponse(res);

      if (result.status == Status.completed) {
        final likesData = res.data['data'] as List<dynamic>;
        final likes = likesData.map((json) => LikeModel.fromJson(json)).toList();
        return ApiResponse.completed(likes);
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse> addLike(String imageId) async {
    try {
      final path = AppApiPaths.likeImage.replaceFirst(':imageId', imageId);

      Response res = await artleapApiService.postJson(path, {});
      ApiResponse result = HandlingResponse.returnResponse(res);

      if (result.status == Status.completed) {
        final likeData = res.data['data'];
        final like = LikeModel.fromJson(likeData);
        return ApiResponse.completed(like);
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse> removeLike(String imageId) async {
    try {
      final path = AppApiPaths.unlikeImage.replaceFirst(':imageId', imageId);

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
  Future<ApiResponse> isLiked(String imageId) async {
    try {
      final path = AppApiPaths.checkUserLike.replaceFirst(':imageId', imageId);

      Response res = await artleapApiService.get(path);
      ApiResponse result = HandlingResponse.returnResponse(res);

      if (result.status == Status.completed) {
        final isLiked = res.data['data']['isLiked'] ?? false;
        return ApiResponse.completed(isLiked);
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse> getLikeCount(String imageId) async {
    try {
      final path = AppApiPaths.getLikeCount.replaceFirst(':imageId', imageId);

      Response res = await artleapApiService.get(path);
      ApiResponse result = HandlingResponse.returnResponse(res);

      if (result.status == Status.completed) {
        final count = res.data['data']['likeCount'] ?? 0;
        return ApiResponse.completed(count);
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse> getUserLikes() async {
    try {
      Response res = await artleapApiService.get(AppApiPaths.getUserLikes);
      ApiResponse result = HandlingResponse.returnResponse(res);

      if (result.status == Status.completed) {
        final likesData = res.data['data'] as List<dynamic>;
        final likes = likesData.map((json) => LikeModel.fromJson(json)).toList();
        return ApiResponse.completed(likes);
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }
}