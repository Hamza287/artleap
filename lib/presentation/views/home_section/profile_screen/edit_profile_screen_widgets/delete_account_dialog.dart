import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../../shared/navigation/navigation.dart';

class DeleteAccountDialog extends ConsumerWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Warning Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.redColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_forever_rounded,
                size: 36,
                color: AppColors.redColor,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'Delete Account',
              style: AppTextstyle.interBold(
                fontSize: 20,
                color: AppColors.darkIndigo,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              'Are you sure you want to permanently delete your account? '
                  'This action cannot be undone and all your data will be lost.',
              style: AppTextstyle.interRegular(
                fontSize: 16,
                color: AppColors.darkIndigo.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigation.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: AppColors.darkIndigo),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextstyle.interBold(
                        color: AppColors.darkIndigo,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Delete Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(userProfileProvider)
                          .deActivateAccount(UserData.ins.userId!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: ref.watch(userProfileProvider).isLoading
                        ? LoadingAnimationWidget.threeArchedCircle(
                      color: Colors.white,
                      size: 24,
                    )
                        : Text(
                      'Delete Account',
                      style: AppTextstyle.interBold(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}