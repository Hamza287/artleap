import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Artleap.ai/domain/base_repo/base_repo.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'watermark_provider.dart'; // Import the watermark provider

final favProvider =
ChangeNotifierProvider<FavouriteProvider>((ref) => FavouriteProvider(ref));

class FavouriteProvider extends ChangeNotifier with BaseRepo {
  final Ref ref; // Add Ref to access other providers
  final List<Map<String, dynamic>> _userFavourites = [];
  List<Map<String, dynamic>> get usersFavourites => _userFavourites;
  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  FavouriteProvider(this.ref); // Initialize with Ref

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

      // 2. Apply watermark using WatermarkNotifier
      final watermarkNotifier = ref.read(watermarkProvider.notifier);
      final watermarkedBytes = await watermarkNotifier.applyWatermark(originalBytes);

      // 3. Save to gallery
      await SaverGallery.saveImage(
        watermarkedBytes,
        quality: 60,
        fileName: "artleap_${DateTime.now().millisecondsSinceEpoch}.jpg",
        androidRelativePath: "DCIM/artleapImages",
        skipIfExists: false,
        extension: "jpg",
      );

      appSnackBar("Success", "Image saved Successfully", AppColors.blue);
    } catch (e) {
      appSnackBar("Error", "Error downloading image: $e", AppColors.redColor);
    } finally {
      setDownloadingLoader(false);
      notifyListeners();
    }
  }
}