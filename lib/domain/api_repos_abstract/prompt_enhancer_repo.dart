import '../api_services/api_response.dart';
import '../base_repo/base.dart';

abstract class PromptEnhancerRepo extends Base {
  Future<ApiResponse> enhancePrompt(
      String prompt, {
        bool enableLocalPersistence = false,
      });
}