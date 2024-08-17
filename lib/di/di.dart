import 'package:get_it/get_it.dart';
import '../domain/api_services/api_services.dart';
import '../shared/constants/app_constants.dart';

GetIt getIt = GetIt.instance;

class DI {
  static Future<void> initDI() async {
    getIt.registerLazySingleton<ApiServices>(
        () => ApiServices(baseUrl: AppConstants.textToImageUrl),
        instanceName: AppConstants.textToImageUrl);
    getIt.registerLazySingleton<ApiServices>(
        () => ApiServices(baseUrl: AppConstants.imgToimgUrl),
        instanceName: AppConstants.imgToimgUrl);
    getIt.registerLazySingleton<ApiServices>(
        () => ApiServices(baseUrl: AppConstants.otherBaseUrl),
        instanceName: AppConstants.otherBaseUrl);
    getIt.registerLazySingleton<ApiServices>(
        () => ApiServices(baseUrl: AppConstants.reqresBaseUrl),
        instanceName: AppConstants.reqresBaseUrl);
    // getIt.registerLazySingleton<HomeRepo>(() => HomeRepoImp());
    await getIt.allReady();
  }
}
