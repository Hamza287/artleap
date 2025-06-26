import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/watermark_provider.dart';

class WatermarkUtils {
  static Future<Uint8List> applyWatermarkIfNeeded({
    required WidgetRef ref,
    required Uint8List originalImage,
    bool shouldApply = true,
  }) async {
    if (!shouldApply) return originalImage;

    return await ref.read(watermarkProvider.notifier).applyWatermark(originalImage);
  }
}