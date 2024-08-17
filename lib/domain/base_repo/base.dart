import '../../shared/constants/app_constants.dart';
import '../../di/di.dart';
import '../api_services/api_services.dart';

class Base {
  final ApiServices _textToImageService =
      getIt.get<ApiServices>(instanceName: AppConstants.textToImageUrl);
  ApiServices get textToImageService => _textToImageService;
  final ApiServices _imgToimgService =
      getIt.get<ApiServices>(instanceName: AppConstants.imgToimgUrl);
  ApiServices get imgToimgService => _imgToimgService;

  final ApiServices _otherApiServices =
      getIt.get<ApiServices>(instanceName: AppConstants.otherBaseUrl);
  ApiServices get otherApiServices => _otherApiServices;

  final ApiServices _reqresApiServices =
      getIt.get<ApiServices>(instanceName: AppConstants.reqresBaseUrl);
  ApiServices get reqresApi => _reqresApiServices;

  // final ApiServices _apiServices = ApiServices(baseUrl: AppConstants.baseUrl);
  // ApiServices get apiServices => _apiServices;
  // final ApiServices _otherApiServices =
  //     ApiServices(baseUrl: AppConstants.otherBaseUrl);
  // ApiServices get otherApiServices => _otherApiServices;
}
