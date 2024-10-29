import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/domain/base_repo/base_repo.dart';

import '../domain/api_models/freepik_image_gen_model.dart' as freePik;  
import '../domain/api_services/api_response.dart';

final freePikProvider =
    ChangeNotifierProvider<FreePikProvider>((ref) => FreePikProvider());

class FreePikProvider extends ChangeNotifier with BaseRepo {
  bool _isGenerateImageLoading = false;
  bool get isGenerateImageLoading => _isGenerateImageLoading;


  setGenerateImageLoader(bool value) {
    _isGenerateImageLoading = value;
    notifyListeners();
  }


}
