import '../../api_services/api_response.dart';
import '../models/save_model.dart';
import '../repo_impl/save_repo_impl.dart';

class SaveRepository {
  final SaveRepo _saveRepo;

  SaveRepository({required SaveRepo saveRepo})
      : _saveRepo = saveRepo;

  Future<List<SaveModel>> getSavedPosts({int page = 1, int limit = 20}) async {
    final response = await _saveRepo.getSavedPosts(page: page, limit: limit);

    if (response.status == Status.completed) {
      return response.data as List<SaveModel>;
    } else {
      throw Exception(response.message ?? 'Failed to load saved posts');
    }
  }

  Future<SaveModel> savePost(String imageId) async {
    final response = await _saveRepo.savePost(imageId);

    if (response.status == Status.completed) {
      return response.data as SaveModel;
    } else {
      throw Exception(response.message ?? 'Failed to save post');
    }
  }

  Future<void> unsavePost(String imageId) async {
    final response = await _saveRepo.unsavePost(imageId);

    if (response.status != Status.completed) {
      throw Exception(response.message ?? 'Failed to unsave post');
    }
  }

  Future<bool> isSaved(String imageId) async {
    final response = await _saveRepo.isSaved(imageId);

    if (response.status == Status.completed) {
      return response.data as bool;
    } else {
      throw Exception(response.message ?? 'Failed to check save status');
    }
  }

  Future<int> getSavedCount() async {
    final response = await _saveRepo.getSavedCount();

    if (response.status == Status.completed) {
      return response.data as int;
    } else {
      throw Exception(response.message ?? 'Failed to get saved count');
    }
  }
}