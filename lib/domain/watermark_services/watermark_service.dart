import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class WatermarkService {
  static Future<Uint8List> addWatermark({
    required Uint8List originalImage,
    String? logoAssetPath,
    String watermarkText = 'ArtLeap',
    int textSize = 24, // Reduced from 36 to 24
    double opacity = 0.8,
    int margin = 30,
    double logoScale = 0.5, // Added logo scale factor
  }) async {
    try {
      // Decode original image
      final original = img.decodeImage(originalImage);
      if (original == null) throw Exception('Failed to decode image');

      // Load logo if provided
      img.Image? logo;
      if (logoAssetPath != null) {
        try {
          final logoData = await rootBundle.load(logoAssetPath);
          var loadedLogo = img.decodeImage(logoData.buffer.asUint8List());
          if (loadedLogo != null) {
            // Scale down the logo
            logo = img.copyResize(
              loadedLogo,
              width: (loadedLogo.width * logoScale).round(),
              height: (loadedLogo.height * logoScale).round(),
            );
          }
        } catch (e) {
          debugPrint('Logo loading failed: $e');
        }
      }

      // Create watermarked image
      final watermarked = img.copyResize(original, width: original.width);

      // Calculate positions
      final logoWidth = logo?.width ?? 0;
      final logoHeight = logo?.height ?? 0;
      final textHeight = textSize;
      final spacing = 10; // Space between logo and text
      final totalHeight = logoHeight + spacing + textHeight;

      // Calculate bottom-right position with consistent margins
      final logoX = watermarked.width - logoWidth - margin;
      final logoY = watermarked.height - totalHeight - margin;

      final textX = watermarked.width - margin;
      final textY = watermarked.height - textHeight - margin;

      // Add logo if exists
      if (logo != null) {
        img.compositeImage(
          watermarked,
          logo,
          dstX: logoX,
          dstY: logoY,
          blend: img.BlendMode.overlay,
        );
      }

      // Add text watermark
      img.drawString(
        watermarked,
        watermarkText,
        font: img.arial24,
        x: textX,
        y: textY,
        color: img.ColorRgba8(255, 255, 255, (255 * opacity).toInt()),
        rightJustify: true,
      );

      return Uint8List.fromList(img.encodePng(watermarked));
    } catch (e) {
      debugPrint('Watermarking failed: $e');
      return originalImage; // Return original if watermark fails
    }
  }
}