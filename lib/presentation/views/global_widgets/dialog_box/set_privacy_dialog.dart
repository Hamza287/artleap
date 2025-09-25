import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../providers/image_privacy_provider.dart';

final selectedPrivacyProvider = StateProvider.autoDispose
    .family<ImagePrivacy, ImagePrivacy?>(
      (ref, initial) => initial ?? ImagePrivacy.public,
);

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

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Set Privacy',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // Privacy Options
            RadioListTile<ImagePrivacy>(
              value: ImagePrivacy.public,
              groupValue: selected,
              onChanged: state.isUpdating
                  ? null
                  : (v) => ref
                  .read(selectedPrivacyProvider(initial).notifier)
                  .state = v!,
              title: const Text('Public'),
            ),
            RadioListTile<ImagePrivacy>(
              value: ImagePrivacy.private,
              groupValue: selected,
              onChanged: state.isUpdating
                  ? null
                  : (v) => ref
                  .read(selectedPrivacyProvider(initial).notifier)
                  .state = v!,
              title: const Text('Private'),
            ),
            RadioListTile<ImagePrivacy>(
              value: ImagePrivacy.followers,
              groupValue: selected,
              onChanged: state.isUpdating
                  ? null
                  : (v) => ref
                  .read(selectedPrivacyProvider(initial).notifier)
                  .state = v!,
              title: const Text('Followers'),
            ),
            RadioListTile<ImagePrivacy>(
              value: ImagePrivacy.personal,
              groupValue: selected,
              onChanged: state.isUpdating
                  ? null
                  : (v) => ref
                  .read(selectedPrivacyProvider(initial).notifier)
                  .state = v!,
              title: const Text('Personal'),
            ),

            const SizedBox(height: 8),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.isUpdating
                    ? null
                    : () async {
                  await ref
                      .read(imagePrivacyProvider.notifier)
                      .setPrivacy(
                    imageId: imageId,
                    userId: userId,
                    privacy: ref.read(
                      selectedPrivacyProvider(initial),
                    ),
                  );

                  if (context.mounted) {
                    Navigator.of(context).pop(
                      ref.read(selectedPrivacyProvider(initial)),
                    );
                  }
                },
                child: state.isUpdating
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
