import 'package:Artleap.ai/domain/community/providers/comment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
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
    // Focus on text field when bottom sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _commentFocusNode.requestFocus();
    });
  }

  void _postComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final commentText = _commentController.text.trim();

    try {
      await ref.read(commentProvider(widget.imageId).notifier).addComment(commentText);
      _commentController.clear();

      // Scroll to top to show the new comment
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Comment posted successfully'),
          backgroundColor: AppColors.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to post comment: $e'),
          backgroundColor: AppColors.errorColor,
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
          backgroundColor: AppColors.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete comment: $e'),
          backgroundColor: AppColors.errorColor,
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
    final commentsAsync = ref.watch(commentProvider(widget.imageId));
    final hasText = _commentController.text.trim().isNotEmpty;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 32,
            spreadRadius: -8,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Enhanced Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
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
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.grey.shade700,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(width: 16),

                // Title with Count
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comments',
                        style: AppTextstyle.interBold(
                          fontSize: 20,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      commentsAsync.when(
                        data: (comments) => Text(
                          '${comments.length} ${comments.length == 1 ? 'comment' : 'comments'}',
                          style: AppTextstyle.interRegular(
                            fontSize: 14,
                            color: AppColors.hintTextColor,
                          ),
                        ),
                        loading: () => Text(
                          'Loading comments...',
                          style: AppTextstyle.interRegular(
                            fontSize: 14,
                            color: AppColors.hintTextColor,
                          ),
                        ),
                        error: (error, stack) => Text(
                          'Comments',
                          style: AppTextstyle.interRegular(
                            fontSize: 14,
                            color: AppColors.hintTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Refresh Button
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => ref.read(commentProvider(widget.imageId).notifier).refreshComments(),
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),

          // Comments List
          Expanded(
            child: commentsAsync.when(
              data: (comments) {
                if (comments.isEmpty) {
                  return const EmptyCommentsState();
                }

                return RefreshIndicator(
                  backgroundColor: Colors.white,
                  color: AppColors.primaryColor,
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

          // Enhanced Comment Input
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
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
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: _commentFocusNode.hasFocus ? AppColors.primaryColor : Colors.grey.shade300,
                        width: _commentFocusNode.hasFocus ? 2 : 1,
                      ),
                      boxShadow: _commentFocusNode.hasFocus ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.1),
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
                          border: InputBorder.none,
                          hintStyle: AppTextstyle.interRegular(
                            fontSize: 16,
                            color: AppColors.hintTextColor,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        style: AppTextstyle.interRegular(
                          fontSize: 16,
                          color: AppColors.primaryTextColor,
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

                // Enhanced Send Button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: hasText
                        ? LinearGradient(
                      colors: [AppColors.primaryColor, AppColors.secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : LinearGradient(
                      colors: [Colors.grey.shade400, Colors.grey.shade500],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: hasText ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
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
                        color: Colors.white,
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
    );
  }
}