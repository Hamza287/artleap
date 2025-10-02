import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repo/like_repository.dart';
import 'providers_setup.dart';

class LikeNotifier extends StateNotifier<AsyncValue<Map<String, bool>>> {
  final LikeRepository _likeRepository;
  final String imageId;

  LikeNotifier(this._likeRepository, this.imageId)
      : super(const AsyncValue.loading()) {
    _loadLikeStatus();
  }

  Future<void> _loadLikeStatus() async {
    try {
      final isLiked = await _likeRepository.isLiked(imageId);
      state = AsyncValue.data({imageId: isLiked});
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> toggleLike() async {
    final currentState = state;

    try {
      if (currentState.hasValue) {
        final currentLikeStatus = currentState.value ?? {};
        final currentlyLiked = currentLikeStatus[imageId] ?? false;

        // Optimistic update
        state = AsyncValue.data({imageId: !currentlyLiked});

        if (currentlyLiked) {
          // Remove like
          await _likeRepository.removeLike(imageId);
        } else {
          // Add like
          await _likeRepository.addLike(imageId);
        }

        // Final state update
        state = AsyncValue.data({imageId: !currentlyLiked});
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      // Revert the state on error
      await _loadLikeStatus();
    }
  }

  Future<void> refreshLikeStatus() async {
    await _loadLikeStatus();
  }
}

final likeProvider = StateNotifierProvider.autoDispose
    .family<LikeNotifier, AsyncValue<Map<String, bool>>, String>(
      (ref, imageId) {
    final likeRepository = ref.watch(likeRepositoryProvider);
    return LikeNotifier(likeRepository, imageId);
  },
);