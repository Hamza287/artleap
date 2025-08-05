import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/watermark_services/watermark_service.dart';
import 'user_profile_provider.dart';

final watermarkProvider = StateNotifierProvider<WatermarkNotifier, WatermarkState>((ref) {
  return WatermarkNotifier(ref);
});

class WatermarkState {
  final bool isLoading;
  final Uint8List? watermarkedImage;
  final String? error;
  final bool watermarkEnabled;

  WatermarkState({
    this.isLoading = false,
    this.watermarkedImage,
    this.error,
    this.watermarkEnabled = true,
  });

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
  final Ref ref;

  WatermarkNotifier(this.ref) : super(WatermarkState()) {
    initializeWatermarkState();
  }

  // Method to initialize watermark state based on subscription plan
  Future<void> initializeWatermarkState() async {
    try {
      // Access user profile data from UserProfileProvider
      final userProfile = ref.read(userProfileProvider).userProfileData;
      print(userProfile);
      if (userProfile != null) {
        final isFreePlan = userProfile.user.watermarkEnabled == true;
        if(isFreePlan){
          state = state.copyWith(watermarkEnabled: true);
        }else{
          state = state.copyWith(watermarkEnabled: false);
        }
      } else {
        state = state.copyWith(watermarkEnabled: true);
      }
    } catch (e) {
      state = state.copyWith(
        watermarkEnabled: true,
        error: e.toString(),
      );
    }
  }

  Future<Uint8List> applyWatermark(Uint8List originalImage) async {
    if (!state.watermarkEnabled) {
      return originalImage;
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

  void toggleWatermark(bool enabled) {
    state = state.copyWith(watermarkEnabled: enabled);
  }

  void clear() {
    state = WatermarkState();
  }
}