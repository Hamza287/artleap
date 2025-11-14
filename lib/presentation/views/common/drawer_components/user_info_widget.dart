import 'package:Artleap.ai/shared/route_export.dart';

class IconWithTextTile extends ConsumerWidget {
  final IconData? imageIcon;
  final String? title;
  final Color? titleColor;
  const IconWithTextTile({
    super.key,
    this.imageIcon,
    this.title,
    this.titleColor
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Container(
          width: 25,
          child: Icon(
            imageIcon!,
            size: 20,
            color: titleColor ?? AppColors.white,
          ),
        ),
        12.spaceX,
        Text(
          title!,
          style: AppTextstyle.interMedium(
              fontSize: 13,
              color: titleColor ?? AppColors.white
          ),
        ),
      ],
    );
  }
}