import '../../shared/constants/app_constants.dart';
import '../../di/di.dart';
import '../api_services/api_services.dart';

class Base {
  final ApiServices _textToImageService =
      getIt.get<ApiServices>(instanceName: AppConstants.textToImageUrl);
  ApiServices get textToImageService => _textToImageService;
  final ApiServices _textToHighQualityImageService = getIt.get<ApiServices>(
      instanceName: AppConstants.generateHighQualityImage);
  ApiServices get textToHighQualityImageService =>
      _textToHighQualityImageService;

  final ApiServices _otherApiServices =
      getIt.get<ApiServices>(instanceName: AppConstants.otherBaseUrl);
  ApiServices get otherApiServices => _otherApiServices;

  final ApiServices _artleapApiService =
      getIt.get<ApiServices>(instanceName: AppConstants.artleapBaseUrl);
  ApiServices get artleapApiService => _artleapApiService;

  final ApiServices _reqresApiServices =
      getIt.get<ApiServices>(instanceName: AppConstants.reqresBaseUrl);
  ApiServices get reqresApi => _reqresApiServices;

  final ApiServices _getModelsListService =
      getIt.get<ApiServices>(instanceName: AppConstants.getModelsList);
  ApiServices get getModelsListApi => _getModelsListService;
  final ApiServices _postTextToImage =
      getIt.get<ApiServices>(instanceName: AppConstants.artleapBaseUrl);
  ApiServices get postTextToImage => _postTextToImage;
}
