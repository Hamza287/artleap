import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:Artleap.ai/ads/rewarded_ads/rewarded_ad_repo_provider.dart';
import 'package:Artleap.ai/shared/route_export.dart';

enum AdLoadStatus { idle, loading, loaded, failed }

class RewardedAdState {
  final AdLoadStatus status;
  final int retryCount;
  final bool canShowAd;
  final String? errorMessage;
  final String? debugInfo;

  const RewardedAdState({
    this.status = AdLoadStatus.idle,
    this.retryCount = 0,
    this.canShowAd = false,
    this.errorMessage,
    this.debugInfo,
  });

  RewardedAdState copyWith({
    AdLoadStatus? status,
    int? retryCount,
    bool? canShowAd,
    String? errorMessage,
    String? debugInfo,
  }) {
    return RewardedAdState(
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      canShowAd: canShowAd ?? this.canShowAd,
      errorMessage: errorMessage ?? this.errorMessage,
      debugInfo: debugInfo ?? this.debugInfo,
    );
  }
}

final rewardedAdNotifierProvider =
StateNotifierProvider.autoDispose<RewardedAdNotifier, RewardedAdState>(
      (ref) {
    ref.keepAlive();
    return RewardedAdNotifier(ref);
  },
);


class RewardedAdNotifier extends StateNotifier<RewardedAdState> {
  final Ref ref;
  RewardedAdManager? _manager;
  bool _initialized = false;
  static const String _tag = 'RewardedAdNotifier';

  RewardedAdNotifier(this.ref) : super(const RewardedAdState()) {
    _log('Constructor called');
    _init();
  }

  void _log(String message) {
    if (!mounted) return;
    debugPrint('[$_tag][${DateTime.now().toIso8601String()}] $message');
    state = state.copyWith(debugInfo: message);
  }

  Future<void> _init() async {
    if (_initialized || !mounted) return;
    _initialized = true;
    _manager = RewardedAdManager();
    await loadAd();
  }

  Future<void> loadAd() async {
    if (!mounted) return;
    if (state.status == AdLoadStatus.loading) return;

    state = state.copyWith(
      status: AdLoadStatus.loading,
      debugInfo: 'Loading ad ${state.retryCount + 1}',
    );

    try {
      final remoteConfig = ref.read(remoteConfigProvider);
      final enabled = ref.read(rewardedAdsEnabledProvider);

      final loaded = await _manager!.loadRewardedAd(
        rewardedAdsEnabled: enabled,
        adUnitId: remoteConfig.rewardedAdUnit,
        maxRetryCount: remoteConfig.maxAdRetryCount,
        initializeAds: AdService.instance.initialize,
        isAdsInitialized: AdService.instance.isInitialized,
      );

      if (!mounted) return;

      if (loaded) {
        state = state.copyWith(
          status: AdLoadStatus.loaded,
          canShowAd: true,
          retryCount: 0,
          debugInfo: 'Ad loaded',
        );
      } else {
        _retry();
      }
    } catch (e) {
      if (!mounted) return;
      _retry(error: e.toString());
    }
  }

  void _retry({String? error}) {
    if (!mounted) return;

    state = state.copyWith(
      status: AdLoadStatus.failed,
      canShowAd: false,
      retryCount: state.retryCount + 1,
      errorMessage: error,
      debugInfo: error ?? 'Retry scheduled',
    );

    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) return;
      loadAd();
    });
  }

  Future<bool> showAd({
    required void Function(int coins) onRewardEarned,
    void Function()? onAdDismissed,
    void Function()? onAdFailedToShow,
  }) async {
    if (!mounted) return false;

    if (!state.canShowAd || _manager == null) {
      await loadAd();
      return false;
    }

    final success = await _manager!.showRewardedAd(
      onUserEarnedReward: (coins) async {
        if (!mounted) return;

        onRewardEarned(coins);

        final repo = ref.read(rewardedAdRepoProvider);
        final response = await repo.sendRewardToBackend({
          'coins': coins,
          'userId': UserData.ins.userId,
        });

        if (!mounted) return;

        if (response.status != Status.completed) {
          state = state.copyWith(errorMessage: response.message);
        }
      },
      onAdDismissed: () {
        if (!mounted) return;
        state = state.copyWith(canShowAd: false, debugInfo: 'Ad dismissed');
        onAdDismissed?.call();
        loadAd();
      },
      onAdFailedToShow: (_) {
        if (!mounted) return;
        state = state.copyWith(canShowAd: false, debugInfo: 'Ad failed to show');
        onAdFailedToShow?.call();
        loadAd();
      },
    );

    return success;
  }

  @override
  void dispose() {
    _manager?.dispose();
    super.dispose();
  }
}
