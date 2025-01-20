import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photoroomapp/providers/generate_image_provider.dart';

class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ref.read(generateImageProvider).bannerAd!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: ref.watch(generateImageProvider).bannerAd!.size.width.toDouble(),
      height: ref.watch(generateImageProvider).bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: ref.watch(generateImageProvider).bannerAd!),
    );
  }
}
