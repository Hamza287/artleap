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
    final notifier = ref.read(bannerAdStateProvider.notifier);

    if (!showBannerAds) {
      return const SizedBox.shrink();
    }

    if (!bannerState.adLoaded) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: bannerState.isExpanded ? bannerState.adSize.height.toDouble() : 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Stack(
        children: [
          if (bannerState.isExpanded)
            Positioned.fill(
              child: notifier.getBannerWidget(),
            ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: notifier.toggleExpand,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(-2, 0),
                    ),
                  ],
                ),
                child: Icon(
                  bannerState.isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}