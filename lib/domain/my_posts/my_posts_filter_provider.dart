import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'my_posts_provider.dart';

enum PostsSortOrder {
  newestFirst,
  oldestFirst,
  mostLiked,
}

final postsSortOrderProvider = StateProvider<PostsSortOrder>((ref) => PostsSortOrder.newestFirst);

final filteredMyPostsProvider = Provider<List<dynamic>>((ref) {
  final postsAsync = ref.watch(myPostsProvider);
  final sortOrder = ref.watch(postsSortOrderProvider);

  return postsAsync.maybeWhen(
    data: (posts) {
      final sortedPosts = _sortPosts(posts, sortOrder);
      return sortedPosts;
    },
    orElse: () => [],
  );
});

List<dynamic> _sortPosts(List<dynamic> posts, PostsSortOrder sortOrder) {
  final postsCopy = List<dynamic>.from(posts);

  switch (sortOrder) {
    case PostsSortOrder.newestFirst:
      postsCopy.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case PostsSortOrder.oldestFirst:
      postsCopy.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      break;
    case PostsSortOrder.mostLiked:
    // We'll sort by like count, you might need to adjust this based on your data structure
      postsCopy.sort((a, b) => (b.likeCount ?? 0).compareTo(a.likeCount ?? 0));
      break;
  }

  return postsCopy;
}