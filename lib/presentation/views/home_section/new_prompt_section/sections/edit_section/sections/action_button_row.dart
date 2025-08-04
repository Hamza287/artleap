import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/prompt_edit_provider.dart';

class ActionButtonsRow extends ConsumerWidget {
  final bool isSmallScreen;

  const ActionButtonsRow({super.key, required this.isSmallScreen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _RoundIconButton(
            icon: Icons.share,
            borderColor: Colors.grey[200]!,
            size: isSmallScreen ? 40 : 50,
            onPressed: () {}, // Implement share functionality
          ),
          _RoundIconButton(
            icon: Icons.download,
            borderColor: Colors.grey[200]!,
            size: isSmallScreen ? 40 : 50,
            onPressed: () {}, // Implement download functionality
          ),
          _RoundIconButton(
            icon: Icons.delete,
            borderColor: Colors.grey[200]!,
            size: isSmallScreen ? 40 : 50,
            onPressed: () => ref.read(promptEditProvider.notifier).removeImage(),
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

  const _RoundIconButton({
    required this.icon,
    this.borderColor = Colors.black54,
    required this.size,
    required this.onPressed,
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
            color: Colors.white,
          ),
          child: Icon(
            icon,
            color: borderColor,
            size: size * 0.6,
          ),
        ),
      ),
    );
  }
}