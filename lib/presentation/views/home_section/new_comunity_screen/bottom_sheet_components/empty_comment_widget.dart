import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:flutter/material.dart';

class EmptyCommentsState extends StatelessWidget {
  const EmptyCommentsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mode_comment_outlined,
                size: 48,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Comments Yet',
              style: AppTextstyle.interBold(
                fontSize: 20,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Be the first to share your thoughts on this post!',
              style: AppTextstyle.interRegular(
                fontSize: 16,
                color: AppColors.hintTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}