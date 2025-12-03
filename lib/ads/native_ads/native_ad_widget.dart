import 'package:Artleap.ai/shared/route_export.dart';

class NativeAdWidget extends ConsumerWidget {
  const NativeAdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adState = ref.watch(nativeAdProvider);

    if (!adState.showAds) return const SizedBox.shrink();

    if (adState.isLoading) {
      return const SizedBox(
        height: 330,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (adState.errorMessage != null) {
      return const SizedBox(
        height: 330,
        child: Center(child: Text("Ad failed to load")),
      );
    }

    if (!adState.isLoaded || adState.nativeAd == null) {
      return const SizedBox.shrink();
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 320,
        maxHeight: 400,
        minWidth: 320,
        maxWidth: 500,
      ),
      child: AdWidget(ad: adState.nativeAd!),
    );
  }
}
