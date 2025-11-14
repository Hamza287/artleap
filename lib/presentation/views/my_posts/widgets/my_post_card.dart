import 'package:cached_network_image/cached_network_image.dart';
import 'post_insights_widget.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class MyPostCard extends ConsumerWidget {
  final dynamic post;
  final VoidCallback onTapLikes;
  final VoidCallback onTapComments;

  const MyPostCard({
    super.key,
    required this.post,
    required this.onTapLikes,
    required this.onTapComments,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final imageId = post.id?.toString() ?? '${post.hashCode}';
    final insightsAsync = ref.watch(myPostsInsightsProvider(imageId));

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPostImage(theme),
          insightsAsync.when(
            data: (insights) {
              return PostInsightsWidget(
                likeCount: insights['likeCount'] ?? 0,
                commentCount: insights['commentCount'] ?? 0,
                onTapLikes: onTapLikes,
                onTapComments: onTapComments,
              );
            },
            loading: () => _buildInsightsShimmer(theme),
            error: (error, stack) => _buildErrorState(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage(ThemeData theme) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: post.imageUrl,
            width: double.infinity,
            height: 320,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                  strokeWidth: 3,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  size: 52,
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Text(
                'Your Post',
                style: AppTextstyle.interMedium(
                  color: theme.colorScheme.primary,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsShimmer(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildShimmerStat(theme),
          _buildShimmerStat(theme),
        ],
      ),
    );
  }

  Widget _buildShimmerStat(ThemeData theme) {
    return Container(
      width: 140,
      height: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          'Unable to load insights',
          style: AppTextstyle.interRegular(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}