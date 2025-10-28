import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/api_services/api_response.dart';
import '../domain/base_repo/base_repo.dart';
import 'package:flutter/material.dart';
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
  bool _shouldCloseSheets = false;

  bool get isDeleting => loadingState == ImageActionLoading.deleting;
  bool get isReporting => loadingState == ImageActionLoading.reporting;
  bool get shouldCloseSheets => _shouldCloseSheets;

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

  void clearReportData() {
    _reportReason = null;
    _reportReasonId = null;
    _othersTextController.clear();
    loadingState = ImageActionLoading.none;
    _shouldCloseSheets = false;
    notifyListeners();
  }

  void setShouldCloseSheets(bool value) {
    _shouldCloseSheets = value;
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

  Future<bool> reportImage(
      String imageId,
      String creatorId,
      ) async {
    loadingState = ImageActionLoading.reporting;
    notifyListeners();

    try {
      Map<String, String> body = {
        "reporterId": creatorId,
        "reason": reportReason ?? _othersTextController.text,
      };

      ApiResponse userRes = await imageActionRepo.reportImage(body: body, imageId: imageId);

      if (userRes.status == Status.completed) {
        appSnackBar("Success", "Image reported successfully", AppColors.green);
        _shouldCloseSheets = true;
        clearReportData();
        return true;
      } else {
        appSnackBar("Error", userRes.message ?? "Failed to report image", AppColors.redColor);
        return false;
      }
    } catch (e) {
      appSnackBar('Error', e.toString(), AppColors.redColor);
      return false;
    } finally {
      loadingState = ImageActionLoading.none;
      notifyListeners();
    }
  }
}