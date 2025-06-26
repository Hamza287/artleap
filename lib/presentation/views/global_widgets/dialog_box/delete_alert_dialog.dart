import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/image_actions_provider.dart';
import '../../../../providers/refresh_provider.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/constants/app_textstyle.dart';

class DeleteAlertDialog extends ConsumerWidget {
  final String? imageId;
  const DeleteAlertDialog({super.key, this.imageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      backgroundColor: AppColors.blue,
      title: const Text('Confirm Delete'),
      content: const Text('Are you sure you want to Delete?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'No',
            style: AppTextstyle.interBold(color: AppColors.white),
          ),
        ),
        TextButton(
          onPressed: () async {
            final success = await ref.read(imageActionsProvider).deleteImage(imageId!);
            if (success) {
              // Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const BottomNavBar()),
              );
            } else {
              Navigator.pop(context); // close the dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Failed to delete image")),
              );
            }
          },
          child: Text(
            'Yes',
            style: AppTextstyle.interBold(color: AppColors.white),
          ),
        ),
      ],
    );
  }
}
