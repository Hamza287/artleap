import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';
import '../../shared/constants/app_textstyle.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButton;
  final List<Widget> actions;
  final List<Color>? listOfColors;
  final Widget? bottomWidget;
  const CommonAppBar({
    super.key,
    this.title,
    this.actions = const [],
    this.isBackButton = true,
    this.listOfColors,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      shadowColor: AppColors.darkBlue,
      backgroundColor: AppColors.darkBlue,
      flexibleSpace: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            color: AppColors.darkBlue,
            gradient: LinearGradient(
                colors:
                    listOfColors ?? [AppColors.darkBlue, AppColors.darkBlue])),
      ),
      title: Text(
        title!,
        style: AppTextstyle.interMedium(fontSize: 18, color: AppColors.white),
      ),
      centerTitle: true,
      actions: actions,
      bottom: bottomWidget != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(90),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: bottomWidget!,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 100);
}
