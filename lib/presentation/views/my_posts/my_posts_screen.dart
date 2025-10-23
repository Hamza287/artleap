import 'package:Artleap.ai/domain/my_posts/my_posts_filter_provider.dart';
import 'package:Artleap.ai/domain/my_posts/my_posts_provider.dart';
import 'package:Artleap.ai/providers/home_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'widgets/comments_list_widget.dart';
import 'widgets/likes_list_widget.dart';
import 'widgets/my_post_card.dart';
import 'widgets/my_posts_shimmer.dart';
import 'widgets/post_filter_chips.dart';

final selectedPostProvider = StateProvider<Map<String, String?>>((ref) => {});

class MyPostsScreen extends ConsumerStatefulWidget {
  static const String routeName = "my-posts";

  const MyPostsScreen({super.key});

  @override
  ConsumerState<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends ConsumerState<MyPostsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(myPostsProvider);
    });
  }

  void _showLikes(String imageId) {
    ref.read(selectedPostProvider.notifier).state = {
      'postId': imageId,
      'viewType': 'likes',
    };
    _showBottomSheet();
  }

  void _showComments(String imageId) {
    ref.read(selectedPostProvider.notifier).state = {
      'postId': imageId,
      'viewType': 'comments',
    };
    _showBottomSheet();
  }

  void _showBottomSheet() {
    final selectedPost = ref.read(selectedPostProvider);
    final imageId = selectedPost['postId'];
    final viewType = selectedPost['viewType'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        if (viewType == 'likes' && imageId != null) {
          return LikesListWidget(imageId: imageId);
        } else if (viewType == 'comments' && imageId != null) {
          return CommentsListWidget(imageId: imageId);
        }
        return const SizedBox();
      },
    ).whenComplete(() {
      ref.read(selectedPostProvider.notifier).state = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final myPostsAsync = ref.watch(myPostsProvider);
    final filteredPosts = ref.watch(filteredMyPostsProvider);
    final sortOrder = ref.watch(postsSortOrderProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'My Posts',
          style: AppTextstyle.interBold(
            color: theme.colorScheme.onSurface,
            fontSize: 22,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildFilterChips(theme, sortOrder),
            Expanded(
              child: myPostsAsync.when(
                data: (posts) {
                  if (posts.isEmpty) {
                    return _buildEmptyState(theme);
                  }
        
                  return RefreshIndicator(
                    backgroundColor: theme.colorScheme.surface,
                    color: theme.colorScheme.primary,
                    onRefresh: () async {
                      ref.invalidate(myPostsProvider);
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = filteredPosts[index];
                        return MyPostCard(
                          key: ValueKey('post_${post.id}_${sortOrder.name}_$index'),
                          post: post,
                          onTapLikes: () => _showLikes(post.id),
                          onTapComments: () => _showComments(post.id),
                        );
                      },
                    ),
                  );
                },
                loading: () => const MyPostsShimmer(),
                error: (error, stack) => _buildErrorState(theme, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme, PostsSortOrder currentSortOrder) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.transparent,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            PostsFilterChip(
              label: 'Newest First',
              isSelected: currentSortOrder == PostsSortOrder.newestFirst,
              onSelected: () => ref.read(postsSortOrderProvider.notifier).state = PostsSortOrder.newestFirst,
            ),
            const SizedBox(width: 8),
            PostsFilterChip(
              label: 'Oldest First',
              isSelected: currentSortOrder == PostsSortOrder.oldestFirst,
              onSelected: () => ref.read(postsSortOrderProvider.notifier).state = PostsSortOrder.oldestFirst,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.brush_outlined,
                size: 48,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Posts Yet',
              style: AppTextstyle.interBold(
                color: theme.colorScheme.onSurface,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Create your first AI masterpiece and share it with the community',
              textAlign: TextAlign.center,
              style: AppTextstyle.interRegular(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, WidgetRef ref) {
    return Center(
      child: Padding(
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
                size: 48,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Unable to Load Posts',
              style: AppTextstyle.interBold(
                color: theme.colorScheme.error,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'There was an issue loading your posts. Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: AppTextstyle.interRegular(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ref.invalidate(myPostsProvider),
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
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}