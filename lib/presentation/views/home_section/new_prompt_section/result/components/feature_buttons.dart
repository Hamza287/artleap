import 'package:flutter/material.dart';

class FeatureButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback? onPressed;

  const FeatureButton({
    super.key,
    required this.icon,
    required this.label,
    this.isPrimary = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: "Coming soon",
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: isPrimary
              ? [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 20,
            color: isPrimary
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          label: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isPrimary
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isPrimary
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            foregroundColor: isPrimary
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}