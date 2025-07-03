import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_pic_bottom_sheets/bottom_sheet_widget.dart/common_button.dart';
import 'package:Artleap.ai/shared/shared.dart';

class RowButtons extends ConsumerWidget {
  final VoidCallback? onSendPress;
  final VoidCallback? onCancelPress;
  const RowButtons({super.key, this.onSendPress, this.onCancelPress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReportCommonButton(
            borderColor: AppColors.white,
            title: "Cancel",
            width: 150,
            onpress: onCancelPress,
          ),
          ReportCommonButton(
            width: 150,
            color: AppColors.indigo,
            title: "Send Report",
            icon: Icons.arrow_forward_ios_outlined,
            iconColor: AppColors.white,
            iconsize: 18,
            onpress: onSendPress,
          ),
        ],
      ),
    );
  }
}
