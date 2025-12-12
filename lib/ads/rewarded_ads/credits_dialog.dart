import 'package:Artleap.ai/shared/route_export.dart';

class CreditsDialog extends StatelessWidget {
  final bool isFreePlan;
  final RewardedAdState adState;
  final VoidCallback onWatchAd;
  final VoidCallback onUpgrade;
  final VoidCallback onLater;
  final VoidCallback onLoadAd;
  final bool adDialogShown;
  final Function(bool) onDialogShownChanged;

  const CreditsDialog({
    super.key,
    required this.isFreePlan,
    required this.adState,
    required this.onWatchAd,
    required this.onUpgrade,
    required this.onLater,
    required this.onLoadAd,
    required this.adDialogShown,
    required this.onDialogShownChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isAdReady = adState.canShowAd;
    final isAdLoading = adState.status == AdLoadStatus.loading;

    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        contentPadding: const EdgeInsets.all(24),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.workspace_premium_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Out of Credits',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isFreePlan ? 'Free Plan User' : 'Premium Plan',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            _buildStatusCard(context),
            const SizedBox(height: 20),

            // Options Section
            Text(
              'Get More Credits',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            if (isFreePlan) ...[
              // Ad Option
              _buildAdOptionCard(context,
                  isAdReady: isAdReady, isAdLoading: isAdLoading, onTap: () {
                if (!isAdReady) {
                  _showLoadingSnackbar(context);
                  return;
                }
                onWatchAd();
              }),
              const SizedBox(height: 12),
            ],

            // Upgrade Option
            _buildUpgradeOptionCard(
              context,
              onTap: onUpgrade,
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: [
          _buildActionButtons(
            context,
            isFreePlan: isFreePlan,
            onLater: () {
              onDialogShownChanged(false);
              onLater();
            },
            onUpgrade: onUpgrade,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Current Status',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ve used all your daily credits. Choose an option below to continue creating.',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdOptionCard(
    BuildContext context, {
    required bool isAdReady,
    required bool isAdLoading,
    required VoidCallback onTap,
  }) {
    return _buildOptionCard(
      context,
      title: 'Watch an Ad',
      subtitle: 'Earn free credits instantly',
      icon: Icons.play_circle_fill_rounded,
      iconColor: Colors.blueAccent,
      isActive: isAdReady,
      isLoading: isAdLoading,
      adState: adState,
      onTap: onTap,
    );
  }

  Widget _buildUpgradeOptionCard(BuildContext context,
      {required VoidCallback onTap}) {
    return _buildOptionCard(
      context,
      title: 'Upgrade to Premium',
      subtitle: 'Unlimited credits & premium features',
      icon: Icons.stars_rounded,
      iconColor: Colors.amber,
      isActive: true,
      onTap: onTap,
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool isActive,
    bool isLoading = false,
    RewardedAdState? adState,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isActive ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceVariant
                .withOpacity(isActive ? 0.5 : 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                  : Theme.of(context).colorScheme.outline.withOpacity(0.1),
              width: isActive ? 1.5 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 24,
                    color: isActive ? iconColor : iconColor.withOpacity(0.5),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isActive
                            ? Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7)
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.4),
                      ),
                    ),
                    if (adState != null && !isActive && !isLoading)
                      const SizedBox(height: 4),
                    if (adState != null && !isActive && !isLoading)
                      Text(
                        'Ad not available - retrying...',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.orange,
                        ),
                      ),
                  ],
                ),
              ),
              if (isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              else if (isActive)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context, {
    required bool isFreePlan,
    required VoidCallback onLater,
    required VoidCallback onUpgrade,
  }) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onLater,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: Text(
              'Maybe Later',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        if (!isFreePlan)
          Expanded(
            child: ElevatedButton(
              onPressed: onUpgrade,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
              child: Text(
                'Upgrade Now',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showLoadingSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loading ad, please wait...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Helper function to show credits dialog
void showCreditsDialog({
  required BuildContext context,
  required WidgetRef ref,
  required bool isFreePlan,
  required RewardedAdState adState,
  required VoidCallback onWatchAd,
  required VoidCallback onUpgrade,
  required VoidCallback onLater,
  required VoidCallback onLoadAd,
  required bool adDialogShown,
  required Function(bool) onDialogShownChanged,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => CreditsDialog(
      isFreePlan: isFreePlan,
      adState: adState,
      onWatchAd: onWatchAd,
      onUpgrade: onUpgrade,
      onLater: onLater,
      onLoadAd: onLoadAd,
      adDialogShown: adDialogShown,
      onDialogShownChanged: onDialogShownChanged,
    ),
  );
}
