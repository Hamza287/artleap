import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/ads/rewarded_ads/rewarded_ad_repo_provider.dart';
import 'package:Artleap.ai/shared/route_export.dart';

enum AdLoadStatus { idle, loading, loaded, failed }

class RewardedAdState {
  final AdLoadStatus status;
  final int retryCount;
  final bool canShowAd;
  final String? errorMessage;

  const RewardedAdState({
    this.status = AdLoadStatus.idle,
    this.retryCount = 0,
    this.canShowAd = false,
    this.errorMessage,
  });

  RewardedAdState copyWith({
    AdLoadStatus? status,
    int? retryCount,
    bool? canShowAd,
    String? errorMessage,
  }) {
    return RewardedAdState(
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      canShowAd: canShowAd ?? this.canShowAd,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final rewardedAdNotifierProvider = StateNotifierProvider.autoDispose<RewardedAdNotifier, RewardedAdState>((ref) {
  return RewardedAdNotifier(ref);
});

class RewardedAdNotifier extends StateNotifier<RewardedAdState> {
  final Ref _ref;
  RewardedAdManager? _adManager;
  bool _isInitialized = false;

  RewardedAdNotifier(this._ref) : super(const RewardedAdState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;

    _isInitialized = true;
    _adManager = RewardedAdManager();

    // Wait for next frame to ensure ref is ready
    await Future.delayed(Duration.zero);
    await loadAd();
  }

  Future<void> loadAd() async {
    if (state.status == AdLoadStatus.loading) return;

    state = state.copyWith(status: AdLoadStatus.loading);

    try {
      final widgetRef = _ref as WidgetRef;
      final loaded = await _adManager?.loadRewardedAd(widgetRef);

      if (loaded ?? false) {
        state = state.copyWith(
          status: AdLoadStatus.loaded,
          canShowAd: true,
          retryCount: 0,
        );
      } else {
        state = state.copyWith(
          status: AdLoadStatus.failed,
          canShowAd: false,
          retryCount: state.retryCount + 1,
        );

        // Auto-retry after 10 seconds if failed
        await Future.delayed(const Duration(seconds: 10));
        loadAd();
      }
    } catch (e) {
      state = state.copyWith(
        status: AdLoadStatus.failed,
        canShowAd: false,
        errorMessage: e.toString(),
        retryCount: state.retryCount + 1,
      );
    }
  }

  Future<bool> showAd({
    required Function(int) onRewardEarned,
    void Function()? onAdDismissed,
    void Function()? onAdFailedToShow,
  }) async {
    if (!state.canShowAd || _adManager == null) {
      await loadAd();
      return false;
    }

    try {
      final widgetRef = _ref as WidgetRef;
      final success = await _adManager!.showRewardedAd(
        ref: widgetRef,
        onUserEarnedReward: (ad, reward) async {
          final coins = reward.amount.toInt();
          onRewardEarned(coins);

          final rewardedAdRepo = widgetRef.read(rewardedAdRepoProvider);
          final response = await rewardedAdRepo.sendRewardToBackend({
            'coins': coins,
            'userId': UserData.ins.userId,
          });

          if (response.status != Status.completed) {
            debugPrint('Failed to send reward to backend: ${response.message}');
          }
        },
        onAdDismissed: () {
          onAdDismissed?.call();
          state = state.copyWith(canShowAd: false);
          loadAd();
        },
        onAdFailedToShow: (error) {
          onAdFailedToShow?.call();
          state = state.copyWith(
            canShowAd: false,
            errorMessage: error.message,
          );
          loadAd();
        },
      );

      return success;
    } catch (e) {
      state = state.copyWith(
        canShowAd: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  @override
  void dispose() {
    _adManager?.dispose();
    _adManager = null;
    _isInitialized = false;
    super.dispose();
  }
}