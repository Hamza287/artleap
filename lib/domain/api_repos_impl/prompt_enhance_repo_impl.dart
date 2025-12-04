import 'dart:isolate';
import 'package:dio/dio.dart';
import '../../shared/constants/app_api_paths.dart';
import '../api_models/prompt_enhancer_model.dart';
import '../api_repos_abstract/prompt_enhancer_repo.dart';
import '../api_services/api_response.dart';
import '../api_services/handling_response.dart';

class PromptEnhancerImpl extends PromptEnhancerRepo {
  @override
  Future<ApiResponse> enhancePrompt(
      String prompt, {
        bool enableLocalPersistence = false,
      }) async {
    try {
      final data = {'prompt': prompt};

      Response res = await artleapApiService.postJson(
        AppApiPaths.enhancePrompt,
        data,
        enableLocalPersistence: enableLocalPersistence,
      );

      ApiResponse result = HandlingResponse.returnResponse(res);
      print(result);

      if (result.status == Status.completed) {
        PromptEnhancerModel data = await Isolate.run(
              () => PromptEnhancerModel.fromJson(res.data),
        );
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      print("this is an error ${w}");
      return HandlingResponse.returnException(w);
    }
  }
}