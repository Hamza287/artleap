import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/shared.dart';

class PictureInfoWidget extends ConsumerWidget {
  final String? styleName;
  final String? createdAt;
  const PictureInfoWidget({super.key, this.styleName, this.createdAt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 320,
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          10.spaceY,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InfoText(
                title: "Art Style",
                info: styleName,
              ),
              20.spaceX,
              InfoText(
                title: "Created on",
                info: createdAt ?? "Unknown",
              ),
            ],
          ),
          10.spaceY,
          _primaryActionButton(
            icon: Icons.open_in_full,
            label: "Generate Prompt",
            onPressed: () {},
          ),
          _primaryActionButton(
            icon: Icons.open_in_full,
            label: "Upscale",
            onPressed: () {},
          ),
          _primaryActionButton(
            icon: Icons.brush_outlined,
            label: "Add/ Remove Object",
            onPressed: () {},
          ),
        ],
      ),
    );
  }
  Widget _primaryActionButton(
      {required IconData icon,
        required String label,
        required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9B59FF),
            foregroundColor: Colors.white,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}

class InfoText extends ConsumerWidget {
  final String? title;
  final String? info;
  const InfoText({super.key, this.title, this.info});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title!,
          style:
              AppTextstyle.interRegular(fontSize: 16, color: AppColors.darkBlue),
        ),
        Text(
          info!,
          style:
              AppTextstyle.interRegular(fontSize: 14, color: AppColors.darkBlue),
        )
      ],
    );
  }
}
