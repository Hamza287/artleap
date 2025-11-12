import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/image_privacy_provider.dart';

final selectedPrivacyProvider = StateProvider.autoDispose.family<ImagePrivacy, ImagePrivacy?>(
      (ref, initial) => initial ?? ImagePrivacy.public,
);

final saveOperationProvider = StateProvider.autoDispose<bool>((ref) => false);

class PrivacySettingsContent extends ConsumerWidget {
  final String imageId;
  final String userId;
  final ImagePrivacy initialPrivacy;

  const PrivacySettingsContent({
    super.key,
    required this.imageId,
    required this.userId,
    required this.initialPrivacy,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selected = ref.watch(selectedPrivacyProvider(initialPrivacy));
    final isSaving = ref.watch(saveOperationProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPrivacyOptions(selected, initialPrivacy, ref, isSaving, theme),
        const SizedBox(height: 24),
        _buildActionButtons(context, ref, selected, initialPrivacy, isSaving, theme),
      ],
    );
  }

  Widget _buildPrivacyOptions(
      ImagePrivacy selected,
      ImagePrivacy currentStatus,
      WidgetRef ref,
      bool isSaving,
      ThemeData theme,
      ) {
    final options = [
      _PrivacyOption(
        value: ImagePrivacy.public,
        icon: Icons.public,
        title: 'Public',
        subtitle: 'Everyone can see',
        color: Colors.green,
      ),
      _PrivacyOption(
        value: ImagePrivacy.private,
        icon: Icons.lock,
        title: 'Private',
        subtitle: 'Only you can see',
        color: Colors.red,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = selected == option.value;
        final isCurrent = currentStatus == option.value;

        return _buildOptionCard(
          option: option,
          isSelected: isSelected,
          isCurrent: isCurrent,
          isSaving: isSaving,
          onTap: () => ref.read(selectedPrivacyProvider(initialPrivacy).notifier).state = option.value,
          theme: theme,
        );
      },
    );
  }

  Widget _buildOptionCard({
    required _PrivacyOption option,
    required bool isSelected,
    required bool isCurrent,
    required bool isSaving,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return Material(
      color: isSelected ? option.color.withOpacity(0.1) : theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: isSaving ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? option.color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                option.icon,
                color: isSelected ? option.color : theme.colorScheme.onSurfaceVariant,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                option.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? option.color : theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                option.subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? option.color.withOpacity(0.8) : theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              if (isSelected) ...[
                const SizedBox(height: 4),
                Icon(Icons.check_circle, color: option.color, size: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context,
      WidgetRef ref,
      ImagePrivacy selected,
      ImagePrivacy currentStatus,
      bool isSaving,
      ThemeData theme,
      ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isSaving ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: BorderSide(color: theme.colorScheme.outline),
            ),
            child: Text('Cancel', style: TextStyle(color: theme.colorScheme.onSurface)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: isSaving ? null : () => _savePrivacy(context, ref, theme),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: isSaving
                ? SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.onPrimary,
              ),
            )
                : Text(
              selected == currentStatus ? 'Save' : 'Update',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _savePrivacy(BuildContext context, WidgetRef ref, ThemeData theme) async {
    ref.read(saveOperationProvider.notifier).state = true;

    try {
      final newPrivacy = ref.read(selectedPrivacyProvider(initialPrivacy));

      await ref.read(imagePrivacyProvider.notifier).setPrivacy(
        imageId: imageId,
        userId: userId,
        privacy: newPrivacy,
      );

      if (context.mounted) {
        ref.read(saveOperationProvider.notifier).state = false;
        Navigator.of(context).pop(newPrivacy);
      }
    } catch (error) {
      if (context.mounted) {
        ref.read(saveOperationProvider.notifier).state = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update privacy: $error'),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    }
  }
}

class _PrivacyOption {
  final ImagePrivacy value;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _PrivacyOption({
    required this.value,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}