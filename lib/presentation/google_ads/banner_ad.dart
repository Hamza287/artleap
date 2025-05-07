import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photoroomapp/providers/ads_provider.dart';
import 'package:photoroomapp/providers/generate_image_provider.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';

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
    ref.read(adsProvider).bannerAd!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ads = ref.watch(adsProvider);

    if (!ads.isBannerAdLoaded || ads.bannerAd == null) {
      return Align(
        alignment: Alignment.topRight,
        child: Image.asset(
          AppAssets.adicon,
          height: 20,
          width: 20,
        ),
      ); // fallback or loader
    }
    return Container(
      alignment: Alignment.center,
      width: ref.watch(adsProvider).bannerAd!.size.width.toDouble(),
      height: 40,
      child: AdWidget(ad: ref.watch(adsProvider).bannerAd!),
    );
  }
}
