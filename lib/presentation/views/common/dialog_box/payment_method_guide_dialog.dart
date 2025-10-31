import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class PaymentMethodGuideDialog extends StatelessWidget {
  final String title;
  final String message;
  final String iconAsset;
  final Color accentColor;

  const PaymentMethodGuideDialog({
    super.key,
    required this.title,
    required this.message,
    required this.iconAsset,
    required this.accentColor,
  });

  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required String paymentMethod,
  }) {
    final (iconAsset, accentColor) = _getDialogConfig(paymentMethod);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PaymentMethodGuideDialog(
          title: title,
          message: message,
          iconAsset: iconAsset,
          accentColor: accentColor,
        );
      },
    );
  }

  static (String, Color) _getDialogConfig(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'google_play':
      case 'google_pay':
        return (
        'assets/icons/payment.png',
        const Color(0xFF4285F4),
        );
      case 'apple':
      case 'appstore':
        return (
        'assets/icons/payment.png',
        Colors.black,
        );
      default:
        return (
        'assets/icons/payment.png',
        Colors.grey,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark
          ? theme.colorScheme.surface
          : theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 16,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isDark
              ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.9),
            ],
          )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Container
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: accentColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Image.asset(
                  iconAsset,
                  width: 40,
                  height: 40,
                  color: accentColor,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.payment,
                      size: 40,
                      color: accentColor,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: AppTextstyle.interBold(
                fontSize: 20,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Text(
                message,
                style: AppTextstyle.interRegular(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  shadowColor: accentColor.withOpacity(0.3),
                ),
                child: Text(
                  'Got It',
                  style: AppTextstyle.interBold(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}