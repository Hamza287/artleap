import 'package:Artleap.ai/domain/community/models/comment_model.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
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
    final isCurrentUser = UserData.ins.userId == comment.user;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            _buildUserAvatar(theme, comment.userName),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? theme.colorScheme.primary.withOpacity(0.1)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: isCurrentUser
                          ? const Radius.circular(20)
                          : const Radius.circular(8),
                      bottomRight: isCurrentUser
                          ? const Radius.circular(8)
                          : const Radius.circular(20),
                    ),
                    border: Border.all(
                      color: isCurrentUser
                          ? theme.colorScheme.primary.withOpacity(0.3)
                          : theme.colorScheme.outline.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isCurrentUser
                            ? theme.colorScheme.primary.withOpacity(0.1)
                            : theme.colorScheme.shadow.withOpacity(0.05),
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
                          if (!isCurrentUser)
                            Text(
                              comment.userName,
                              style: AppTextstyle.interBold(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          if (isCurrentUser)
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "You",
                                    style: AppTextstyle.interBold(
                                      fontSize: 12,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
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
                                  size: 16,
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
                          color: isCurrentUser
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: isCurrentUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Text(
                        _formatTime(comment.createdAt),
                        style: AppTextstyle.interRegular(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.check_circle_rounded,
                          size: 12,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isCurrentUser) ...[
            const SizedBox(width: 12),
            _buildUserAvatar(theme, comment.userName, isCurrentUser: true),
          ],
        ],
      ),
    );
  }

  Widget _buildUserAvatar(ThemeData theme, String userName,
      {bool isCurrentUser = false}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isCurrentUser
            ? LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  theme.colorScheme.surfaceContainerHighest,
                  theme.colorScheme.surfaceContainerHighest.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: [
          BoxShadow(
            color: isCurrentUser
                ? theme.colorScheme.primary.withOpacity(0.3)
                : theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: isCurrentUser
            ? Border.all(
                color: theme.colorScheme.primary.withOpacity(0.5),
                width: 2,
              )
            : null,
      ),
      child: Center(
        child: Text(
          userName.substring(0, 1).toUpperCase(),
          style: AppTextstyle.interBold(
            fontSize: 14,
            color: isCurrentUser
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
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
