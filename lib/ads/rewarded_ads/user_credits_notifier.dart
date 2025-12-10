import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/ads/rewarded_ads/rewarded_ad_repo_provider.dart';
import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:Artleap.ai/shared/route_export.dart';

final userCreditsNotifierProvider = StateNotifierProvider<UserCreditsNotifier, UserCreditsState>((ref) {
  return UserCreditsNotifier(ref);
});

class UserCreditsState {
  final int credits;
  final bool isLoading;
  final String? error;

  const UserCreditsState({
    this.credits = 0,
    this.isLoading = false,
    this.error,
  });

  UserCreditsState copyWith({
    int? credits,
    bool? isLoading,
    String? error,
  }) {
    return UserCreditsState(
      credits: credits ?? this.credits,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class UserCreditsNotifier extends StateNotifier<UserCreditsState> {
  final Ref _ref;

  UserCreditsNotifier(this._ref) : super(const UserCreditsState());

  Future<void> addCredits(int coins) async {
    if (coins <= 0) return;

    state = state.copyWith(isLoading: true);

    try {
      state = state.copyWith(
        credits: state.credits + coins,
        isLoading: false,
      );

      // Also update user profile
      // final userProfile = _ref.read(userProfileProvider);
      // if (userProfile.userProfileData != null) {
      //   final updatedUser = userProfile.userProfileData!.user.copyWith(
      //     totalCredits: userProfile.userProfileData!.user.totalCredits + coins,
      //   );
      //   _ref.read(userProfileProvider.notifier).updateCredits(updatedUser.totalCredits);
      // }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchUserCredits() async {
    state = state.copyWith(isLoading: true);

    try {
      final widgetRef = _ref as WidgetRef;
      final rewardedAdRepo = widgetRef.read(rewardedAdRepoProvider);
      final response = await rewardedAdRepo.getUserCredits();

      if (response.status == Status.completed) {
        final credits = response.data?['credits'] ?? 0;
        state = state.copyWith(
          credits: credits,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}