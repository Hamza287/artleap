import '../api_services/api_response.dart';
import '../base_repo/base.dart';

abstract class FavouritRepo extends Base {
  Future<ApiResponse> getUserFavourites(String uid);
}
