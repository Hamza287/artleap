import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../providers/image_privacy_provider.dart';

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

final selectedPrivacyProvider = StateProvider.autoDispose
    .family<ImagePrivacy, ImagePrivacy?>(
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(context, ref, isSaving),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: _buildPrivacyOptions(selected, initialPrivacy, ref, isSaving),
            ),

            // Actions
            _buildActionButtons(context, ref, selected, initialPrivacy, isSaving),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isSaving) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.privacy_tip, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Privacy Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: Colors.white),
            onPressed: isSaving ? null : () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyOptions(
      ImagePrivacy selected,
      ImagePrivacy currentStatus,
      WidgetRef ref,
      bool isSaving,
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
  }) {
    return Material(
      color: isSelected ? option.color.withOpacity(0.1) : Colors.grey.shade50,
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
                color: isSelected ? option.color : Colors.grey.shade600,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                option.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? option.color : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                option.subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? option.color.withOpacity(0.8) : Colors.grey.shade600,
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
      ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isSaving ? null : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: isSaving ? null : () => _savePrivacy(context, ref),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isSaving
                  ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ) : Text(
                selected == currentStatus ? 'Save' : 'Update',
                style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _savePrivacy(BuildContext context, WidgetRef ref) async {
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
            backgroundColor: Colors.red,
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