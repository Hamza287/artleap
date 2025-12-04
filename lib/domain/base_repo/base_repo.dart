import 'package:Artleap.ai/domain/api_repos_abstract/prompt_enhancer_repo.dart';
import 'package:Artleap.ai/domain/api_repos_impl/prompt_enhance_repo_impl.dart';
import 'package:Artleap.ai/shared/route_export.dart';

mixin BaseRepo {
  final ReqResRepo _reqresRepo = ReqResRepoImpl();
  ReqResRepo get reqresRepo => _reqresRepo;

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

  final LeonardoAiGenRepo _leonardoTxt2ImgRepo = LeonardoAiGenImpl();
  LeonardoAiGenRepo get leonardoTxt2ImgRepo => _leonardoTxt2ImgRepo;

  final UserProfileRepo _userFollowingRepo = UserProfileRepoImpl();
  UserProfileRepo get userFollowingRepo => _userFollowingRepo;

  final SubscriptionRepo _subscriptionRepo = SubscriptionRepoImpl();
  SubscriptionRepo get subscriptionRepo => _subscriptionRepo;

  final PromptEnhancerRepo _promptEnhancerRepo = PromptEnhancerImpl();
  PromptEnhancerRepo get promptEnhancerRepo => _promptEnhancerRepo;
}