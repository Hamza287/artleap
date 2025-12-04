import 'package:Artleap.ai/providers/prompt_enhancer_provider.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class PromptEnhancerButton extends ConsumerWidget {
  final TextEditingController promptController;
  final VoidCallback? onEnhanced;

  const PromptEnhancerButton({
    super.key,
    required this.promptController,
    this.onEnhanced,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final enhancerState = ref.watch(promptEnhancerProvider);

    return Row(
      children: [
        if (enhancerState.isEnhancedMode && enhancerState.hasEnhancedPrompt)
          _buildRevertButton(context, ref, theme),

        const SizedBox(width: 8),

        if (enhancerState.isLoading)
          _buildLoadingIndicator(theme)
        else
          _buildEnhanceButton(context, ref, theme, enhancerState),
      ],
    );
  }

  Widget _buildEnhanceButton(
      BuildContext context,
      WidgetRef ref,
      ThemeData theme,
      PromptEnhancerProvider enhancerState,
      ) {
    final isOriginalPromptEmpty = promptController.text.trim().isEmpty;
    final isButtonDisabled = isOriginalPromptEmpty || enhancerState.isLoading;

    return Tooltip(
      message: isOriginalPromptEmpty
          ? 'Enter a prompt first'
          : enhancerState.isEnhancedMode
          ? 'Enhanced prompt active'
          : 'Enhance your prompt with AI',
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: isButtonDisabled
            ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
            : enhancerState.isEnhancedMode
            ? theme.colorScheme.primary.withOpacity(0.15)
            : theme.colorScheme.surfaceVariant,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isButtonDisabled ? null : () => _handleEnhanceTap(ref),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: enhancerState.isEnhancedMode
                    ? theme.colorScheme.primary.withOpacity(0.3)
                    : theme.colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  enhancerState.isEnhancedMode
                      ? Icons.auto_awesome
                      : Icons.auto_awesome_outlined,
                  size: 18,
                  color: isButtonDisabled
                      ? theme.colorScheme.onSurface.withOpacity(0.3)
                      : enhancerState.isEnhancedMode
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  enhancerState.isEnhancedMode ? 'Enhanced' : 'Enhance',
                  style: AppTextstyle.interMedium(
                    fontSize: 12,
                    color: isButtonDisabled
                        ? theme.colorScheme.onSurface.withOpacity(0.3)
                        : enhancerState.isEnhancedMode
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRevertButton(
      BuildContext context,
      WidgetRef ref,
      ThemeData theme,
      ) {
    return Tooltip(
      message: 'Revert to original prompt',
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            final enhancer = ref.read(promptEnhancerProvider);
            enhancer.revertToOriginal();
            promptController.text = enhancer.originalPrompt;
            if (onEnhanced != null) onEnhanced!();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.undo,
                  size: 18,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
                Text(
                  'Original',
                  style: AppTextstyle.interMedium(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Enhancing...',
            style: AppTextstyle.interMedium(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleEnhanceTap(WidgetRef ref) async {
    final originalPrompt = promptController.text.trim();

    if (originalPrompt.isEmpty) return;

    try {
      await ref.read(promptEnhancerProvider).enhancePrompt(originalPrompt);

      final enhancer = ref.read(promptEnhancerProvider);

      if (enhancer.isEnhancedMode && enhancer.enhancedPrompt != null) {
        promptController.text = enhancer.enhancedPrompt!;
        if (onEnhanced != null) onEnhanced!();

        // Show success snackbar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Prompt enhanced successfully!',
                style: AppTextstyle.interMedium(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              backgroundColor: theme.colorScheme.primary,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else if (enhancer.errorMessage != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                enhancer.errorMessage!,
                style: AppTextstyle.interMedium(
                  color: theme.colorScheme.onError,
                ),
              ),
              backgroundColor: theme.colorScheme.error,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to enhance prompt: ${e.toString()}',
              style: AppTextstyle.interMedium(
                color: theme.colorScheme.onError,
              ),
            ),
            backgroundColor: theme.colorScheme.error,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  BuildContext get context {
    return navigatorKey.currentContext!;
  }

  ThemeData get theme {
    return Theme.of(context);
  }
}