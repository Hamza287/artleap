import 'package:Artleap.ai/domain/api_models/user_profile_model.dart';
import 'package:Artleap.ai/shared/constants/app_api_paths.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api_services/dio_core.dart';
import '../../providers/dio_core_provider.dart';
import '../../shared/app_persistance/app_data.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/notification_utils/error_handler.dart';

class UserPreferencesRepository {
  final DioCore dioCore;
  final Ref ref;

  UserPreferencesRepository({required this.dioCore, required this.ref});

  Future<void> acceptPrivacyPolicy({
    required String userId,
    String version = "1.0",
  }) async {
    try {
      final response = await dioCore.dio.post(
        '${AppConstants.artleapBaseUrl}${AppApiPaths.acceptPrivacyPolicy}',
        data: {
          "userId": userId,
          "version": version,
        },
        options: Options(headers: _getAuthHeader()),
      );

      if (response.statusCode != 200) {
        throw ErrorHandler.handleResponseError(response);
      }
    } on DioException catch (e) {
      print(e.toString());
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      print(e.toString());
      throw ErrorHandler.handleError(e);
    }
  }

  Future<void> updateUserInterests({
    required String userId,
    required List<String> selected,
    required List<String> categories,
  }) async {
    try {
      final response = await dioCore.dio.post(
        '${AppConstants.artleapBaseUrl}${AppApiPaths.updateInterests}',
        data: {
          "userId": userId,
          "selected": selected,
          "categories": categories,
        },
        options: Options(headers: _getAuthHeader()),
      );

      if (response.statusCode != 200) {
        throw ErrorHandler.handleResponseError(response);
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  Future<User> getUserPreferences(String userId) async {
    try {
      final response = await dioCore.dio.get(
        '${AppConstants.artleapBaseUrl}${AppApiPaths.getUserPreferences}$userId',
        options: Options(headers: _getAuthHeader()),
      );

      if (response.statusCode == 200) {
        final userData = response.data['data'];
        return User.fromJson(userData);
      } else {
        throw ErrorHandler.handleResponseError(response);
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  Future<Map<String, dynamic>> checkPrivacyPolicyStatus(String userId) async {
    try {
      final response = await dioCore.dio.get(
        '${AppConstants.artleapBaseUrl}${AppApiPaths.checkPrivacyPolicyStatus}$userId',
        options: Options(headers: _getAuthHeader()),
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw ErrorHandler.handleResponseError(response);
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  Map<String, String> _getAuthHeader() {
    return {
      'Authorization': 'Bearer ${AppData.instance.token}',
    };
  }
}

// Provider for UserPreferencesRepository
final userPreferencesRepositoryProvider = Provider<UserPreferencesRepository>((ref) {
  final dioCore = ref.read(dioCoreProvider);
  return UserPreferencesRepository(dioCore: dioCore, ref: ref);
});