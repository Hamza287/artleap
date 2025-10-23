import 'package:Artleap.ai/domain/my_posts/my_posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class LikesListWidget extends ConsumerWidget {
  final String imageId;

  const LikesListWidget({super.key, required this.imageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final likesAsync = ref.watch(postLikesProvider(imageId));

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Likes',
            style: AppTextstyle.interBold(
              color: theme.colorScheme.onSurface,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: likesAsync.when(
              data: (likes) {
                if (likes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_outline_rounded,
                          size: 48,
                          color: theme.colorScheme.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No likes yet',
                          style: AppTextstyle.interMedium(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to like this post!',
                          style: AppTextstyle.interRegular(
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: likes.length,
                  itemBuilder: (context, index) {
                    final like = likes[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.primaryContainer,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _getUserInitial(like),
                                style: AppTextstyle.interBold(
                                  fontSize: 14,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getUserName(like),
                                  style: AppTextstyle.interMedium(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatTime(_getLikeTime(like)),
                                  style: AppTextstyle.interRegular(
                                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.favorite_rounded,
                            color: theme.colorScheme.error,
                            size: 20,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load likes',
                      style: AppTextstyle.interMedium(
                        color: theme.colorScheme.error,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.invalidate(postLikesProvider(imageId)),
                      child: Text(
                        'Try Again',
                        style: AppTextstyle.interMedium(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getUserInitial(dynamic like) {
    if (like is Map) {
      return (like['userName']?.toString().substring(0, 1).toUpperCase() ??
          like['user']?['username']?.toString().substring(0, 1).toUpperCase() ??
          'U');
    }
    return like.userName?.substring(0, 1).toUpperCase() ?? 'U';
  }

  String _getUserName(dynamic like) {
    if (like is Map) {
      return like['userName']?.toString() ??
          like['user']?['username']?.toString() ??
          'Unknown User';
    }
    return like.userName ?? 'Unknown User';
  }

  DateTime _getLikeTime(dynamic like) {
    if (like is Map) {
      return DateTime.parse(like['createdAt']?.toString() ?? DateTime.now().toString());
    }
    return like.createdAt;
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