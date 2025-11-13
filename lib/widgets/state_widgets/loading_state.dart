import 'package:Artleap.ai/widgets/custom_text/custom_text_widget.dart';
import 'package:flutter/material.dart';

class LoadingState extends StatelessWidget {
  final String? message;
  final bool useShimmer;
  final int shimmerItemCount;

  const LoadingState({
    super.key,
    this.message,
    this.useShimmer = false,
    this.shimmerItemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    if (useShimmer) {
      return _buildShimmerLoading(theme, size, isSmallScreen);
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: isSmallScreen ? size.width * 0.15 : size.width * 0.2,
              height: isSmallScreen ? size.width * 0.15 : size.width * 0.2,
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                strokeWidth: isSmallScreen ? 2 : 3,
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : size.height * 0.025),
            AppText(
              message ?? 'Loading...',
              size: isSmallScreen ? 14 : size.width * 0.04,
              weight: FontWeight.w400,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              align: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading(ThemeData theme, Size size, bool isSmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : size.width * 0.04),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          shimmerItemCount,
              (index) => _buildShimmerItem(theme, size, isSmallScreen),
        ),
      ),
    );
  }

  Widget _buildShimmerItem(ThemeData theme, Size size, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : size.height * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isSmallScreen ? 40 : size.width * 0.12,
            height: isSmallScreen ? 40 : size.width * 0.12,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : size.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 12 : size.width * 0.04),
                  constraints: BoxConstraints(
                    minHeight: isSmallScreen ? 60 : 80,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: isSmallScreen ? size.width * 0.4 : size.width * 0.3,
                        height: isSmallScreen ? 14 : size.height * 0.02,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 8 : size.height * 0.015),
                      Container(
                        width: double.infinity,
                        height: isSmallScreen ? 12 : size.height * 0.016,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 6 : size.height * 0.008),
                      Container(
                        width: isSmallScreen ? size.width * 0.6 : size.width * 0.5,
                        height: isSmallScreen ? 12 : size.height * 0.016,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : size.height * 0.01),
                // Timestamp placeholder
                Container(
                  width: isSmallScreen ? 60 : size.width * 0.2,
                  height: isSmallScreen ? 10 : size.height * 0.014,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}