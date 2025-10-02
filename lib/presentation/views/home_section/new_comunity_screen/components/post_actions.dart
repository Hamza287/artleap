import 'package:Artleap.ai/domain/community/providers/providers_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

import 'comment_section.dart';

final likeAnimationProvider = StateProvider.family<bool, String>((ref, imageId) => false);

class PostActions extends ConsumerWidget {
  final dynamic image;

  const PostActions({super.key, required this.image});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageId = image.id?.toString() ?? '${image.hashCode}';

    final likeStatus = ref.watch(likeProvider(imageId));
    final saveStatus = ref.watch(saveProvider);
    final likeCountAsync = ref.watch(likeCountProvider(imageId));
    final commentCountAsync = ref.watch(commentCountProvider(imageId));
    final isAnimating = ref.watch(likeAnimationProvider(imageId));

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              _LikeButtonWithAnimation(
                imageId: imageId,
                isLiked: isLiked,
                likeCount: likeCount,
                isAnimating: isAnimating,
                context: context,
              ),
              const SizedBox(width: 20),
              _CommentButton(
                imageId: imageId,
                commentCount: commentCount,
              ),
              const Spacer(),
              _SaveButton(
                imageId: imageId,
                isSaved: isSaved,
                context: context,
              ),
            ],
          ),
          if (likeCount > 0) ...[
            const SizedBox(height: 12),
            _LikeCountText(likeCount: likeCount),
          ],
        ],
      ),
    );
  }
}

class _LikeButtonWithAnimation extends ConsumerWidget {
  final String imageId;
  final bool isLiked;
  final int likeCount;
  final bool isAnimating;
  final BuildContext context;
  const _LikeButtonWithAnimation({
    required this.imageId,
    required this.isLiked,
    required this.likeCount,
    required this.isAnimating,
    required this.context,
  });

  void _toggleLike(WidgetRef ref) async {
    ref.read(likeAnimationProvider(imageId).notifier).state = true;

    try {
      await ref.read(likeProvider(imageId).notifier).toggleLike();
      ref.invalidate(likeCountProvider(imageId));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update like: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (context.mounted) {
          ref.read(likeAnimationProvider(imageId).notifier).state = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _toggleLike(ref),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isLiked ? Colors.red.withOpacity(0.1) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isLiked ? Colors.red : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_outline,
                    key: ValueKey(isLiked),
                    color: isLiked ? Colors.red : Colors.grey.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _formatCount(likeCount),
                    key: ValueKey(likeCount),
                    style: AppTextstyle.interMedium(
                      fontSize: 14,
                      color: isLiked ? Colors.red : Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isAnimating)
            Positioned(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.2),
                ),
              ),
            ),
          if (isAnimating && !isLiked)
            Positioned(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                child: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ),
        ],
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

  const _CommentButton({
    required this.imageId,
    required this.commentCount,
  });

  void _focusCommentField(WidgetRef ref) {
    ref.read(commentFocusProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _focusCommentField(ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              color: Colors.grey.shade700,
              size: 20,
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _formatCount(commentCount),
                key: ValueKey(commentCount),
                style: AppTextstyle.interMedium(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
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

  const _SaveButton({
    required this.imageId,
    required this.isSaved,
    required this.context
  });

  void _toggleSave(WidgetRef ref) async {
    try {
      await ref.read(saveProvider.notifier).toggleSave(imageId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isSaved ? 'Removed from saved collection' : 'Saved to your collection'),
          backgroundColor: AppColors.darkBlue,
          behavior: SnackBarBehavior.floating,
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update save: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _toggleSave(ref),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSaved ? AppColors.darkBlue.withOpacity(0.1) : Colors.grey.shade100,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSaved ? AppColors.darkBlue : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_outline,
            key: ValueKey(isSaved),
            color: isSaved ? AppColors.darkBlue : Colors.grey.shade700,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _LikeCountText extends StatelessWidget {
  final int likeCount;

  const _LikeCountText({required this.likeCount});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Text(
          '$likeCount ${likeCount == 1 ? 'like' : 'likes'}',
          key: ValueKey(likeCount),
          style: AppTextstyle.interBold(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}