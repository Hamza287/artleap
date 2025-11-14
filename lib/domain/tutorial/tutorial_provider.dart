import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tutorial_model.dart';
import 'tutorial_storage_service.dart';

final tutorialStorageServiceProvider = Provider<TutorialStorageService>((ref) {
  return TutorialStorageService();
});

final tutorialDataProvider = Provider<List<TutorialScreenModel>>((ref) {
  return [
    TutorialScreenModel(
      imageAsset: 'assets/images/tutorial1.webp',
      title: 'New ways to connect!',
      description: 'You can now like, comment, and save posts in the community. Show some love, share your thoughts, and keep your favorite posts close — your community just got a whole lot more interactive!',
    ),
    TutorialScreenModel(
      imageAsset: 'assets/images/tutorial2.jpg',
      title: 'Your privacy, your control',
      description: 'Now you can make your posts private with just one tap!. Press the Private button to share your content only when and how you want you’re in charge.',
    ),
    TutorialScreenModel(
      imageAsset: 'assets/images/tutorial3.webp',
      title: 'Your privacy, your control',
      description: 'Now you can make your posts private with just one tap!. Press the Private button to share your content only when and how you want you’re in charge.',
    ),
    TutorialScreenModel(
      imageAsset: 'assets/images/tutorial4.webp',
      title: 'Your app, your vibe',
      description: 'Switch between Light Mode, Dark Mode, or let it match your system automatically. Find the look that fits your mood!',
    ),
  ];
});

final tutorialStateProvider = StateNotifierProvider<TutorialStateNotifier, TutorialState>((ref) {
  final storageService = ref.watch(tutorialStorageServiceProvider);
  final tutorialScreens = ref.watch(tutorialDataProvider);
  return TutorialStateNotifier(storageService, tutorialScreens);
});

class TutorialState {
  final int currentPage;
  final bool isLastPage;
  final bool isLoading;
  final bool hasError;

  TutorialState({
    this.currentPage = 0,
    this.isLastPage = false,
    this.isLoading = false,
    this.hasError = false,
  });

  TutorialState copyWith({
    int? currentPage,
    bool? isLastPage,
    bool? isLoading,
    bool? hasError,
  }) {
    return TutorialState(
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}

class TutorialStateNotifier extends StateNotifier<TutorialState> {
  final TutorialStorageService _storageService;
  final List<TutorialScreenModel> _tutorialScreens;

  TutorialStateNotifier(this._storageService, this._tutorialScreens)
      : super(TutorialState()) {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    state = state.copyWith(isLoading: true);

    try {
      await _storageService.init();
      final savedPage = _storageService.getCurrentPage();
      final isLastPage = savedPage == _tutorialScreens.length - 1;

      state = state.copyWith(
        currentPage: savedPage,
        isLastPage: isLastPage,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
      );
    }
  }

  Future<void> setCurrentPage(int page) async {
    final isLastPage = page == _tutorialScreens.length - 1;

    await _storageService.setCurrentPage(page);

    state = state.copyWith(
      currentPage: page,
      isLastPage: isLastPage,
    );
  }

  Future<void> nextPage() async {
    if (state.currentPage < _tutorialScreens.length - 1) {
      final newPage = state.currentPage + 1;
      final isLastPage = newPage == _tutorialScreens.length - 1;

      await _storageService.setCurrentPage(newPage);

      state = state.copyWith(
        currentPage: newPage,
        isLastPage: isLastPage,
      );
    }
  }

  Future<void> previousPage() async {
    if (state.currentPage > 0) {
      final newPage = state.currentPage - 1;

      await _storageService.setCurrentPage(newPage);

      state = state.copyWith(
        currentPage: newPage,
        isLastPage: false,
      );
    }
  }

  Future<void> completeTutorial() async {
    await _storageService.setTutorialCompleted();
  }

  Future<void> skipTutorial() async {
    await _storageService.setTutorialCompleted();
  }

  bool shouldShowTutorial() {
    return !_storageService.hasSeenTutorial();
  }

  TutorialScreenModel getCurrentScreen() {
    return _tutorialScreens[state.currentPage];
  }

  int get totalPages => _tutorialScreens.length;
}