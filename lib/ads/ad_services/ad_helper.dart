import 'package:Artleap.ai/shared/route_export.dart';

class AdHelper {
  static Future<void> showInterstitialAd(WidgetRef ref) async {
    final interstitialManager = ref.read(interstitialAdProvider);
    await interstitialManager.showInterstitialAd(ref);
  }

  static Future<bool> showRewardedAd({
    required WidgetRef ref,
    required OnUserEarnedRewardCallback onUserEarnedReward,
    void Function()? onAdDismissed,
    void Function()? onAdFailed,
    void Function()? onAdShowed,
    void Function()? onAdClicked,
  }) async {
    final rewardedManager = ref.read(rewardedAdProvider);

    final success = await rewardedManager.showRewardedAd(
      ref: ref,
      onUserEarnedReward: onUserEarnedReward,
      onAdDismissed: onAdDismissed,
      onAdFailedToShow: (error) {
        onAdFailed?.call();
      },
      onAdShowed: onAdShowed,
      onAdClicked: onAdClicked,
    );

    return success;
  }

  static Future<bool> showRewardedAdWithSimpleCallback({
    required WidgetRef ref,
    required void Function(RewardItem) onRewardEarned,
    void Function()? onAdDismissed,
    void Function()? onAdFailed,
    void Function()? onAdShowed,
    void Function()? onAdClicked,
  }) async {
    return showRewardedAd(
      ref: ref,
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        onRewardEarned(reward);
      },
      onAdDismissed: onAdDismissed,
      onAdFailed: onAdFailed,
      onAdShowed: onAdShowed,
      onAdClicked: onAdClicked,
    );
  }


  static Future<void> preloadAds(WidgetRef ref) async {
    final interstitialManager = ref.read(interstitialAdProvider);
    final rewardedManager = ref.read(rewardedAdProvider);

    await interstitialManager.loadInterstitialAd(ref);
    await rewardedManager.loadRewardedAd(ref);
  }
}