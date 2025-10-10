import 'package:Artleap.ai/domain/community/models/comment_model.dart';
import 'package:Artleap.ai/domain/community/providers/providers_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to post comment: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    final theme = Theme.of(context);
    final imageId = widget.image.id?.toString() ?? '${widget.image.hashCode}';
    final commentsAsync = ref.watch(commentProvider(imageId));
    final isCommentFocused = ref.watch(commentFocusProvider);

    return GestureDetector(
      onTap: _unfocusOnTapOutside,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.05),
              blurRadius: 8,
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
                    _buildCommentTile(firstComment, theme),
                    const SizedBox(height: 12),
                    _buildViewAllCommentsButton(comments.length, theme),
                    const SizedBox(height: 16),
                  ],
                );
              },
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(error),
            ),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isCommentFocused
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withOpacity(0.2),
                  width: isCommentFocused ? 1.5 : 1,
                ),
                boxShadow: isCommentFocused
                    ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _commentController,
                        focusNode: _commentFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          fillColor: theme.colorScheme.surfaceContainerLow,
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 14,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        style: AppTextstyle.interRegular(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: null,

                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _postComment(),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                  _buildSendButton(theme),
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

  Widget _buildViewAllCommentsButton(int commentCount, ThemeData theme) {
    return GestureDetector(
      onTap: _showAllComments,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'View all $commentCount ${commentCount == 1 ? 'comment' : 'comments'}',
              style: AppTextstyle.interMedium(
                fontSize: 13,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton(ThemeData theme) {
    final hasText = _commentController.text.trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.all(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: hasText
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withOpacity(0.1),
          shape: BoxShape.circle,
          boxShadow: hasText
              ? [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: hasText ? _postComment : null,
            child: Icon(
              Icons.send_rounded,
              color: hasText
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface.withOpacity(0.4),
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentTile(CommentModel comment, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                comment.userName.substring(0, 1).toUpperCase(),
                style: AppTextstyle.interBold(
                  fontSize: 14,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Comment Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.userName,
                        style: AppTextstyle.interMedium(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        comment.comment,
                        style: AppTextstyle.interRegular(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    _formatTime(comment.createdAt),
                    style: AppTextstyle.interRegular(
                      fontSize: 11,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
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