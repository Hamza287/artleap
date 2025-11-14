import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/api_repos_impl/image_privacy_repo.dart';
import '../domain/api_services/api_response.dart';
import 'generate_image_provider.dart';

final imagePrivacyRepositoryProvider = Provider<ImagePrivacyRepository>((ref) {
  return ImagePrivacyRepository();
});

class ImagePrivacyState {
  final bool isUpdating;
  final ApiResponse? response;
  final Map<String, ImagePrivacy> imagePrivacyCache;
  final bool needsRefresh;

  ImagePrivacyState({
    required this.isUpdating,
    this.response,
    Map<String, ImagePrivacy>? imagePrivacyCache,
    this.needsRefresh = false,
  }) : imagePrivacyCache = imagePrivacyCache ?? {};

  ImagePrivacyState copyWith({
    bool? isUpdating,
    ApiResponse? response,
    Map<String, ImagePrivacy>? imagePrivacyCache,
    bool? needsRefresh,
  }) =>
      ImagePrivacyState(
        isUpdating: isUpdating ?? this.isUpdating,
        response: response ?? this.response,
        imagePrivacyCache: imagePrivacyCache ?? this.imagePrivacyCache,
        needsRefresh: needsRefresh ?? this.needsRefresh,
      );
}

class ImagePrivacyNotifier extends StateNotifier<ImagePrivacyState> {
  final ImagePrivacyRepository repo;

  ImagePrivacyNotifier(this.repo) : super(ImagePrivacyState(isUpdating: false));

  Future<void> setPrivacy({
    required String imageId,
    required String userId,
    required ImagePrivacy privacy,
  }) async {
    state = state.copyWith(isUpdating: true);

    try {
      final result = await repo.updatePrivacy(
        imageId: imageId,
        userId: userId,
        privacy: _toString(privacy),
      );

      final updatedCache = Map<String, ImagePrivacy>.from(state.imagePrivacyCache);
      updatedCache[imageId] = privacy;

      state = state.copyWith(
        isUpdating: false,
        response: result,
        imagePrivacyCache: updatedCache,
        needsRefresh: true,
      );
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        response: ApiResponse.error(e.toString()),
      );
    }
  }

  ImagePrivacy? getPrivacyForImage(String imageId) {
    return state.imagePrivacyCache[imageId];
  }

  void cachePrivacy(String imageId, ImagePrivacy privacy) {
    final updatedCache = Map<String, ImagePrivacy>.from(state.imagePrivacyCache);
    updatedCache[imageId] = privacy;
    state = state.copyWith(imagePrivacyCache: updatedCache);
  }

  void clearCacheForImage(String imageId) {
    final updatedCache = Map<String, ImagePrivacy>.from(state.imagePrivacyCache);
    updatedCache.remove(imageId);
    state = state.copyWith(imagePrivacyCache: updatedCache);
  }

  void clearCache() {
    state = state.copyWith(
      imagePrivacyCache: {},
      needsRefresh: true,
    );
  }

  void refresh() {
    state = state.copyWith(needsRefresh: true);
  }

  void resetRefresh() {
    state = state.copyWith(needsRefresh: false);
  }

  void reset() {
    state = ImagePrivacyState(isUpdating: false);
  }

  String _toString(ImagePrivacy p) {
    switch (p) {
      case ImagePrivacy.public:
        return 'public';
      case ImagePrivacy.private:
        return 'private';
    }
  }

}

final imagePrivacyProvider =
StateNotifierProvider<ImagePrivacyNotifier, ImagePrivacyState>((ref) {
  final repo = ref.watch(imagePrivacyRepositoryProvider);
  return ImagePrivacyNotifier(repo);
});

final imagePrivacyForImageProvider = Provider.family<ImagePrivacy?, String>((ref, imageId) {
  return ref.watch(imagePrivacyProvider.select((state) => state.imagePrivacyCache[imageId]));
});

final imagePrivacyRefreshProvider = Provider<bool>((ref) {
  return ref.watch(imagePrivacyProvider.select((state) => state.needsRefresh));
});

final imagePrivacyUpdatingProvider = Provider.family<bool, String>((ref, imageId) {
  final state = ref.watch(imagePrivacyProvider);
  return state.isUpdating;
});