import 'package:Artleap.ai/shared/route_export.dart';

class NativeAdWidget extends ConsumerWidget {
  final int? adIndex;

  const NativeAdWidget({super.key, this.adIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adState = ref.watch(nativeAdProvider);

    if (!adState.showAds) return const SizedBox.shrink();

    if (adState.isLoading && adState.nativeAds.isEmpty) {
      return const SizedBox(
        height: 330,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (adState.errorMessage != null && adState.nativeAds.isEmpty) {
      return const SizedBox(
        height: 330,
        child: Center(child: Text("Ad failed to load")),
      );
    }

    if (adState.nativeAds.isEmpty) {
      return const SizedBox.shrink();
    }

    final nativeAd = adIndex != null && adIndex! < adState.nativeAds.length
        ? adState.nativeAds[adIndex!]
        : adState.nativeAds.isNotEmpty
        ? adState.nativeAds[0]
        : null;

    if (nativeAd == null) {
      return const SizedBox.shrink();
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 320,
        maxHeight: 400,
        minWidth: 320,
        maxWidth: 500,
      ),
      child: AdWidget(ad: nativeAd),
    );
  }
}