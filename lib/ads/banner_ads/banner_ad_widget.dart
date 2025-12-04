import 'package:Artleap.ai/shared/route_export.dart';

class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdState();
}

class _BannerAdState extends ConsumerState<BannerAdWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bannerAdStateProvider.notifier).initializeBannerAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    final showBannerAds = ref.watch(bannerAdsEnabledProvider);
    final bannerState = ref.watch(bannerAdStateProvider);

    if (!showBannerAds || !bannerState.adLoaded) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: bannerState.adSize.height.toDouble(),
      alignment: Alignment.center,
      child: ref.read(bannerAdStateProvider.notifier).getBannerWidget(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}