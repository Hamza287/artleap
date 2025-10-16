import 'package:flutter/material.dart';

class PremiumUpgradeDialog {
  static void show({
    required BuildContext context,
    String? featureName,
    String? customDescription,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _PremiumUpgradeDialogContent(
        featureName: featureName,
        customDescription: customDescription,
      ),
    );
  }
}

class _PremiumUpgradeDialogContent extends StatelessWidget {
  final String? featureName;
  final String? customDescription;

  const _PremiumUpgradeDialogContent({
    this.featureName,
    this.customDescription,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.amber,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.workspace_premium,
                size: 40,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Premium Feature",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildBenefitItem("Unlock all premium options", context),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Maybe Later",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("choose_plan_screen");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Upgrade Now",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String benefit, BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 18,
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              benefit,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}