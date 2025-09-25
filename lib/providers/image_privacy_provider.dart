import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/api_repos_impl/image_privacy_repo.dart';
import '../domain/api_services/api_response.dart';

enum ImagePrivacy { public, private, followers, personal }

final imagePrivacyRepositoryProvider = Provider<ImagePrivacyRepository>((ref) {
  return ImagePrivacyRepository();
});

class ImagePrivacyState {
  final bool isUpdating;
  final ApiResponse? response;

  ImagePrivacyState({
    required this.isUpdating,
    this.response,
  });

  ImagePrivacyState copyWith({
    bool? isUpdating,
    ApiResponse? response,
  }) =>
      ImagePrivacyState(
        isUpdating: isUpdating ?? this.isUpdating,
        response: response ?? this.response,
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

      state = state.copyWith(
        isUpdating: false,
        response: result,
      );
    } catch (e) {
      // In case something slips past ApiResponse handling
      state = state.copyWith(
        isUpdating: false,
        response: ApiResponse.error(e.toString()),
      );
    }
  }

  String _toString(ImagePrivacy p) {
    switch (p) {
      case ImagePrivacy.public:
        return 'public';
      case ImagePrivacy.private:
        return 'private';
      case ImagePrivacy.followers:
        return 'followers';
      case ImagePrivacy.personal:
        return 'personal';
    }
  }
}

final imagePrivacyProvider =
StateNotifierProvider<ImagePrivacyNotifier, ImagePrivacyState>((ref) {
  final repo = ref.watch(imagePrivacyRepositoryProvider);
  return ImagePrivacyNotifier(repo);
});
