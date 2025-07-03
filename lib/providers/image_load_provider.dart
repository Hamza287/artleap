import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State class for image loading
class ImageLoadState {
  final int attemptCount;
  final bool isLoading;
  final String? error;

  ImageLoadState({
    this.attemptCount = 0,
    this.isLoading = false,
    this.error,
  });

  ImageLoadState copyWith({
    int? attemptCount,
    bool? isLoading,
    String? error,
  }) {
    return ImageLoadState(
      attemptCount: attemptCount ?? this.attemptCount,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Provider for managing image load state
final imageLoadStateProvider = StateNotifierProvider.family<ImageLoadNotifier, ImageLoadState, String>((ref, imageUrl) {
  return ImageLoadNotifier(imageUrl: imageUrl);
});

// StateNotifier for image loading logic
class ImageLoadNotifier extends StateNotifier<ImageLoadState> {
  final String imageUrl;

  ImageLoadNotifier({required this.imageUrl}) : super(ImageLoadState());

  Future<void> retryLoad() async {
    if (state.isLoading || state.attemptCount >= 2) return;

    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Force evict the cached image if it exists
      await DefaultCacheManager().removeFile(imageUrl);

      state = state.copyWith(
        isLoading: false,
        attemptCount: state.attemptCount + 1,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}