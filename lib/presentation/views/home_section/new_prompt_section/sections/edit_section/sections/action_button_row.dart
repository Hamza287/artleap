import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/prompt_edit_provider.dart';

class ActionButtonsRow extends ConsumerWidget {
  final bool isSmallScreen;

  const ActionButtonsRow({super.key, required this.isSmallScreen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _RoundIconButton(
            icon: Icons.share,
            borderColor: theme.colorScheme.outline.withOpacity(0.3),
            size: isSmallScreen ? 40 : 50,
            onPressed: () {},
            theme: theme,
          ),
          _RoundIconButton(
            icon: Icons.download,
            borderColor: theme.colorScheme.outline.withOpacity(0.3),
            size: isSmallScreen ? 40 : 50,
            onPressed: () {},
            theme: theme,
          ),
          _RoundIconButton(
            icon: Icons.delete,
            borderColor: theme.colorScheme.outline.withOpacity(0.3),
            size: isSmallScreen ? 40 : 50,
            onPressed: () => ref.read(promptEditProvider.notifier).removeImage(),
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color borderColor;
  final double size;
  final VoidCallback onPressed;
  final ThemeData theme;

  const _RoundIconButton({
    required this.icon,
    required this.borderColor,
    required this.size,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: 110,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surface,
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.onSurface,
            size: size * 0.6,
          ),
        ),
      ),
    );
  }
}