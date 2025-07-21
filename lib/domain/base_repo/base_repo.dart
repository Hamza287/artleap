
import 'package:Artleap.ai/domain/api_repos_abstract/auth_repo.dart';
import 'package:Artleap.ai/domain/api_repos_abstract/favourite_repo.dart';
import 'package:Artleap.ai/domain/api_repos_abstract/image_actions_repo.dart';
import 'package:Artleap.ai/domain/api_repos_abstract/text_to_image_repo.dart';
import 'package:Artleap.ai/domain/api_repos_abstract/generate_image_repo.dart';
import 'package:Artleap.ai/domain/api_repos_abstract/home_repo.dart';
import 'package:Artleap.ai/domain/api_repos_abstract/img2img_repo.dart';
import 'package:Artleap.ai/domain/api_repos_abstract/load_models_list_repo.dart';
import 'package:Artleap.ai/domain/api_repos_abstract/reqres_repo.dart';
import 'package:Artleap.ai/domain/api_repos_abstract/user_profile_repo.dart';
import 'package:Artleap.ai/domain/api_repos_impl/auth_repo_impl.dart';
import 'package:Artleap.ai/domain/api_repos_impl/favourite_repo_impl.dart';
import 'package:Artleap.ai/domain/api_repos_impl/image_actions_impl.dart';
import 'package:Artleap.ai/domain/api_repos_impl/text_to_image_impl.dart';
import 'package:Artleap.ai/domain/api_repos_impl/generate_image_repo_impl.dart';
import 'package:Artleap.ai/domain/api_repos_impl/home_repo_impl.dart';
import 'package:Artleap.ai/domain/api_repos_impl/img2img_repo_impl.dart';
import 'package:Artleap.ai/domain/api_repos_impl/load_models_list_impl.dart';
import 'package:Artleap.ai/domain/api_repos_impl/reqres_repo_impl.dart';
import 'package:Artleap.ai/domain/api_repos_impl/user_profile_repo_impl.dart';
import '../api_repos_abstract/add_to_fav_repo.dart';
import '../api_repos_impl/add_to_fav_impl.dart';

mixin BaseRepo {
  final ReqResRepo _reqresRepo = ReqResRepoImpl();
  ReqResRepo get reqresRepo => _reqresRepo;
  final GenerateImageRepo _generateImageRepo = GenerateImageImpl();
  GenerateImageRepo get generateImageRepo => _generateImageRepo;
  final GenerateImg2ImgRepo _generateImgToImgRepo = GenerateImg2ImgImpl();
  GenerateImg2ImgRepo get generateImgToImgRepo => _generateImgToImgRepo;
  final LoadModelsListRepo _modelsListRepo = LoadModelsListImpl();
  LoadModelsListRepo get modelListRepo => _modelsListRepo;
  final FavouritRepo _favouriteRepo = FavouriteRepoImpl();
  FavouritRepo get favouriteRepo => _favouriteRepo;
  final AddToFavRepo _addToFav = AddToFavImpl();
  AddToFavRepo get addToFav => _addToFav;
  final HomeRepo _homeRepo = HomeRepoImpl();
  HomeRepo get homeRepo => _homeRepo;
  final AuthRepo _authRepo = AuthRepoImpl();
  AuthRepo get authRepo => _authRepo;
  final ImageActionsRepo _imageActionRepo = ImageActionsImpl();
  ImageActionsRepo get imageActionRepo => _imageActionRepo;
  final FreepikAiGenRepo _freePikRepo = FreepikAiGenImpl();
  FreepikAiGenRepo get freePikRepo => _freePikRepo;
  final UserProfileRepo _userFollowingRepo = UserProfileRepoImpl();
  UserProfileRepo get userFollowingRepo => _userFollowingRepo;
  
}
