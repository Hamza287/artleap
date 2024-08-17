import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';

class PictureWidget extends ConsumerWidget {
  final String? image;
  const PictureWidget({super.key, this.image});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 470,
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(image: AssetImage(image!), fit: BoxFit.fill)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
              AppAssets.upscaleicon,
              height: 28,
              width: 28,
            ),
            Image.asset(
              AppAssets.downloadicon,
              height: 28,
              width: 28,
            ),
            Image.asset(
              AppAssets.saveicon,
              height: 28,
              width: 28,
            ),
            Image.asset(
              AppAssets.shareicon,
              height: 28,
              width: 28,
            ),
          ],
        ),
      ),
    );
  }
}
