import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Artleap.ai/domain/base_repo/base_repo.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:saver_gallery/saver_gallery.dart';
import '../services/watermark_service.dart';

final favProvider =
    ChangeNotifierProvider<FavouriteProvider>((ref) => FavouriteProvider());

class FavouriteProvider extends ChangeNotifier with BaseRepo {
  final List<Map<String, dynamic>> _userFavourites = [];
  List<Map<String, dynamic>> get usersFavourites => _userFavourites;
  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  setDownloadingLoader(bool value) {
    _isDownloading = value;
    notifyListeners();
  }

  Future<void> downloadImage(String imageUrl, {Uint8List? uint8ListObject}) async {
    setDownloadingLoader(true);

    try {
      // 1. Get the image bytes (either from URL or provided Uint8List)
      final Uint8List originalBytes;
      if (uint8ListObject != null) {
        originalBytes = uint8ListObject;
      } else {
        // Download image if URL is provided
        final tempDir = await getTemporaryDirectory();
        final savePath = '${tempDir.path}/temp_image.jpg';
        await Dio().download(imageUrl, savePath);
        originalBytes = await File(savePath).readAsBytes();
      }

      // 2. Apply watermark (added this part)
      final watermarkedBytes = await WatermarkService.addWatermark(
        originalImage: originalBytes,
        logoAssetPath: 'assets/watermark/watermark.png',
        watermarkText: ' ',
      );

      // 3. Save to gallery (modified to use watermarked image)
      final result = await SaverGallery.saveImage(
        watermarkedBytes, // Using watermarked bytes instead of original
        quality: 60,
        fileName: "artleap_${DateTime.now().millisecondsSinceEpoch}.jpg",
        androidRelativePath: "DCIM/artleapImages",
        skipIfExists: false,
        extension: "jpg",
      );

      appSnackBar("Success", "Image saved with watermark", AppColors.blue);
    } catch (e) {
      appSnackBar("Error", "Error downloading image: $e", AppColors.redColor);
    } finally {
      setDownloadingLoader(false);
      notifyListeners();
    }
  }
}
