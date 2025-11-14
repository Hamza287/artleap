import 'package:Artleap.ai/shared/route_export.dart';

final textFieldFocusProvider = StateProvider<bool>((ref) => false);

class OthersTextfield extends ConsumerWidget {
  const OthersTextfield({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textController = ref.watch(imageActionsProvider).othersTextController;
    final textLength = textController.text.length;
    final isNearLimit = textLength > 450;
    final isAtLimit = textLength >= 500;
    final hasFocus = ref.watch(textFieldFocusProvider);

    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasFocus
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withOpacity(0.2),
          width: hasFocus ? 2 : 1.5,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              onChanged: (value) {
                ref.read(imageActionsProvider.notifier).notifyListeners();
              },
              onTap: () {
                ref.read(textFieldFocusProvider.notifier).state = true;
              },
              onTapOutside: (event) {
                ref.read(textFieldFocusProvider.notifier).state = false;
              },
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              maxLength: 500,
              style: AppTextstyle.interMedium(
                color: theme.colorScheme.onSurface,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16),
                border: InputBorder.none,
                hintText: "Describe the specific issue you encountered...",
                hintStyle: AppTextstyle.interMedium(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                  fontSize: 16,
                ),
                counterText: "",
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: textLength / 500,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isNearLimit
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Be specific and descriptive",
                      style: AppTextstyle.interMedium(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "$textLength/500",
                      style: AppTextstyle.interMedium(
                        color: isAtLimit
                            ? theme.colorScheme.error
                            : isNearLimit
                            ? theme.colorScheme.error.withOpacity(0.8)
                            : theme.colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: isNearLimit ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}