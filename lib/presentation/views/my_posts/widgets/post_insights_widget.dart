import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class PostInsightsWidget extends StatelessWidget {
  final int likeCount;
  final int commentCount;
  final VoidCallback onTapLikes;
  final VoidCallback onTapComments;

  const PostInsightsWidget({
    super.key,
    required this.likeCount,
    required this.commentCount,
    required this.onTapLikes,
    required this.onTapComments,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEngagementCard(
            theme: theme,
            icon: Icons.favorite_rounded,
            count: likeCount,
            label: 'Likes',
            color: theme.colorScheme.error,
            onTap: onTapLikes,
          ),
          _buildEngagementCard(
            theme: theme,
            icon: Icons.mode_comment_rounded,
            count: commentCount,
            label: 'Comments',
            color: theme.colorScheme.primary,
            onTap: onTapComments,
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementCard({
    required ThemeData theme,
    required IconData icon,
    required int count,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surfaceContainerLow,
              theme.colorScheme.surfaceContainerLowest,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.15),
                    color.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 26,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _formatCount(count),
              style: AppTextstyle.interBold(
                color: theme.colorScheme.onSurface,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextstyle.interRegular(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'View all details',
              style: AppTextstyle.interMedium(
                color: color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }
}