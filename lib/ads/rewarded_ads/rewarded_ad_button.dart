import 'package:Artleap.ai/ads/rewarded_ads/user_credits_notifier.dart';
import 'package:Artleap.ai/shared/route_export.dart';
import 'rewarded_ad_notifier.dart';

class RewardedAdButton extends ConsumerWidget {
  const RewardedAdButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adState = ref.watch(rewardedAdNotifierProvider);
    final creditsState = ref.watch(userCreditsNotifierProvider);
    final userProfile = ref.watch(userProfileProvider);
    final planName = userProfile.userProfileData?.user.planName ?? 'Free';
    final isFreePlan = planName.toLowerCase() == 'free';

    // Only show button for free plan users
    if (!isFreePlan) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Premium users don\'t see ads',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: adState.canShowAd && !creditsState.isLoading
                ? () => _showAd(ref, context)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: adState.canShowAd
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _buildButtonContent(adState),
          ),
          const SizedBox(height: 12),
          if (adState.status == AdLoadStatus.failed && adState.errorMessage != null)
            Text(
              'Ad loading failed. Please check your connection.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildButtonContent(RewardedAdState adState) {
    if (adState.status == AdLoadStatus.loading) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          SizedBox(width: 12),
          Text('Loading Ad...'),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.play_circle_outline, size: 24),
        const SizedBox(width: 12),
        Text(
          adState.canShowAd ? 'Watch Ad for Credits' : 'Ad Not Available',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Future<void> _showAd(WidgetRef ref, BuildContext context) async {
    final success = await ref.read(rewardedAdNotifierProvider.notifier).showAd(
      onRewardEarned: (coins) {
        ref.read(userCreditsNotifierProvider.notifier).addCredits(coins);

        // Show success message
        appSnackBar(
          "Congratulations!",
          "You earned $coins credits!",
          backgroundColor: Theme.of(context).colorScheme.primary,
        );

        // Close the dialog
        Navigator.of(context).pop();
      },
      onAdDismissed: () {
        debugPrint('Ad dismissed');
      },
      onAdFailedToShow: () {
        appSnackBar(
          "Oops!",
          "Failed to show ad. Please try again.",
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      },
    );

    if (!success) {
      appSnackBar(
        "Ad Not Ready",
        "Please wait a moment and try again.",
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    }
  }
}