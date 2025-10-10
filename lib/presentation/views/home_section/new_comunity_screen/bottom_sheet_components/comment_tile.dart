import 'package:Artleap.ai/domain/community/models/comment_model.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentTile extends ConsumerWidget {
  final CommentModel comment;
  final VoidCallback onDelete;

  const CommentTile({
    required this.comment,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isCurrentUser = true;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                comment.userName.substring(0, 1).toUpperCase(),
                style: AppTextstyle.interBold(
                  fontSize: 16,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            comment.userName,
                            style: AppTextstyle.interBold(
                              fontSize: 15,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
                          if (isCurrentUser)
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: onDelete,
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  size: 18,
                                  color: theme.colorScheme.error,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        comment.comment,
                        style: AppTextstyle.interRegular(
                          fontSize: 15,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    _formatTime(comment.createdAt),
                    style: AppTextstyle.interRegular(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${(difference.inDays / 7).floor()}w ago';
  }
}