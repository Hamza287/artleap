import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment_model.dart';
import '../repo/comment_repository.dart';
import 'providers_setup.dart';

class CommentNotifier extends StateNotifier<AsyncValue<List<CommentModel>>> {
  final CommentRepository _commentRepository;
  final String imageId;
  bool _isDisposed = false;

  CommentNotifier(this._commentRepository, this.imageId)
      : super(const AsyncValue.loading()) {
    loadComments();
  }

  void _safeUpdateState(AsyncValue<List<CommentModel>> newState) {
    if (!_isDisposed) {
      state = newState;
    }
  }

  Future<void> loadComments({int page = 1, int limit = 20, String sort = 'newest'}) async {
    if (_isDisposed) return;

    _safeUpdateState(const AsyncValue.loading());
    try {
      final comments = await _commentRepository.getComments(
        imageId,
        page: page,
        limit: limit,
        sort: sort,
      );
      _safeUpdateState(AsyncValue.data(comments));
    } catch (error, stackTrace) {
      _safeUpdateState(AsyncValue.error(error, stackTrace));
    }
  }

  Future<void> addComment(String comment) async {
    final currentState = state;
    try {
      final newComment = await _commentRepository.addComment(
        imageId: imageId,
        comment: comment,
      );

      if (currentState.hasValue && !_isDisposed) {
        final currentComments = currentState.value ?? [];
        _safeUpdateState(AsyncValue.data([newComment, ...currentComments]));
      } else if (!_isDisposed) {
        await loadComments();
      }
    } catch (error, stackTrace) {
      if (!_isDisposed) {
        _safeUpdateState(AsyncValue.error(error, stackTrace));
        await loadComments();
      }
    }
  }

  Future<void> deleteComment(String commentId) async {
    final currentState = state;
    try {
      await _commentRepository.deleteComment(commentId);

      if (currentState.hasValue && !_isDisposed) {
        final currentComments = currentState.value ?? [];
        _safeUpdateState(AsyncValue.data(
            currentComments.where((comment) => comment.id != commentId).toList()
        ));
      } else if (!_isDisposed) {
        await loadComments();
      }
    } catch (error, stackTrace) {
      if (!_isDisposed) {
        _safeUpdateState(AsyncValue.error(error, stackTrace));
      }
    }
  }

  Future<void> updateComment(String commentId, String newComment) async {
    final currentState = state;
    try {
      final updatedComment = await _commentRepository.updateComment(
        commentId: commentId,
        comment: newComment,
      );

      if (currentState.hasValue && !_isDisposed) {
        final currentComments = currentState.value ?? [];
        final updatedComments = currentComments.map((comment) =>
        comment.id == commentId ? updatedComment : comment
        ).toList();
        _safeUpdateState(AsyncValue.data(updatedComments));
      } else if (!_isDisposed) {
        await loadComments();
      }
    } catch (error, stackTrace) {
      if (!_isDisposed) {
        _safeUpdateState(AsyncValue.error(error, stackTrace));
      }
    }
  }

  Future<void> refreshComments() async {
    if (!_isDisposed) {
      await loadComments();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

final commentProvider = StateNotifierProvider.autoDispose
    .family<CommentNotifier, AsyncValue<List<CommentModel>>, String>(
      (ref, imageId) {
    final commentRepository = ref.watch(commentRepositoryProvider);
    return CommentNotifier(commentRepository, imageId);
  },
);