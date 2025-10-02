import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment_model.dart';
import '../models/like_model.dart';
import '../repo/comment_repository.dart';
import '../repo/like_repository.dart';
import '../repo/save_repository.dart';
import '../repo_impl/comment_repo_impl.dart';
import '../repo_impl/like_repo_impl.dart';
import '../repo_impl/save_repo_impl.dart';
import 'comment_provider.dart';
import 'like_provider.dart';
import 'save_provider.dart';

final commentRepoProvider = Provider<CommentRepo>((ref) {
  return CommentRepoImpl();
});

final likeRepoProvider = Provider<LikeRepo>((ref) {
  return LikeRepoImpl();
});

final saveRepoProvider = Provider<SaveRepo>((ref) {
  return SaveRepoImpl();
});

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  final commentRepo = ref.watch(commentRepoProvider);
  return CommentRepository(commentRepo: commentRepo);
});

final likeRepositoryProvider = Provider<LikeRepository>((ref) {
  final likeRepo = ref.watch(likeRepoProvider);
  return LikeRepository(likeRepo: likeRepo);
});

final saveRepositoryProvider = Provider<SaveRepository>((ref) {
  final saveRepo = ref.watch(saveRepoProvider);
  return SaveRepository(saveRepo: saveRepo);
});

final commentProvider = StateNotifierProvider.autoDispose
    .family<CommentNotifier, AsyncValue<List<CommentModel>>, String>(
      (ref, imageId) {
    final commentRepository = ref.watch(commentRepositoryProvider);
    return CommentNotifier(commentRepository, imageId);
  },
);

final likeProvider = StateNotifierProvider.autoDispose
    .family<LikeNotifier, AsyncValue<Map<String, bool>>, String>(
      (ref, imageId) {
    final likeRepository = ref.watch(likeRepositoryProvider);
    return LikeNotifier(likeRepository, imageId);
  },
);

final saveProvider = StateNotifierProvider<SaveNotifier, AsyncValue<Map<String, bool>>>(
      (ref) {
    final saveRepository = ref.watch(saveRepositoryProvider);
    return SaveNotifier(saveRepository);
  },
);

final likeCountProvider = FutureProvider.autoDispose.family<int, String>((ref, imageId) async {
  final likeRepository = ref.watch(likeRepositoryProvider);
  try {
    return await likeRepository.getLikeCount(imageId);
  } catch (error) {
    return 0;
  }
});

final commentCountProvider = FutureProvider.autoDispose.family<int, String>((ref, imageId) async {
  final commentRepository = ref.watch(commentRepositoryProvider);
  try {
    return await commentRepository.getCommentCount(imageId);
  } catch (error) {
    return 0;
  }
});

final isPostSavedProvider = Provider.autoDispose.family<bool, String>(
      (ref, imageId) {
    final saveState = ref.watch(saveProvider);

    return saveState.when(
      data: (saveStatus) => saveStatus[imageId] ?? false,
      loading: () => false,
      error: (error, stackTrace) => false,
    );
  },
);

final userCommentsProvider = FutureProvider.autoDispose<List<CommentModel>>((ref) async {
  final commentRepository = ref.watch(commentRepositoryProvider);
  try {
    return await commentRepository.getUserComments();
  } catch (error) {
    return [];
  }
});

final userLikesProvider = FutureProvider.autoDispose<List<LikeModel>>((ref) async {
  final likeRepository = ref.watch(likeRepositoryProvider);
  try {
    return await likeRepository.getUserLikes();
  } catch (error) {
    return [];
  }
});

final savedCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final saveRepository = ref.watch(saveRepositoryProvider);
  try {
    return await saveRepository.getSavedCount();
  } catch (error) {
    return 0;
  }
});

final postStatusProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>(
      (ref, imageId) async {
    final likeCount = await ref.watch(likeCountProvider(imageId).future);
    final commentCount = await ref.watch(commentCountProvider(imageId).future);
    final isSaved = ref.watch(isPostSavedProvider(imageId));

    final likeState = ref.watch(likeProvider(imageId));
    final isLiked = likeState.when(
      data: (likeStatus) => likeStatus[imageId] ?? false,
      loading: () => false,
      error: (error, stackTrace) => false,
    );

    return {
      'likeCount': likeCount,
      'commentCount': commentCount,
      'isLiked': isLiked,
      'isSaved': isSaved,
    };
  },
);