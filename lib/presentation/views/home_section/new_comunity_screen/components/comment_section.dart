import 'package:Artleap.ai/domain/community/models/comment_model.dart';
import 'package:Artleap.ai/domain/community/providers/providers_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'comment_bottom_sheet.dart';

final commentFocusProvider = StateProvider<bool>((ref) => false);

class CommentsSection extends ConsumerStatefulWidget {
  final dynamic image;

  const CommentsSection({super.key, required this.image});

  @override
  ConsumerState<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends ConsumerState<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _commentFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    ref.read(commentFocusProvider.notifier).state = _commentFocusNode.hasFocus;
  }

  void _postComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final imageId = widget.image.id?.toString() ?? '${widget.image.hashCode}';
    final commentText = _commentController.text.trim();

    try {
      await ref.read(commentProvider(imageId).notifier).addComment(commentText);
      _commentController.clear();
      _commentFocusNode.unfocus();

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comment posted successfully'),
          backgroundColor: AppColors.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  void _showAllComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsBottomSheet(
        imageId: widget.image.id?.toString() ?? '${widget.image.hashCode}',
        postImage: widget.image,
      ),
    );
  }

  void _unfocusOnTapOutside() {
    _commentFocusNode.unfocus();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageId = widget.image.id?.toString() ?? '${widget.image.hashCode}';
    final commentsAsync = ref.watch(commentProvider(imageId));
    final isCommentFocused = ref.watch(commentFocusProvider);

    return GestureDetector(
      onTap: _unfocusOnTapOutside,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isCommentFocused ? 0.1 : 0.05),
              blurRadius: isCommentFocused ? 8 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            commentsAsync.when(
              data: (comments) {
                if (comments.isEmpty) {
                  return const SizedBox.shrink();
                }
                final firstComment = comments.first;
                return Column(
                  children: [
                    _buildCommentTile(firstComment),
                    const SizedBox(height: 12),
                    _buildViewAllCommentsButton(comments.length),
                    const SizedBox(height: 16),
                  ],
                );
              },
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(error),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isCommentFocused ? AppColors.primaryColor : Colors.grey.shade300,
                  width: isCommentFocused ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _commentController,
                        focusNode: _commentFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        style: AppTextstyle.interRegular(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _postComment(),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                  _buildSendButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const SizedBox.shrink();
  }
  Widget _buildErrorState(dynamic error) {
    return const SizedBox.shrink();
  }
  Widget _buildViewAllCommentsButton(int commentCount) {
    return GestureDetector(
      onTap: _showAllComments,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.comment_outlined,
              size: 14,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              'View all $commentCount ${commentCount == 1 ? 'comment' : 'comments'}',
              style: AppTextstyle.interMedium(
                fontSize: 12, // Smaller font
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    final hasText = _commentController.text.trim().isNotEmpty;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: hasText ? AppColors.primaryColor : Colors.grey.shade400,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: hasText ? _postComment : null,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.send_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildCommentTile(CommentModel comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, AppColors.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                comment.userName.substring(0, 1).toUpperCase(),
                style: AppTextstyle.interBold(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.userName,
                        style: AppTextstyle.interBold(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        comment.comment,
                        style: AppTextstyle.interRegular(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    _formatTime(comment.createdAt),
                    style: AppTextstyle.interRegular(
                      fontSize: 10,
                      color: Colors.grey.shade500,
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

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${(difference.inDays / 7).floor()}w ago';
  }
}