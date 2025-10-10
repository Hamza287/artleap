import 'package:flutter/material.dart';

class ActionButtonsRow extends StatelessWidget {
  const ActionButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            icon: Icons.share_outlined,
            label: 'Share',
            color: theme.colorScheme.primary,
            theme: theme,
          ),
          _buildActionButton(
            icon: Icons.download_outlined,
            label: 'Download',
            color: theme.colorScheme.secondary,
            theme: theme,
          ),
          _buildActionButton(
            icon: Icons.favorite_outline,
            label: 'Like',
            color: theme.colorScheme.error,
            theme: theme,
          ),
          _buildActionButton(
            icon: Icons.delete_outline,
            label: 'Delete',
            color: theme.colorScheme.outline,
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required ThemeData theme,
  }) {
    return Tooltip(
      message: "Coming soon",
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}