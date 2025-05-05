import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:photoroomapp/domain/api_repos_abstract/add_to_fav_repo.dart';

import '../../shared/console.dart';
import '../../shared/constants/app_api_paths.dart';
import '../api_models/user_favourites_model.dart';
import '../api_services/api_response.dart';
import '../api_services/handling_response.dart';

class AddToFavImpl extends AddToFavRepo {
  @override
  Future<ApiResponse> addImageToFav(Map<String, dynamic> data,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.postJson(
          AppApiPaths.togglefavourite, data,
          enableLocalPersistence: enableLocalPersistence);
      print(res.data);
      ApiResponse result = HandlingResponse.returnResponse(res);
      console('REPO : ${result.status}');
      if (result.status == Status.processing) {
        print(result.data);
        print("eeeeeeeeeeeeeeeeeeeeee");
        return ApiResponse.processing("ssssssssssssssss");
      } else if (result.status == Status.completed) {
        print(result.data);
        var data = await Isolate.run(() => res.data);
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }

  @override
  Future<ApiResponse> getUserFavrouites(String uid,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.get(AppApiPaths.getUserFav + uid,
          enableLocalPersistence: enableLocalPersistence);
      print(res.data);
      ApiResponse result = HandlingResponse.returnResponse(res);
      console('REPO : ${result.status}');
      if (result.status == Status.processing) {
        print(result.data);
        print("eeeeeeeeeeeeeeeeeeeeee");
        return ApiResponse.processing("ssssssssssssssss");
      } else if (result.status == Status.completed) {
        print(result.data);
        UserFavouritesModel data =
            await Isolate.run(() => UserFavouritesModel.fromJson(res.data));
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }
}
