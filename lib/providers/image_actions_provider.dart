import 'package:Artleap.ai/providers/refresh_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/api_services/api_response.dart';
import '../domain/base_repo/base_repo.dart';
import 'package:flutter/material.dart';

import '../presentation/views/home_section/bottom_nav_bar.dart';
import '../shared/app_snack_bar.dart';
import '../shared/constants/app_colors.dart';

enum ImageActionLoading {
  none,
  deleting,
  reporting,
}

final imageActionsProvider = ChangeNotifierProvider<ImageActionsProvider>(
  (ref) => ImageActionsProvider(),
);

class ImageActionsProvider extends ChangeNotifier with BaseRepo {
  ImageActionLoading loadingState = ImageActionLoading.none;

  bool get isDeleting => loadingState == ImageActionLoading.deleting;
  bool get isReporting => loadingState == ImageActionLoading.reporting;
  final TextEditingController _othersTextController = TextEditingController();
  TextEditingController get othersTextController => _othersTextController;
  String? _reportReason;
  String? get reportReason => _reportReason;
  String? _reportReasonId;
  String? get reportReasonId => _reportReasonId;

  set reportReason(String? val) {
    _reportReason = val;
    notifyListeners();
  }

  set reportReasonId(String? val) {
    _reportReasonId = val;
    notifyListeners();
  }

  Future<bool> deleteImage(String? imageId) async {
    loadingState = ImageActionLoading.deleting;
    notifyListeners();

    try {
      ApiResponse userRes = await imageActionRepo.deleteImage(imageId: imageId!);
      if (userRes.status == Status.completed) {
        appSnackBar("Success", "Image deleted successfully", AppColors.green);
        return true;
      }
    } catch (e) {
      appSnackBar('Error', e.toString(), AppColors.redColor);
    } finally {
      loadingState = ImageActionLoading.none;
      notifyListeners();
    }
    return false;
  }

  Future<void> reportImage(
    String imageId,
    String creatorId,
  ) async {
    loadingState = ImageActionLoading.reporting;
    try {
      Map<String, String> body = {
        "reporterId": creatorId,
        "reason": reportReason ?? _othersTextController.text,
      };
      ApiResponse userRes =
          await imageActionRepo.reportImage(body: body, imageId: imageId);
      if (userRes.status == Status.completed) {
        appSnackBar("Success", "Image reported successfully", AppColors.green);
      }
    } finally {
      loadingState = ImageActionLoading.none;
    }
    notifyListeners();
  }
}
