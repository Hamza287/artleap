import 'package:Artleap.ai/providers/image_privacy_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

ImagePrivacy _privacyFromString(String privacy) {
  switch (privacy.toLowerCase()) {
    case 'public':
      return ImagePrivacy.public;
    case 'private':
      return ImagePrivacy.private;
    case 'followers':
      return ImagePrivacy.followers;
    case 'personal':
      return ImagePrivacy.personal;
    default:
      return ImagePrivacy.public;
  }
}

final selectedPrivacyProvider =
    StateProvider.autoDispose.family<ImagePrivacy, ImagePrivacy?>(
  (ref, initial) => initial ?? ImagePrivacy.public,
);

final saveOperationProvider = StateProvider.autoDispose<bool>((ref) => false);

class SetPrivacyDialog extends ConsumerWidget {
  final String imageId;
  final String userId;
  final String initialPrivacyString;
  final VoidCallback? onPrivacyUpdated;

  const SetPrivacyDialog({
    super.key,
    required this.imageId,
    required this.userId,
    required this.initialPrivacyString,
    this.onPrivacyUpdated,
  });

  ImagePrivacy get initialPrivacy {
    return _privacyFromString(initialPrivacyString);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selected = ref.watch(selectedPrivacyProvider(initialPrivacy));
    final isSaving = ref.watch(saveOperationProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.all(screenWidth < 350 ? 16 : 20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.3),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.privacy_tip,
                      color: theme.colorScheme.onPrimary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Privacy Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close,
                        size: 20, color: theme.colorScheme.onPrimary),
                    onPressed:
                        isSaving ? null : () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: _buildPrivacyOptions(
                  selected, initialPrivacy, ref, isSaving, theme),
            ),
            _buildActionButtons(
                context, ref, selected, initialPrivacy, isSaving, theme),
          ],
        ),
      ),
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
          onTap: () => ref
              .read(selectedPrivacyProvider(initialPrivacy).notifier)
              .state = option.value,
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
      color: isSelected
          ? option.color.withOpacity(0.1)
          : theme.colorScheme.surfaceContainerLow,
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
                color: isSelected
                    ? option.color
                    : theme.colorScheme.onSurfaceVariant,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                option.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:
                      isSelected ? option.color : theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                option.subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected
                      ? option.color.withOpacity(0.8)
                      : theme.colorScheme.onSurfaceVariant,
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isSaving ? null : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: theme.colorScheme.outline),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed:
                  isSaving ? null : () => _savePrivacy(context, ref, theme),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
      ),
    );
  }

  Future<void> _savePrivacy(
      BuildContext context, WidgetRef ref, ThemeData theme) async {
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
        onPrivacyUpdated?.call();
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
