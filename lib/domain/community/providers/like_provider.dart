import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repo/like_repository.dart';
import 'providers_setup.dart';

class LikeNotifier extends StateNotifier<AsyncValue<Map<String, bool>>> {
  final LikeRepository _likeRepository;
  final String imageId;
  bool _isDisposed = false;

  LikeNotifier(this._likeRepository, this.imageId)
      : super(const AsyncValue.loading()) {
    _loadLikeStatus();
  }

  void _safeUpdateState(AsyncValue<Map<String, bool>> newState) {
    if (!_isDisposed) {
      state = newState;
    }
  }

  Future<void> _loadLikeStatus() async {
    try {
      final isLiked = await _likeRepository.isLiked(imageId);
      _safeUpdateState(AsyncValue.data({imageId: isLiked}));
    } catch (error, stackTrace) {
      _safeUpdateState(AsyncValue.error(error, stackTrace));
    }
  }

  Future<void> toggleLike() async {
    final currentState = state;

    try {
      if (currentState.hasValue && !_isDisposed) {
        final currentLikeStatus = currentState.value ?? {};
        final currentlyLiked = currentLikeStatus[imageId] ?? false;

        _safeUpdateState(AsyncValue.data({imageId: !currentlyLiked}));

        if (currentlyLiked) {
          await _likeRepository.removeLike(imageId);
        } else {
          await _likeRepository.addLike(imageId);
        }

        _safeUpdateState(AsyncValue.data({imageId: !currentlyLiked}));
      }
    } catch (error, stackTrace) {
      if (!_isDisposed) {
        _safeUpdateState(AsyncValue.error(error, stackTrace));
        await _loadLikeStatus();
      }
    }
  }

  Future<void> refreshLikeStatus() async {
    if (!_isDisposed) {
      await _loadLikeStatus();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

final likeProvider = StateNotifierProvider.autoDispose
    .family<LikeNotifier, AsyncValue<Map<String, bool>>, String>(
      (ref, imageId) {
    final likeRepository = ref.watch(likeRepositoryProvider);
    return LikeNotifier(likeRepository, imageId);
  },
);