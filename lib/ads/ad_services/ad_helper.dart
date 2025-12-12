import 'package:Artleap.ai/ads/rewarded_ads/rewarded_ad_notifier.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class AdHelper {
  // Existing methods - keep unchanged
  static Future<void> showInterstitialAd(WidgetRef ref) async {
    final interstitialNotifier = ref.read(interstitialAdProvider);
    await interstitialNotifier.showInterstitialAd();
  }

  static Future<bool> showRewardedAd({
    required WidgetRef ref,
    required void Function(int coins) onRewardEarned,
    void Function()? onAdDismissed,
    void Function()? onAdFailed,
  }) async {
    final notifier = ref.read(rewardedAdNotifierProvider.notifier);

    return notifier.showAd(
      onRewardEarned: onRewardEarned,
      onAdDismissed: onAdDismissed,
      onAdFailedToShow: onAdFailed,
    );
  }

  static Future<bool> showRewardedAdWithSimpleCallback({
    required WidgetRef ref,
    required void Function(RewardItem reward) onRewardEarned,
    void Function()? onAdDismissed,
    void Function()? onAdFailed,
  }) async {
    return showRewardedAd(
      ref: ref,
      onRewardEarned: (coins) {
        onRewardEarned(RewardItem(coins, 'coins'));
      },
      onAdDismissed: onAdDismissed,
      onAdFailed: onAdFailed,
    );
  }

  static Future<void> preloadAds(WidgetRef ref) async {
    final rewardedNotifier = ref.read(rewardedAdNotifierProvider.notifier);
    await rewardedNotifier.loadAd();
  }

  // NEW METHODS - added for enhanced functionality

  /// Preloads rewarded ad when screen opens (enhanced version)
  static Future<void> preloadRewardedAd(WidgetRef ref) async {
    try {
      debugPrint('[AdHelper] Preloading rewarded ad...');

      // Check if ads are enabled
      final remoteConfig = ref.read(remoteConfigProvider);
      final enabled = ref.read(rewardedAdsEnabledProvider);

      if (!enabled) {
        debugPrint('[AdHelper] Ads are disabled in remote config');
        return;
      }

      // Access the ad notifier and trigger preload
      final adNotifier = ref.read(rewardedAdNotifierProvider.notifier);

      // Use a small delay to ensure notifier is fully initialized
      await Future.delayed(const Duration(milliseconds: 500));

      // Manually trigger ad load
      adNotifier.loadAd();

      debugPrint('[AdHelper] Rewarded ad preload initiated');
    } catch (e, stack) {
      debugPrint('[AdHelper] Failed to preload ad: $e\n$stack');
    }
  }

  /// Shows rewarded ad with enhanced callbacks and error handling
  static Future<bool> showEnhancedRewardedAd({
    required WidgetRef ref,
    required BuildContext context,
    required void Function(int coins) onRewardEarned,
    void Function()? onAdDismissed,
    void Function()? onAdFailedToShow,
  }) async {
    final adNotifier = ref.read(rewardedAdNotifierProvider.notifier);

    final success = await adNotifier.showAd(
      onRewardEarned: onRewardEarned,
      onAdDismissed: onAdDismissed,
      onAdFailedToShow: onAdFailedToShow,
    );

    if (!success) {
      _showSnackbar(
        context,
        message: 'Ad is not ready yet. Please wait...',
        backgroundColor: Colors.orange,
      );

      // Try to load ad
      adNotifier.loadAd();
    }

    return success;
  }

  /// Shows a snackbar for ad loading status
  static void showAdLoadingSnackbar(BuildContext context) {
    _showSnackbar(
      context,
      message: 'Ad is loading, please wait...',
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  /// Shows a snackbar for ad errors
  static void showAdErrorSnackbar(BuildContext context, String message) {
    _showSnackbar(
      context,
      message: message,
      backgroundColor: Colors.red,
    );
  }

  /// Shows a snackbar for reward success
  static void showRewardSuccessSnackbar(BuildContext context, int coins) {
    _showSnackbar(
      context,
      message: '🎉 You earned $coins credits!',
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
    );
  }

  /// Refreshes user profile after reward is earned
  static void refreshUserProfileAfterReward(WidgetRef ref) {
    if (UserData.ins.userId != null) {
      ref.read(userProfileProvider.notifier).getUserProfileData(UserData.ins.userId!);
    }
  }

  /// Builds an ad loading indicator widget
  static Widget buildAdLoadingIndicator(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Preparing ads...',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Checks if ad is loaded and ready to show
  static bool isAdReady(WidgetRef ref) {
    final adState = ref.read(rewardedAdNotifierProvider);
    return adState.canShowAd && adState.status == AdLoadStatus.loaded;
  }

  /// Checks if ad is currently loading
  static bool isAdLoading(WidgetRef ref) {
    final adState = ref.read(rewardedAdNotifierProvider);
    return adState.status == AdLoadStatus.loading;
  }

  /// Gets current ad state
  static RewardedAdState getAdState(WidgetRef ref) {
    return ref.read(rewardedAdNotifierProvider);
  }

  /// Helper method to show snackbars
  static void _showSnackbar(
      BuildContext context, {
        required String message,
        required Color backgroundColor,
        Duration duration = const Duration(seconds: 2),
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }
}