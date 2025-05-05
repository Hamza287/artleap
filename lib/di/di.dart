import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    getIt.registerLazySingleton<ApiServices>(
        () => ApiServices(baseUrl: AppConstants.getModelsList),
        instanceName: AppConstants.getModelsList);
    getIt.registerLazySingleton<ApiServices>(
        () => ApiServices(baseUrl: AppConstants.artleapBaseUrl),
        instanceName: AppConstants.artleapBaseUrl);
    getIt.registerLazySingleton<ApiServices>(
        () => ApiServices(baseUrl: AppConstants.generateHighQualityImage),
        instanceName: AppConstants.generateHighQualityImage);
    getIt.registerLazySingleton<ApiServices>(
        () => ApiServices(baseUrl: AppConstants.freePikImageUrl),
        instanceName: AppConstants.freePikImageUrl);
    getIt.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance);
    getIt
        .registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
    // getIt.registerLazySingleton<HomeRepo>(() => HomeRepoImp());
    await getIt.allReady();
  }
}
