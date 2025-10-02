import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/community/providers/providers_setup.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

import '../home_section/new_comunity_screen/bottom_sheet_components/error_coment_state.dart';
import '../subscriptions/choose_plan_widgets/loading_state.dart';

class SavedImagesScreen extends ConsumerStatefulWidget {
  const SavedImagesScreen({super.key});

  @override
  ConsumerState<SavedImagesScreen> createState() => _SavedImagesScreenState();
}

class _SavedImagesScreenState extends ConsumerState<SavedImagesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreImages();
    }
  }

  void _loadMoreImages() {
  }

  void _unsaveImage(String imageId) async {
    try {
      await ref.read(saveProvider.notifier).toggleSave(imageId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Removed from saved'),
          backgroundColor: AppColors.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to unsave: $e'),
          backgroundColor: AppColors.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savedStatus = ref.watch(saveProvider);
    final savedCountAsync = ref.watch(savedCountProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Header
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryColor.withOpacity(0.1),
                      AppColors.secondaryColor.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 80),
                    // Header Content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.primaryColor, AppColors.secondaryColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.bookmark_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Saved Images',
                                  style: AppTextstyle.interBold(
                                    fontSize: 28,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                savedCountAsync.when(
                                  data: (count) => Text(
                                    '$count ${count == 1 ? 'precious memory' : 'precious memories'} saved',
                                    style: AppTextstyle.interRegular(
                                      fontSize: 16,
                                      color: AppColors.hintTextColor,
                                    ),
                                  ),
                                  loading: () => Text(
                                    'Loading your collection...',
                                    style: AppTextstyle.interRegular(
                                      fontSize: 16,
                                      color: AppColors.hintTextColor,
                                    ),
                                  ),
                                  error: (error, stack) => Text(
                                    'Your saved collection',
                                    style: AppTextstyle.interRegular(
                                      fontSize: 16,
                                      color: AppColors.hintTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Your Collection',
                    style: AppTextstyle.interBold(
                      fontSize: 20,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'All the images you\'ve saved for later',
                    style: AppTextstyle.interRegular(
                      fontSize: 14,
                      color: AppColors.hintTextColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          savedStatus.when(
            data: (savedStatus) {
              final savedImageIds = savedStatus.entries
                  .where((entry) => entry.value == true)
                  .map((entry) => entry.key)
                  .toList();

              if (savedImageIds.isEmpty) {
                return const SliverFillRemaining(
                  child: _EmptySavedState(),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final imageId = savedImageIds[index];
                      return _SavedImageCard(
                        imageId: imageId,
                        onUnsave: () => _unsaveImage(imageId),
                      );
                    },
                    childCount: savedImageIds.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: LoadingState(),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: ErrorState(
                error: error,
                onRetry: () => ref.read(saveProvider.notifier).refreshSavedStatus(),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}

class _SavedImageCard extends StatelessWidget {
  final String imageId;
  final VoidCallback onUnsave;

  const _SavedImageCard({
    required this.imageId,
    required this.onUnsave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Image
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade200,
            ),
            child: const Center(
              child: Icon(
                Icons.image_outlined,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: onUnsave,
                icon: Icon(
                  Icons.bookmark_remove_rounded,
                  color: AppColors.errorColor,
                  size: 18,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ),

          // Image Info
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'AI Generated',
                    style: AppTextstyle.interMedium(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Beautiful Artwork',
                  style: AppTextstyle.interBold(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '2 days ago',
                  style: AppTextstyle.interRegular(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySavedState extends StatelessWidget {
  const _EmptySavedState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_border_rounded,
              size: 60,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'No Saved Images Yet',
            style: AppTextstyle.interBold(
              fontSize: 24,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Start building your collection by saving your favorite AI-generated artworks. They\'ll appear here for easy access.',
              textAlign: TextAlign.center,
              style: AppTextstyle.interRegular(
                fontSize: 16,
                color: AppColors.hintTextColor,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Navigate to explore or home screen
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              'Explore Artworks',
              style: AppTextstyle.interMedium(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
