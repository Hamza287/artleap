import 'dart:math';

import 'package:Artleap.ai/domain/community/providers/providers_setup.dart';
import 'package:Artleap.ai/shared/utilities/like_soud_service.dart';
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

class _LikeButtonWithAnimation extends ConsumerStatefulWidget {
  final String imageId;
  final bool isLiked;
  final int likeCount;
  final BuildContext context;

  const _LikeButtonWithAnimation({
    required this.imageId,
    required this.isLiked,
    required this.likeCount,
    required this.context,
  });

  @override
  ConsumerState<_LikeButtonWithAnimation> createState() => _LikeButtonWithAnimationState();
}

class _LikeButtonWithAnimationState extends ConsumerState<_LikeButtonWithAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.fastOutSlowIn),
    ));
  }

  @override
  void didUpdateWidget(_LikeButtonWithAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger animation when like status changes to liked
    if (oldWidget.isLiked != widget.isLiked && widget.isLiked) {
      _animationController.forward(from: 0.0);
    }
  }

  void _toggleLike() async {
    if (widget.isLiked) {
      SoundService.playUnlikeSound();
    } else {
      SoundService.playLikeSound();
      _animationController.forward(from: 0.0);
    }

    try {
      await ref.read(likeProvider(widget.imageId).notifier).toggleLike();
      ref.invalidate(likeCountProvider(widget.imageId));
    } catch (e) {
      ScaffoldMessenger.of(widget.context).showSnackBar(
        SnackBar(
          content: Text('Failed to update like: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLike,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: widget.isLiked ? Colors.red.withOpacity(0.1) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isLiked ? Colors.red : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    widget.isLiked ? Icons.favorite : Icons.favorite_outline,
                    key: ValueKey(widget.isLiked),
                    color: widget.isLiked ? Colors.red : Colors.grey.shade700,
                    size: 20, // Fixed size
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatCount(widget.likeCount),
                  style: AppTextstyle.interMedium(
                    fontSize: 14,
                    color: widget.isLiked ? Colors.red : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          if (_animationController.status == AnimationStatus.forward)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: 56, // Fixed size matching the button
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.red.withOpacity(_pulseAnimation.value * 0.5),
                      width: 2.0 * _pulseAnimation.value,
                    ),
                  ),
                );
              },
            ),
          if (_animationController.status == AnimationStatus.forward)
            ..._buildParticleEffects(),
        ],
      ),
    );
  }

  List<Widget> _buildParticleEffects() {
    return List.generate(6, (index) {
      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final angle = (index * 60.0) * (3.14159 / 180.0);
          final distance = _particleAnimation.value * 20.0; // Shorter distance
          final opacity = 1.0 - _particleAnimation.value;
          final size = 3.0; // Fixed small size

          return Transform.translate(
            offset: Offset(
              cos(angle) * distance,
              sin(angle) * distance,
            ),
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.6),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
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
            Text(
              _formatCount(commentCount),
              style: AppTextstyle.interMedium(
                fontSize: 14,
                color: Colors.grey.shade700,
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
          duration: const Duration(seconds: 2),
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
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSaved ? AppColors.darkBlue.withOpacity(0.1) : Colors.grey.shade100,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSaved ? AppColors.darkBlue : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Icon(
          isSaved ? Icons.bookmark : Icons.bookmark_outline,
          color: isSaved ? AppColors.darkBlue : Colors.grey.shade700,
          size: 22,
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
      child: Text(
        '$likeCount ${likeCount == 1 ? 'like' : 'likes'}',
        style: AppTextstyle.interBold(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }
}