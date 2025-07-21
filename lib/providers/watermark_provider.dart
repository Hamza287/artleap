import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/watermark_services/watermark_service.dart';

final watermarkProvider = StateNotifierProvider<WatermarkNotifier, WatermarkState>((ref) {
  return WatermarkNotifier();
});

class WatermarkState {
  final bool isLoading;
  final Uint8List? watermarkedImage;
  final String? error;
  final bool watermarkEnabled; // Add this new field

  WatermarkState({
    this.isLoading = false,
    this.watermarkedImage,
    this.error,
    this.watermarkEnabled = true, // Default to enabled
  });

  // Add copyWith method for easier state updates
  WatermarkState copyWith({
    bool? isLoading,
    Uint8List? watermarkedImage,
    String? error,
    bool? watermarkEnabled,
  }) {
    return WatermarkState(
      isLoading: isLoading ?? this.isLoading,
      watermarkedImage: watermarkedImage ?? this.watermarkedImage,
      error: error ?? this.error,
      watermarkEnabled: watermarkEnabled ?? this.watermarkEnabled,
    );
  }
}

class WatermarkNotifier extends StateNotifier<WatermarkState> {
  WatermarkNotifier() : super(WatermarkState());

  Future<Uint8List> applyWatermark(Uint8List originalImage) async {
    if (!state.watermarkEnabled) {
      return originalImage; // Skip watermarking if disabled
    }

    state = state.copyWith(isLoading: true);

    try {
      final watermarked = await WatermarkService.addWatermark(
        originalImage: originalImage,
        logoAssetPath: 'assets/watermark/watermark.png',
        watermarkText: ' ',
      );

      state = state.copyWith(
        isLoading: false,
        watermarkedImage: watermarked,
      );
      return watermarked;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return originalImage;
    }
  }

  // Add method to toggle watermark
  void toggleWatermark(bool enabled) {
    state = state.copyWith(watermarkEnabled: enabled);
  }

  void clear() {
    state = WatermarkState();
  }
}