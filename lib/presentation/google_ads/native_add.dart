import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:Artleap.ai/providers/ads_provider.dart';

import '../../shared/constants/app_assets.dart';

class NativeAdWidget extends ConsumerStatefulWidget {
  const NativeAdWidget({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends ConsumerState<NativeAdWidget> {
  @override
  Widget build(BuildContext context) {
    final ads = ref.watch(adsProvider);

    if (!ads.isNativeAdLoaded || ads.nativeAd == null) {
      return Image.asset(
        AppAssets.adicon,
        scale: 6,
        // fit: BoxFit.contain,
        // scale: 0.1,
        // height: 15,
        // width: 15,
      ); // fallback or loader
    }

    return Container(
      height: 220,
      // margin: EdgeInsets.only(right: 15),
      child: AdWidget(ad: ref.watch(adsProvider).nativeAd!),
    );
  }
}
