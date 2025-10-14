import 'package:Artleap.ai/domain/community/providers/comment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../../../global_widgets/dialog_box/delete_coment_dialog.dart';
import '../bottom_sheet_components/comment_tile.dart';
import '../bottom_sheet_components/empty_comment_widget.dart';
import '../bottom_sheet_components/error_coment_state.dart';
import '../bottom_sheet_components/loading_coment_state.dart';

class CommentsBottomSheet extends ConsumerStatefulWidget {
  final String imageId;
  final dynamic postImage;

  const CommentsBottomSheet({
    super.key,
    required this.imageId,
    required this.postImage,
  });

  @override
  ConsumerState<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends ConsumerState<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void _postComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final commentText = _commentController.text.trim();

    try {
      await ref.read(commentProvider(widget.imageId).notifier).addComment(commentText);
      _commentController.clear();
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Comment posted successfully'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to post comment: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _deleteComment(String commentId) async {
    try {
      await ref.read(commentProvider(widget.imageId).notifier).deleteComment(commentId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Comment deleted successfully'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete comment: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _showDeleteDialog(String commentId, String commentText) {
    showDialog(
      context: context,
      builder: (context) => DeleteCommentDialog(
        commentId: commentId,
        onDelete: () => _deleteComment(commentId),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final commentsAsync = ref.watch(commentProvider(widget.imageId));
    final hasText = _commentController.text.trim().isNotEmpty;

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.2),
              blurRadius: 32,
              spreadRadius: -8,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Close Button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comments',
                          style: AppTextstyle.interBold(
                            fontSize: 20,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        commentsAsync.when(
                          data: (comments) => Text(
                            '${comments.length} ${comments.length == 1 ? 'comment' : 'comments'}',
                            style: AppTextstyle.interRegular(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          loading: () => Text(
                            'Loading comments...',
                            style: AppTextstyle.interRegular(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          error: (error, stack) => Text(
                            'Comments',
                            style: AppTextstyle.interRegular(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => ref.read(commentProvider(widget.imageId).notifier).refreshComments(),
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: commentsAsync.when(
                data: (comments) {
                  if (comments.isEmpty) {
                    return const EmptyCommentsState();
                  }

                  return RefreshIndicator(
                    backgroundColor: theme.colorScheme.surface,
                    color: theme.colorScheme.primary,
                    onRefresh: () async {
                      await ref.read(commentProvider(widget.imageId).notifier).refreshComments();
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      reverse: false,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return CommentTile(
                          comment: comment,
                          onDelete: () => _showDeleteDialog(comment.id, comment.comment),
                        );
                      },
                    ),
                  );
                },
                loading: () => const LoadingState(),
                error: (error, stack) => ErrorState(
                  error: error,
                  onRetry: () => ref.read(commentProvider(widget.imageId).notifier).refreshComments(),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: _commentFocusNode.hasFocus ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.3),
                          width: _commentFocusNode.hasFocus ? 2 : 1,
                        ),
                        boxShadow: _commentFocusNode.hasFocus ? [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ] : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _commentController,
                          focusNode: _commentFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Share your thoughts...',
                            fillColor: theme.colorScheme.surfaceContainerHighest,
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintStyle: AppTextstyle.interRegular(
                              fontSize: 16,
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          style: AppTextstyle.interRegular(
                            fontSize: 16,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _postComment(),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: hasText
                          ? LinearGradient(
                        colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : LinearGradient(
                        colors: [theme.colorScheme.outline, theme.colorScheme.outline.withOpacity(0.7)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: hasText ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                          spreadRadius: 1,
                        ),
                      ] : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: hasText ? _postComment : null,
                        child: Icon(
                          Icons.send_rounded,
                          color: hasText ? theme.colorScheme.onPrimary : theme.colorScheme.surface,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}