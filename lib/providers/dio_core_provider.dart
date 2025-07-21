import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/api_services/dio_core.dart';
import '../shared/constants/app_constants.dart';

final dioCoreProvider = Provider<DioCore>((ref) {
  return DioCore(AppConstants.artleapBaseUrl); // Use your base URL
});