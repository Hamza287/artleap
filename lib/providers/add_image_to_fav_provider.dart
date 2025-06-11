import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:Artleap.ai/domain/api_models/user_favourites_model.dart';
import '../domain/api_services/api_response.dart';
import '../domain/base_repo/base_repo.dart';

final favouriteProvider =
    ChangeNotifierProvider<AddToFavProvider>((ref) => AddToFavProvider());

class AddToFavProvider extends ChangeNotifier with BaseRepo {
  UserFavouritesModel? _userFavourites;
  UserFavouritesModel? get usersFavourites => _userFavourites;

  addToFavourite(String uid, String imageId) async {
    Map<String, dynamic> mapdata = {"userId": uid, "imageId": imageId};
    ApiResponse generateImageRes = await addToFav.addImageToFav(mapdata);
    if (generateImageRes.status == Status.completed) {
      getUserFav(uid);
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      // getUserFav(uid);
      // var generatedData = generateImageRes.data as txtToImg.TextToImageModel;
      // _generatedTextToImageData.addAll(generatedData.images);
    } else {}
    notifyListeners();
  }

  getUserFav(
    String uid,
  ) async {
    ApiResponse generateImageRes = await addToFav.getUserFavrouites(uid);
    _userFavourites = generateImageRes.data as UserFavouritesModel;
    if (generateImageRes.status == Status.completed) {
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    } else {}
    notifyListeners();
  }
}
