import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment_model.dart';
import '../repo/comment_repository.dart';
import 'providers_setup.dart';

class CommentNotifier extends StateNotifier<AsyncValue<List<CommentModel>>> {
  final CommentRepository _commentRepository;
  final String imageId;

  CommentNotifier(this._commentRepository, this.imageId) : super(const AsyncValue.loading()) {
    loadComments();
  }

  Future<void> loadComments({int page = 1, int limit = 20, String sort = 'newest'}) async {
    state = const AsyncValue.loading();
    try {
      final comments = await _commentRepository.getComments(
        imageId,
        page: page,
        limit: limit,
        sort: sort,
      );
      state = AsyncValue.data(comments);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addComment(String comment) async {
    final currentState = state;
    try {
      final newComment = await _commentRepository.addComment(
        imageId: imageId,
        comment: comment,
      );

      if (currentState.hasValue) {
        final currentComments = currentState.value ?? [];
        state = AsyncValue.data([newComment, ...currentComments]);
      } else {
        // If no current comments, reload to get fresh list
        await loadComments();
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      // Reload comments to ensure consistency
      await loadComments();
    }
  }

  Future<void> deleteComment(String commentId) async {
    final currentState = state;
    try {
      await _commentRepository.deleteComment(commentId);

      if (currentState.hasValue) {
        final currentComments = currentState.value ?? [];
        state = AsyncValue.data(
            currentComments.where((comment) => comment.id != commentId).toList()
        );
      } else {
        await loadComments();
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateComment(String commentId, String newComment) async {
    final currentState = state;
    try {
      final updatedComment = await _commentRepository.updateComment(
        commentId: commentId,
        comment: newComment,
      );

      if (currentState.hasValue) {
        final currentComments = currentState.value ?? [];
        final updatedComments = currentComments.map((comment) =>
        comment.id == commentId ? updatedComment : comment
        ).toList();
        state = AsyncValue.data(updatedComments);
      } else {
        await loadComments();
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshComments() async {
    await loadComments();
  }
}

final commentProvider = StateNotifierProvider.autoDispose
    .family<CommentNotifier, AsyncValue<List<CommentModel>>, String>(
      (ref, imageId) {
    final commentRepository = ref.watch(commentRepositoryProvider);
    return CommentNotifier(commentRepository, imageId);
  },
);