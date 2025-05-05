import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/providers/image_actions_provider.dart';
import 'package:photoroomapp/shared/navigation/navigation.dart';

import '../../../../providers/home_screen_provider.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/constants/app_textstyle.dart';
import '../../../../shared/constants/user_data.dart';

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
          onPressed: () {
            Navigator.pop(context, false);
            ref.read(imageActionsProvider).deleteImage(imageId!);
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
