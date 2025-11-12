import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/image_privacy_provider.dart';

final selectedPrivacyProvider = StateProvider.autoDispose.family<ImagePrivacy, ImagePrivacy?>(
      (ref, initial) => initial ?? ImagePrivacy.public,
);

final saveOperationProvider = StateProvider.autoDispose<bool>((ref) => false);

class PrivacySettingsContent extends ConsumerStatefulWidget {
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
  ConsumerState<PrivacySettingsContent> createState() => _PrivacySettingsContentState();
}

class _PrivacySettingsContentState extends ConsumerState<PrivacySettingsContent> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = ref.watch(selectedPrivacyProvider(widget.initialPrivacy));
    final isSaving = ref.watch(saveOperationProvider);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose who can see this image',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          _buildPrivacyOptions(selected, widget.initialPrivacy, isSaving, theme),
          const SizedBox(height: 24),
          _buildActionButtons(selected, widget.initialPrivacy, isSaving, theme),
        ],
      ),
    );
  }

  Widget _buildPrivacyOptions(
      ImagePrivacy selected,
      ImagePrivacy currentStatus,
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

    return Column(
      children: options.map((option) {
        final isSelected = selected == option.value;
        final isCurrent = currentStatus == option.value;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildOptionCard(
            option: option,
            isSelected: isSelected,
            isCurrent: isCurrent,
            isSaving: isSaving,
            theme: theme,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOptionCard({
    required _PrivacyOption option,
    required bool isSelected,
    required bool isCurrent,
    required bool isSaving,
    required ThemeData theme,
  }) {
    return Material(
      color: isSelected ? option.color.withOpacity(0.1) : theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: isSaving ? null : () {
          ref.read(selectedPrivacyProvider(widget.initialPrivacy).notifier).state = option.value;
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? option.color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                option.icon,
                color: isSelected ? option.color : theme.colorScheme.onSurfaceVariant,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? option.color : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      option.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? option.color.withOpacity(0.8) : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: option.color, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
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
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: BorderSide(color: theme.colorScheme.outline),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: isSaving ? null : () => _savePrivacy(selected),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: isSaving
                ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.onPrimary,
              ),
            )
                : Text(
              selected == currentStatus ? 'Save' : 'Update',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _savePrivacy(ImagePrivacy selected) async {
    ref.read(saveOperationProvider.notifier).state = true;

    try {
      await ref.read(imagePrivacyProvider.notifier).setPrivacy(
        imageId: widget.imageId,
        userId: widget.userId,
        privacy: selected,
      );

      // Use a small delay to ensure state is updated before popping
      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        ref.read(saveOperationProvider.notifier).state = false;
        Navigator.of(context).pop(selected);
      }
    } catch (error) {
      if (mounted) {
        ref.read(saveOperationProvider.notifier).state = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update privacy: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
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