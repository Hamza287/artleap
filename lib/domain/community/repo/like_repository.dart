import '../../api_services/api_response.dart';
import '../models/like_model.dart';
import '../repo_impl/like_repo_impl.dart';

class LikeRepository {
  final LikeRepo _likeRepo;

  LikeRepository({required LikeRepo likeRepo})
      : _likeRepo = likeRepo;

  Future<List<LikeModel>> getLikes(String imageId, {int page = 1, int limit = 20}) async {
    final response = await _likeRepo.getLikes(imageId, page: page, limit: limit);

    if (response.status == Status.completed) {
      return response.data as List<LikeModel>;
    } else {
      throw Exception(response.message ?? 'Failed to load likes');
    }
  }

  Future<LikeModel> addLike(String imageId) async {
    final response = await _likeRepo.addLike(imageId);

    if (response.status == Status.completed) {
      return response.data as LikeModel;
    } else {
      throw Exception(response.message ?? 'Failed to add like');
    }
  }

  Future<void> removeLike(String imageId) async {
    final response = await _likeRepo.removeLike(imageId);

    if (response.status != Status.completed) {
      throw Exception(response.message ?? 'Failed to remove like');
    }
  }

  Future<bool> isLiked(String imageId) async {
    final response = await _likeRepo.isLiked(imageId);

    if (response.status == Status.completed) {
      return response.data as bool;
    } else {
      throw Exception(response.message ?? 'Failed to check like status');
    }
  }

  Future<int> getLikeCount(String imageId) async {
    final response = await _likeRepo.getLikeCount(imageId);

    if (response.status == Status.completed) {
      return response.data as int;
    } else {
      throw Exception(response.message ?? 'Failed to get like count');
    }
  }

  Future<List<LikeModel>> getUserLikes() async {
    final response = await _likeRepo.getUserLikes();

    if (response.status == Status.completed) {
      return response.data as List<LikeModel>;
    } else {
      throw Exception(response.message ?? 'Failed to load user likes');
    }
  }
}