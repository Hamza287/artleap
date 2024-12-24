import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:photoroomapp/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:photoroomapp/presentation/views/home_section/home_screen/home_screen.dart';
import 'package:photoroomapp/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:photoroomapp/shared/app_snack_bar.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/navigation/navigation.dart';
import '../domain/base_repo/base_repo.dart';
import '../shared/constants/user_data.dart';

final reportProvider =
    ChangeNotifierProvider<ReportProvider>((ref) => ReportProvider());

class ReportProvider extends ChangeNotifier with BaseRepo {
  final TextEditingController _othersTextController = TextEditingController();
  TextEditingController get othersTextController => _othersTextController;

  String? _reportReason;
  String? get reportReason => _reportReason;
  String? _reportReasonId;
  String? get reportReasonId => _reportReasonId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set reportReason(String? val) {
    _reportReason = val;
    notifyListeners();
  }

  set reportReasonId(String? val) {
    _reportReasonId = val;
    notifyListeners();
  }

  reportImage(String imageUrl, String prompt, String modelName,
      String creatorName, String creatorEmail) async {
    _isLoading = true;
    print(_isLoading);
    try {
      await firestore.collection('Reports').doc("usersReports").set({
        'reportsList': FieldValue.arrayUnion([
          {
            'creator_name': creatorName,
            'creator_email': creatorEmail,
            "imageUrl": imageUrl,
            'userid': UserData.ins.userId,
            'prompt': prompt,
            'model_name': modelName,
            "reason": "${_reportReason!}  ${othersTextController.text}",
            'reporter_name': UserData.ins.userName,
            'reporter_email': UserData.ins.userEmail,
          }
        ])
      }, SetOptions(merge: true));
      _othersTextController.text = "";
      _reportReason = "";
      _isLoading = false;
      print(_isLoading);

      appSnackBar("Success", "report submitted successfully", AppColors.green);
    } catch (e) {
      _isLoading = false;
      print('Error saving image URL to Firestore: $e');
      appSnackBar("Failed", "Error: $e", AppColors.redColor);
    }
    notifyListeners();
  }
}
