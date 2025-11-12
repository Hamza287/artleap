import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class CompactErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const CompactErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 36),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.error.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon ?? Icons.error_outline_rounded,
              color: theme.colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Authentication Error',
                    style: AppTextstyle.interMedium(
                      color: theme.colorScheme.onErrorContainer,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: AppTextstyle.interRegular(
                      color: theme.colorScheme.onErrorContainer.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                  // if (onRetry != null) ...[
                  //   const SizedBox(height: 8),
                  //   SizedBox(
                  //     height: 32,
                  //     child: TextButton(
                  //       onPressed: onRetry,
                  //       style: TextButton.styleFrom(
                  //         backgroundColor: theme.colorScheme.error,
                  //         foregroundColor: theme.colorScheme.onError,
                  //         padding: const EdgeInsets.symmetric(horizontal: 16),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(8),
                  //         ),
                  //       ),
                  //       child: Text(
                  //         'Try Again',
                  //         style: AppTextstyle.interMedium(
                  //           fontSize: 12,
                  //           color: theme.colorScheme.onError,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}