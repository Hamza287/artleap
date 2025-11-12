import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

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

    if (useShimmer) {
      return _buildShimmerLoading(theme, size);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width * 0.2,
            height: size.width * 0.2,
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: size.height * 0.025),
          Text(
            message ?? 'Loading...',
            style: AppTextstyle.interRegular(
              fontSize: size.width * 0.04,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading(ThemeData theme, Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.04),
      child: Column(
        children: List.generate(
          shimmerItemCount,
              (index) => _buildShimmerItem(theme, size),
        ),
      ),
    );
  }

  Widget _buildShimmerItem(ThemeData theme, Size size) {
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width * 0.12,
            height: size.width * 0.12,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(size.width * 0.04),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * 0.3,
                        height: size.height * 0.02,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: size.height * 0.015),
                      Container(
                        width: double.infinity,
                        height: size.height * 0.016,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: size.height * 0.008),
                      Container(
                        width: size.width * 0.5,
                        height: size.height * 0.016,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Container(
                  width: size.width * 0.2,
                  height: size.height * 0.014,
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