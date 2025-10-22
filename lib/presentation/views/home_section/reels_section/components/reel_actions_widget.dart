import 'package:Artleap.ai/domain/reels/reel_model.dart';
import 'package:Artleap.ai/domain/reels/reel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feather_icons/feather_icons.dart';

class ReelActionsWidget extends ConsumerWidget {
  final ReelModel reel;

  const ReelActionsWidget({super.key, required this.reel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isLiked = ref.watch(reelProvider.select((state) => state.likes[reel.id] ?? false));
    final isMuted = ref.watch(reelProvider.select((state) => state.isMuted));

    return Positioned(
      bottom: 100,
      right: 16,
      child: Column(
        children: [
          _buildProfileAvatar(theme),
          const SizedBox(height: 20),
          _buildActionButton(
            icon: isLiked ? FeatherIcons.heart : FeatherIcons.heart,
            label: _formatCount(reel.likes),
            color: isLiked ? Colors.red : theme.colorScheme.onSurface,
            onTap: () => ref.read(reelProvider.notifier).toggleLike(reel.id),
          ),
          const SizedBox(height: 20),
          _buildActionButton(
            icon: FeatherIcons.messageCircle,
            label: _formatCount(reel.comments),
            color: theme.colorScheme.onSurface,
            onTap: () => _showComingSoonDialog(context),
          ),
          const SizedBox(height: 20),
          _buildActionButton(
            icon: FeatherIcons.send,
            label: _formatCount(reel.shares),
            color: theme.colorScheme.onSurface,
            onTap: () => _showComingSoonDialog(context),
          ),
          const SizedBox(height: 20),
          _buildActionButton(
            icon: isMuted ? FeatherIcons.volumeX : FeatherIcons.volume2,
            label: 'Sound',
            color: theme.colorScheme.onSurface,
            onTap: () => ref.read(reelProvider.notifier).toggleMute(),
          ),
        ],
      ),
    );
  }
  Widget _buildProfileAvatar(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: theme.colorScheme.surface,
            backgroundImage: const NetworkImage('https://example.com/avatar.jpg'),
            child: Icon(
              FeatherIcons.user,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            FeatherIcons.plus,
            size: 14,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(24),
          ),
          child: IconButton(
            icon: Icon(icon),
            color: color,
            iconSize: 24,
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: const Text('This feature will be available in the next update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}