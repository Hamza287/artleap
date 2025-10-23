import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/home_screen_provider.dart';
import 'package:Artleap.ai/domain/community/providers/providers_setup.dart';
import 'package:Artleap.ai/domain/community/models/comment_model.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';

final myPostsProvider = FutureProvider<List<dynamic>>((ref) async {
  final homeNotifier = ref.read(homeScreenProvider.notifier);
  final currentUserId = UserData.ins.userId;

  if (currentUserId == null) return [];

  await homeNotifier.getUserCreations();

  final homeState = ref.read(homeScreenProvider);
  final allImages = homeState.communityImagesList;
  final myPosts = allImages.where((image) => image.userId == currentUserId).toList();

  return myPosts;
});

final postLikesProvider = FutureProvider.family<List<dynamic>, String>((ref, imageId) async {
  final likeRepository = ref.watch(likeRepositoryProvider);
  try {
    final likes = await likeRepository.getLikes(imageId);
    return likes;
  } catch (e) {
    return [];
  }
});

final myPostsInsightsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, imageId) async {
  final likeCountFuture = ref.read(likeCountProvider(imageId).future);
  final commentCountFuture = ref.read(commentCountProvider(imageId).future);

  final results = await Future.wait([
    likeCountFuture.catchError((_) => 0),
    commentCountFuture.catchError((_) => 0),
  ], eagerError: false);

  final likeCount = results[0];
  final commentCount = results[1];

  final commentsAsync = ref.read(commentProvider(imageId));

  final comments = commentsAsync.maybeWhen(
    data: (comments) => comments.take(1).toList(),
    orElse: () => <CommentModel>[],
  );

  return {
    'likeCount': likeCount,
    'commentCount': commentCount,
    'comments': comments,
  };
});