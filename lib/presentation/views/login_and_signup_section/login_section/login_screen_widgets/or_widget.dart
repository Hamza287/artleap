import 'package:Artleap.ai/shared/route_export.dart';

class ORwidget extends ConsumerWidget {
  const ORwidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 1,
          width: 100,
          color: AppColors.white,
        ),
        5.spaceX,
        AppText(
          "or login with",
         color: AppColors.white, size: 12,
        ),
        5.spaceX,
        Container(
          height: 1,
          width: 100,
          color: AppColors.white,
        ),
      ],
    );
  }
}
