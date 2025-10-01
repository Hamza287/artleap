import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../providers/image_privacy_provider.dart';

final selectedPrivacyProvider = StateProvider.autoDispose
    .family<ImagePrivacy, ImagePrivacy?>(
      (ref, initial) => initial ?? ImagePrivacy.public,
);

// Add this provider to track the save operation state
final saveOperationProvider = StateProvider.autoDispose<bool>((ref) => false);

class SetPrivacyDialog extends ConsumerWidget {
  final String imageId;
  final String userId;
  final ImagePrivacy? initial;

  const SetPrivacyDialog({
    super.key,
    required this.imageId,
    required this.userId,
    this.initial,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imagePrivacyProvider);
    final selected = ref.watch(selectedPrivacyProvider(initial));
    final isUpdating = state.isUpdating;
    final isSaving = ref.watch(saveOperationProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine if we should show loading state
    final showLoading = isUpdating || isSaving;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.all(screenWidth < 350 ? 12 : 17),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: screenHeight * 0.4,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Compact Header
            Container(
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
                  Icon(Icons.privacy_tip, color: Colors.white, size: 22),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Privacy Setting',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 20, color: Colors.white),
                    onPressed: showLoading ? null : () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                ],
              ),
            ),

            // Loading overlay or content
            Expanded(
              child: Stack(
                children: [
                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(17),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildCompactOptionsGrid(
                          selected: selected,
                          showLoading: showLoading,
                          ref: ref,
                          screenWidth: screenWidth,
                        ),

                        const SizedBox(height: 16),

                        // Dynamic Info Box
                        _buildInfoBox(selected),
                      ],
                    ),
                  ),

                  // Loading overlay
                  if (showLoading)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Compact Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: showLoading ? null : () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: showLoading ? null : () => _savePrivacy(context, ref),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: showLoading
                          ? SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        'Save',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactOptionsGrid({
    required ImagePrivacy selected,
    required bool showLoading,
    required WidgetRef ref,
    required double screenWidth,
  }) {
    final options = [
      _PrivacyOption(
        value: ImagePrivacy.public,
        icon: Icons.public,
        title: 'Public',
        color: Colors.green,
      ),
      // _PrivacyOption(
      //   value: ImagePrivacy.followers,
      //   icon: Icons.people,
      //   title: 'Followers',
      //   color: Colors.blue,
      // ),
      // _PrivacyOption(
      //   value: ImagePrivacy.personal,
      //   icon: Icons.person,
      //   title: 'Personal',
      //   color: Colors.orange,
      // ),
      _PrivacyOption(
        value: ImagePrivacy.private,
        icon: Icons.lock,
        title: 'Private',
        color: Colors.red,
      ),
    ];

    final crossAxisCount = screenWidth < 350 ? 2 : 4;
    final itemHeight = screenWidth < 350 ? 80.0 : 70.0;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 6,
        mainAxisSpacing: 8,
        childAspectRatio: crossAxisCount == 2 ? 1.8 : 1.0,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return _buildOptionItem(
          option: option,
          isSelected: selected == option.value,
          showLoading: showLoading,
          onTap: () {
            if (!showLoading) {
              ref.read(selectedPrivacyProvider(initial).notifier).state = option.value;
            }
          },
        );
      },
    );
  }

  Widget _buildOptionItem({
    required _PrivacyOption option,
    required bool isSelected,
    required bool showLoading,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected ? option.color.withOpacity(0.1) : Colors.grey.shade50,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                option.icon,
                color: isSelected ? option.color : Colors.grey.shade600,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                option.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? option.color : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              if (isSelected) ...[
                const SizedBox(height: 2),
                Icon(
                  Icons.check_circle,
                  color: option.color,
                  size: 14,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(ImagePrivacy selected) {
    final infoMap = {
      ImagePrivacy.public: 'Visible to everyone',
      ImagePrivacy.followers: 'Only your followers can see',
      ImagePrivacy.personal: 'Only visible to you',
      ImagePrivacy.private: 'Hidden from everyone',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              infoMap[selected] ?? '',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _savePrivacy(BuildContext context, WidgetRef ref) async {
    // Set saving state to true
    ref.read(saveOperationProvider.notifier).state = true;

    try {
      await ref.read(imagePrivacyProvider.notifier).setPrivacy(
        imageId: imageId,
        userId: userId,
        privacy: ref.read(selectedPrivacyProvider(initial)),
      );

      if (context.mounted) {
        // Reset saving state
        ref.read(saveOperationProvider.notifier).state = false;
        Navigator.of(context).pop(ref.read(selectedPrivacyProvider(initial)));
      }
    } catch (error) {
      // Reset saving state even on error
      if (context.mounted) {
        ref.read(saveOperationProvider.notifier).state = false;
        // Optionally show error message
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
  final Color color;

  _PrivacyOption({
    required this.value,
    required this.icon,
    required this.title,
    required this.color,
  });
}