import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/prompt_edit_provider.dart';

class UndoRedoButtons extends ConsumerWidget {
  const UndoRedoButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Undo',
                style: AppTextstyle.interBold(
                  fontSize: 18,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outline,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surface,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.undo,
                    color: theme.colorScheme.onSurface,
                  ),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  onPressed: () => ref.read(promptEditProvider.notifier).undo(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Redo',
                style: AppTextstyle.interBold(
                  fontSize: 18,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 3),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outline,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surface,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.redo,
                    color: theme.colorScheme.onSurface,
                  ),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  onPressed: () => ref.read(promptEditProvider.notifier).redo(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}