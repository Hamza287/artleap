import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class SavedImagesErrorState extends StatelessWidget {
  final dynamic error;
  final VoidCallback onRetry;

  const SavedImagesErrorState({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
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
            'Something went wrong',
            style: AppTextstyle.interBold(
              fontSize: 20,
              color: theme.colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'We couldn\'t load your saved images. Please try again.',
            textAlign: TextAlign.center,
            style: AppTextstyle.interRegular(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Try Again',
              style: AppTextstyle.interMedium(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}