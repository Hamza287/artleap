import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class FullImageState {
  final Uint8List? originalImageBytes;
  final bool isLoading;
  final String? error;

  FullImageState({
    this.originalImageBytes,
    this.isLoading = true,
    this.error,
  });

  FullImageState copyWith({
    Uint8List? originalImageBytes,
    bool? isLoading,
    String? error,
  }) {
    return FullImageState(
      originalImageBytes: originalImageBytes ?? this.originalImageBytes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class FullImageNotifier extends StateNotifier<FullImageState> {
  FullImageNotifier() : super(FullImageState());

  Future<void> loadOriginalImage(String imageUrl) async {
    if (imageUrl.isEmpty) {
      state = FullImageState(
        isLoading: false,
        error: 'No image URL provided',
      );
      return;
    }

    try {
      // Only update state if we're not already loading
      if (!state.isLoading) {
        state = state.copyWith(isLoading: true, error: null);
      }

      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        state = state.copyWith(
          originalImageBytes: response.bodyBytes,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load image (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load image: ${e.toString()}',
      );
    }
  }
}

final fullImageProvider = StateNotifierProvider<FullImageNotifier, FullImageState>(
      (ref) => FullImageNotifier(),
);