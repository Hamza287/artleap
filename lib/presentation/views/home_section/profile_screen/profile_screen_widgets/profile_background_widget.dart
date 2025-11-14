import 'package:Artleap.ai/shared/route_export.dart';


class ProfileBackgroundWidget extends ConsumerWidget {
  final Widget widget;
  const ProfileBackgroundWidget({super.key, required this.widget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.lightIndigo, AppColors.darkIndigo])),
      child: widget,
    );
  }
}
