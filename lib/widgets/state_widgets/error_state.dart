import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const ErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: Container(
          padding: EdgeInsets.all(size.width * 0.06),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.errorContainer.withOpacity(0.06),
                theme.colorScheme.errorContainer.withOpacity(0.3),
              ],
            ),
            border: Border.all(
              color: theme.colorScheme.error.withOpacity(0.1),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size.width * 0.2,
                height: size.width * 0.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      theme.colorScheme.error.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon ?? Icons.error_outline_rounded,
                    size: size.width * 0.12,
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.025),
              Text(
                'Something went wrong',
                textAlign: TextAlign.center,
                style: AppTextstyle.interMedium(
                  color: theme.colorScheme.onErrorContainer,
                  fontSize: size.width * 0.045,
                ),
              ),
              SizedBox(height: size.height * 0.012),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextstyle.interRegular(
                  color: theme.colorScheme.onErrorContainer.withOpacity(0.7),
                  fontSize: size.width * 0.035,
                ),
              ),
              if (onRetry != null) ...[
                SizedBox(height: size.height * 0.03),
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.06,
                      vertical: size.height * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Try Again',
                    style: AppTextstyle.interMedium(
                      fontSize: size.width * 0.035,
                      color: theme.colorScheme.onError,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}