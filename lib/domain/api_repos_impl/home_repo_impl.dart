import 'dart:isolate';


import 'package:dio/dio.dart';
import 'package:photoroomapp/domain/api_repos_abstract/home_repo.dart';

import '../../shared/constants/app_api_paths.dart';
import '../../shared/constants/app_constants.dart';
import '../api_models/users_creations_model.dart';
import '../api_services/api_response.dart';
import '../api_services/handling_response.dart';

class HomeRepoImpl extends HomeRepo {
  // @override
  // Future<DocumentSnapshot<Map<String, dynamic>>?> getUsersCreations() async {
  //   try {
  //     DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await firestore
  //         .collection('CommunityCreations')
  //         .doc("usersCreations")
  //         .get();
  //     return documentSnapshot;
  //   } catch (e) {
  //     print('Error fetching images: $e');
  //     return null; // Handle this in the calling function
  //   }
  // }

  @override
  Future<ApiResponse> getUsersCreations(int pageNo) async {
    try {
      Response res = await artleapApiService.get(AppConstants.artleapBaseUrl +
          AppApiPaths.getUsersCreations +
          pageNo.toString());
      print(AppConstants.artleapBaseUrl +
          AppApiPaths.getUsersCreations +
          pageNo.toString());
      ApiResponse result = HandlingResponse.returnResponse(res);
      print(res);
      if (result.status == Status.completed) {
        UsersCreations data =
            await Isolate.run(() => UsersCreations.fromJson(res.data));
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }
}
