import 'package:Artleap.ai/domain/api_models/user_profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'user_preferences_service.dart';

class UserPreferencesNotifier extends StateNotifier<AsyncValue<User?>> {
  final UserPreferencesService _service;
  final String userId;

  UserPreferencesNotifier(this._service, this.userId) : super(const AsyncValue.loading()) {
    loadUserPreferences();
  }

  Future<void> loadUserPreferences() async {
    state = const AsyncValue.loading();
    try {
      final user = await _service.getUserPreferences(userId);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> acceptPrivacyPolicy({String version = "1.0"}) async {
    try {
      final success = await _service.acceptPrivacyPolicy(
        userId: userId,
        version: version,
      );

      if (success) {
        // Update local state
        state.whenData((user) {
          if (user != null) {
            final updatedUser = user.copyWith(
              privacyPolicyAccepted: PrivacyPolicyAcceptance(
                accepted: true,
                acceptedAt: DateTime.now(),
                version: version,
              ),
            );
            state = AsyncValue.data(updatedUser);
          }
        });
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateInterests({
    required List<String> selected,
    required List<String> categories,
  }) async {
    try {
      final success = await _service.updateUserInterests(
        userId: userId,
        selected: selected,
        categories: categories,
      );

      if (success) {
        // Update local state
        state.whenData((user) {
          if (user != null) {
            final updatedUser = user.copyWith(
              interests: UserInterests(
                selected: selected,
                categories: categories,
                lastUpdated: DateTime.now(),
              ),
            );
            state = AsyncValue.data(updatedUser);
          }
        });
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  bool get needsPrivacyPolicyAcceptance {
    return state.when(
      data: (user) => user?.privacyPolicyAccepted?.accepted != true,
      loading: () => true,
      error: (_, __) => true,
    );
  }
}

final userPreferencesProvider = StateNotifierProvider.family<UserPreferencesNotifier, AsyncValue<User?>, String>(
      (ref, userId) => UserPreferencesNotifier(
    ref.read(userPreferencesServiceProvider),
    userId,
  ),
);