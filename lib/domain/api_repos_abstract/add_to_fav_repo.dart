import '../api_services/api_response.dart';
import '../base_repo/base.dart';

abstract class AddToFavRepo extends Base {
  Future<ApiResponse> addImageToFav(Map<String, dynamic> data,
      {bool enableLocalPersistence = false});

  Future<ApiResponse> getUserFavrouites(String uid,
      {bool enableLocalPersistence = false});
}
