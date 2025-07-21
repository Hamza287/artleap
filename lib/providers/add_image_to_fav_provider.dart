import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:Artleap.ai/domain/api_models/user_favourites_model.dart';
import '../domain/api_services/api_response.dart';
import '../domain/base_repo/base_repo.dart';

final favouriteProvider = ChangeNotifierProvider<AddToFavProvider>((ref) => AddToFavProvider());

class AddToFavProvider extends ChangeNotifier with BaseRepo {
  UserFavouritesModel? _userFavourites;
  UserFavouritesModel? get usersFavourites => _userFavourites;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> addToFavourite(String uid, String imageId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final Map<String, dynamic> mapdata = {"userId": uid, "imageId": imageId};
      final ApiResponse response = await addToFav.addImageToFav(mapdata);

      if (response.status == Status.completed) {
        await getUserFav(uid);
      } else {
        _errorMessage = response.message ?? "Failed to add to favorites";
      }
    } catch (e) {
      _errorMessage = "An error occurred while adding to favorites";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUserFav(String uid) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final ApiResponse response = await addToFav.getUserFavrouites(uid);

      if (response.status == Status.completed && response.data != null) {
        _userFavourites = response.data as UserFavouritesModel;
      } else {
        _userFavourites = null;
        _errorMessage = response.message ?? "No favorites found";
      }
    } catch (e) {
      _errorMessage = "An error occurred while fetching favorites";
      _userFavourites = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}