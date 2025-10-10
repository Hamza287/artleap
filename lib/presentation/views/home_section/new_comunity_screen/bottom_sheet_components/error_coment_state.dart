import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const ErrorState({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to Load Comments',
              style: AppTextstyle.interBold(
                fontSize: 18,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: AppTextstyle.interRegular(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                elevation: 0,
              ),
              child: Text(
                'Try Again',
                style: AppTextstyle.interMedium(
                  fontSize: 16,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}