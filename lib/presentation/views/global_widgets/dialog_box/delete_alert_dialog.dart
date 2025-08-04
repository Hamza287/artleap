import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/image_actions_provider.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/constants/app_textstyle.dart';

class DeleteAlertDialog extends ConsumerWidget {
  final String? imageId;
  const DeleteAlertDialog({super.key, this.imageId});

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
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: AppColors.redColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline_sharp,
                size: 36,
                color: AppColors.redColor,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'Are you sure you want to delete this ?',
              style: AppTextstyle.interBold(
                fontSize: 20,
                color: AppColors.darkBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              'You are deleting this image. This action cant be undone later.',
              style: AppTextstyle.interRegular(
                fontSize: 16,
                color: AppColors.darkBlue.withOpacity(0.8),
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
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: AppColors.darkBlue),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextstyle.interMedium(
                        color: AppColors.darkBlue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Delete Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final success = await ref.read(imageActionsProvider).deleteImage(imageId!);
                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const BottomNavBar()),
                        );
                      } else {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Failed to delete image"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Delete',
                      style: AppTextstyle.interMedium(
                        color: Colors.white,
                        fontSize: 16,
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