import 'dart:isolate';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photoroomapp/domain/api_repos_abstract/favourite_repo.dart';
import 'package:http/http.dart' as http;
import '../../shared/console.dart';
import '../../shared/constants/app_api_paths.dart';
import '../../shared/constants/user_data.dart';
import '../api_services/api_response.dart';
import '../api_services/handling_response.dart';

class FavouriteRepoImpl extends FavouritRepo {
  @override
  Future<ApiResponse> getUserFavourites(String uid,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.get(
          AppApiPaths.getUserProData + uid,
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
}
