import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class ProIconBadge extends StatelessWidget {
  final double size;
  final bool withText;

  const ProIconBadge({
    super.key,
    this.size = 16,
    this.withText = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: withText
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
          : const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFD700),
            Color(0xFFFFA500),
            Color(0xFFFF8C00),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.surface,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            color: Colors.white,
            size: withText ? size - 2 : size,
          ),
          if (withText) ...[
            const SizedBox(width: 4),
            Text(
              'PRO',
              style: AppTextstyle.interMedium(
                fontSize: size - 6,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}