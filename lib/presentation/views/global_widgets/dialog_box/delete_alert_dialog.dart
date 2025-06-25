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
            Navigator.pop(context, false);
            await ref.read(imageActionsProvider).deleteImage(context,imageId!);
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
