import 'package:Artleap.ai/domain/community/providers/providers_setup.dart';
import 'package:Artleap.ai/widgets/common/app_snack_bar.dart';
import 'package:Artleap.ai/shared/theme/app_colors.dart';
import 'package:Artleap.ai/shared/utilities/like_soud_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'comment_bottom_sheet.dart';
import 'comment_section.dart';

final likeAnimationProvider = StateProvider.family<bool, String>((ref, imageId) => false);

class PostActions extends ConsumerWidget {
  final dynamic image;

  const PostActions({super.key, required this.image});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final imageId = image.id?.toString() ?? '${image.hashCode}';

    final likeStatus = ref.watch(likeProvider(imageId));
    final saveStatus = ref.watch(saveProvider);
    final likeCountAsync = ref.watch(likeCountProvider(imageId));
    final commentCountAsync = ref.watch(commentCountProvider(imageId));

    final isLiked = likeStatus.when(
      data: (likeStatus) => likeStatus[imageId] ?? false,
      loading: () => false,
      error: (error, stack) => false,
    );

    final isSaved = saveStatus.when(
      data: (saveStatus) => saveStatus[imageId] ?? false,
      loading: () => false,
      error: (error, stack) => false,
    );

    final likeCount = likeCountAsync.when(
      data: (count) => count,
      loading: () => 0,
      error: (error, stack) => 0,
    );

    final commentCount = commentCountAsync.when(
      data: (count) => count,
      loading: () => 0,
      error: (error, stack) => 0,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _LikeButton(
                imageId: imageId,
                isLiked: isLiked,
                likeCount: likeCount,
                context: context,
                theme: theme,
              ),
              const SizedBox(width: 12),
              _CommentButton(
                imageId: imageId,
                commentCount: commentCount,
                theme: theme,
                image: image,
                context: context,
              ),
              const Spacer(),
              _SaveButton(
                imageId: imageId,
                isSaved: isSaved,
                context: context,
                theme: theme,
              ),
            ],
          ),
          if (likeCount > 0) ...[
            const SizedBox(height: 12),
            _LikeCountText(likeCount: likeCount, theme: theme),
          ],
        ],
      ),
    );
  }
}

class _LikeButton extends ConsumerWidget {
  final String imageId;
  final bool isLiked;
  final int likeCount;
  final BuildContext context;
  final ThemeData theme;

  const _LikeButton({
    required this.imageId,
    required this.isLiked,
    required this.likeCount,
    required this.context,
    required this.theme,
  });

  void _toggleLike(WidgetRef ref) async {
    if (isLiked) {
      SoundService.playUnlikeSound();
    } else {
      SoundService.playLikeSound();
    }

    try {
      await ref.read(likeProvider(imageId).notifier).toggleLike();
      ref.invalidate(likeCountProvider(imageId));
    } catch (e) {
      appSnackBar('Error', 'Failed to update like: $e', backgroundColor:AppColors.red);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _toggleLike(ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isLiked
              ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.error.withOpacity(0.9),
              theme.colorScheme.error.withOpacity(0.7),
            ],
          )
              : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surfaceContainerHighest.withOpacity(0.9),
              theme.colorScheme.surfaceContainerHighest.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            if (isLiked)
              BoxShadow(
                color: theme.colorScheme.error.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            else
              BoxShadow(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
              color: isLiked ? Colors.white : theme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              _formatCount(likeCount),
              style: AppTextstyle.interMedium(
                fontSize: 13,
                color: isLiked ? Colors.white : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }
}

class _CommentButton extends ConsumerWidget {
  final String imageId;
  final int commentCount;
  final ThemeData theme;
  final BuildContext context;
  final dynamic image;

  const _CommentButton({
    required this.imageId,
    required this.commentCount,
    required this.theme,
    required this.context,
    required this.image,
  });

  void _focusCommentField(WidgetRef ref) {
    ref.read(commentFocusProvider.notifier).state = true;
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsBottomSheet(
        imageId: image.id?.toString() ?? '${image.hashCode}',
        postImage: image,
      ),
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showComments(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surfaceContainerHighest.withOpacity(0.9),
              theme.colorScheme.surfaceContainerHighest.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mode_comment_outlined,
              color: theme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              _formatCount(commentCount),
              style: AppTextstyle.interMedium(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }
}

class _SaveButton extends ConsumerWidget {
  final String imageId;
  final bool isSaved;
  final BuildContext context;
  final ThemeData theme;

  const _SaveButton({
    required this.imageId,
    required this.isSaved,
    required this.context,
    required this.theme,
  });

  void _toggleSave(WidgetRef ref) async {
    try {
      await ref.read(saveProvider.notifier).toggleSave(imageId);
     appSnackBar('Alert', "${isSaved ? 'Removed from saved collection' : 'Saved to your collection'}");
    } catch (e) {
      appSnackBar('Error', "Failed to update save: $e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _toggleSave(ref),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: isSaved
              ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.9),
              theme.colorScheme.primary.withOpacity(0.7),
            ],
          )
              : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surfaceVariant.withOpacity(0.9),
              theme.colorScheme.surfaceVariant.withOpacity(0.7),
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            if (isSaved)
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            else
              BoxShadow(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Icon(
          isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
          color: isSaved ? Colors.white : theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
    );
  }
}

class _LikeCountText extends StatelessWidget {
  final int likeCount;
  final ThemeData theme;

  const _LikeCountText({required this.likeCount, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_rounded,
            color: theme.colorScheme.error.withOpacity(0.8),
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            '$likeCount ${likeCount == 1 ? 'like' : 'likes'}',
            style: AppTextstyle.interMedium(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

}