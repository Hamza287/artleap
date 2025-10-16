import 'package:flutter/material.dart';
import 'user_info_widget.dart';

class ProfileMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final Color? color;
  final VoidCallback? onTap;
  final ThemeData theme;

  const ProfileMenuItem({
    required this.icon,
    required this.title,
    this.color,
    this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    final effectiveColor = color ?? (isDark ? theme.colorScheme.onSurface : Colors.white.withOpacity(0.9));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.005,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconWithTextTile(
                  imageIcon: icon,
                  title: title,
                  titleColor: effectiveColor,
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ],
        ),
      ),
    );
  }
}