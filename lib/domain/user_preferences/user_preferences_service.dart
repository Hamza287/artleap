import 'package:Artleap.ai/domain/api_models/user_profile_model.dart';
import 'package:Artleap.ai/widgets/state_widgets/error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'user_preferences_repository.dart';

class UserPreferencesService {
  final Ref ref;
  final UserPreferencesRepository _repository;

  UserPreferencesService(this.ref) : _repository = ref.read(userPreferencesRepositoryProvider);

  Future<bool> acceptPrivacyPolicy({
    required String userId,
    String version = "1.0",
  }) async {
    try {
      if (userId.isEmpty) throw ArgumentError('User ID cannot be empty');

      await _repository.acceptPrivacyPolicy(
        userId: userId,
        version: version,
      );
      return true;
    } on DioException catch (e) {
      final error = ErrorHandler.handleDioError(e);
      debugPrint('User Preferences Error: $error');
      return false;
    } catch (e) {
      final error = ErrorHandler.handleError(e);
      debugPrint('User Preferences Error: $error');
      return false;
    }
  }

  Future<bool> updateUserInterests({
    required String userId,
    required List<String> selected,
    required List<String> categories,
  }) async {
    try {
      if (userId.isEmpty) throw ArgumentError('User ID cannot be empty');

      await _repository.updateUserInterests(
        userId: userId,
        selected: selected,
        categories: categories,
      );
      return true;
    } on DioException catch (e) {
      final error = ErrorHandler.handleDioError(e);
      debugPrint('User Preferences Error: $error');
      return false;
    } catch (e) {
      final error = ErrorHandler.handleError(e);
      debugPrint('User Preferences Error: $error');
      return false;
    }
  }

  Future<User?> getUserPreferences(String userId) async {
    try {
      if (userId.isEmpty) throw ArgumentError('User ID cannot be empty');

      final user = await _repository.getUserPreferences(userId);
      return user;
    } on DioException catch (e) {
      final error = ErrorHandler.handleDioError(e);
      debugPrint('User Preferences Error: $error');
      return null;
    } catch (e) {
      final error = ErrorHandler.handleError(e);
      debugPrint('User Preferences Error: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>?> checkPrivacyPolicyStatus(String userId) async {
    try {
      if (userId.isEmpty) throw ArgumentError('User ID cannot be empty');

      final status = await _repository.checkPrivacyPolicyStatus(userId);
      return status;
    } on DioException catch (e) {
      final error = ErrorHandler.handleDioError(e);
      debugPrint('User Preferences Error: $error');
      return null;
    } catch (e) {
      final error = ErrorHandler.handleError(e);
      debugPrint('User Preferences Error: $error');
      return null;
    }
  }
}

// Provider for UserPreferencesService
final userPreferencesServiceProvider = Provider<UserPreferencesService>((ref) {
  return UserPreferencesService(ref);
});