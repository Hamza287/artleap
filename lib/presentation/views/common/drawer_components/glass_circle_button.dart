import 'package:flutter/material.dart';

class GlassCircleButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onPressed;
  final ThemeData theme;

  const GlassCircleButton({
    required this.icon,
    required this.size,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size * 1.8,
        height: size * 1.8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? theme.colorScheme.surface.withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
          border: Border.all(
            color: isDark
                ? theme.colorScheme.onSurface.withOpacity(0.3)
                : Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: isDark ? theme.colorScheme.onSurface : Colors.white,
            size: size,
          ),
        ),
      ),
    );
  }
}