// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:Artleap.ai/domain/api_models/models_list_model.dart';
// import 'package:Artleap.ai/domain/base_repo/base_repo.dart';

// import '../domain/api_services/api_response.dart';
// import '../shared/constants/app_constants.dart';

// final modelsListProvider =
//     ChangeNotifierProvider<ModelsListProvider>((ref) => ModelsListProvider());

// class ModelsListProvider extends ChangeNotifier with BaseRepo {
//   List<ModelsListModel> _dataOfModels = [];
//   List<ModelsListModel> get dataOfModels => _dataOfModels;

//   Future<void> getModelsListData() async {
//     Map<String, dynamic> data = {
//       "key": AppConstants.stableDefKey,
//     };
//     print(data);
//     print("Sending request to API...");
//     ApiResponse modelListData = await modelListRepo.getModelsListData(data);
//     if (modelListData.status == Status.completed) {
//       print(modelListData.data);
//       print("lllllllllllllllll");
//       _dataOfModels = modelListData.data;
//       print(dataOfModels);
//       print("ssssssssssssssssss");
//       // data = modelListData.data as List<ModelsListModel>;
//       // print(generatedImage!.output);
//       // setImageRefLoader(false);
//     } else {
//       print(modelListData.status);
//     }
//     notifyListeners();
//   }
// }
