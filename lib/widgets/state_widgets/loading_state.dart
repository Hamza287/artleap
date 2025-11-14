import 'package:Artleap.ai/widgets/custom_text/custom_text_widget.dart';
import 'package:flutter/material.dart';

class LoadingState extends StatelessWidget {
  final String? message;
  final bool useShimmer;
  final int shimmerItemCount;
  final LoadingType loadingType;
  final Axis shimmerDirection;

  const LoadingState({
    super.key,
    this.message,
    this.useShimmer = false,
    this.shimmerItemCount = 3,
    this.loadingType = LoadingType.list,
    this.shimmerDirection = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    if (useShimmer) {
      return _buildShimmerLoading(theme, size, isSmallScreen,context);
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: isSmallScreen ? size.width * 0.15 : size.width * 0.2,
              height: isSmallScreen ? size.width * 0.15 : size.width * 0.2,
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                strokeWidth: isSmallScreen ? 2 : 3,
              ),
            ),
            if (message != null) ...[
              SizedBox(height: isSmallScreen ? 16 : size.height * 0.025),
              AppText(
                message!,
                size: isSmallScreen ? 14 : size.width * 0.04,
                weight: FontWeight.w400,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                align: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading(ThemeData theme, Size size, bool isSmallScreen,BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : size.width * 0.04),
      child: shimmerDirection == Axis.vertical
          ? Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          shimmerItemCount,
              (index) => _buildShimmerItem(theme, size, isSmallScreen,context),
        ),
      )
          : Row(
        children: List.generate(
          shimmerItemCount,
              (index) => Expanded(
            child: _buildShimmerItem(theme, size, isSmallScreen,context),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerItem(ThemeData theme, Size size, bool isSmallScreen,BuildContext context) {
    switch (loadingType) {
      case LoadingType.list:
        return _buildListShimmer(theme, size, isSmallScreen);
      case LoadingType.grid:
        return _buildGridShimmer(theme, size, isSmallScreen);
      case LoadingType.card:
        return _buildCardShimmer(theme, size, isSmallScreen);
      case LoadingType.profile:
        return _buildProfileShimmer(theme, size, isSmallScreen);
      case LoadingType.comments:
        return _buildCommentsShimmer(theme, size, isSmallScreen);
      case LoadingType.reel:
        return _buildReelShimmer(theme, size, isSmallScreen,context);
      }
  }

  Widget _buildListShimmer(ThemeData theme, Size size, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : size.height * 0.02),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            width: isSmallScreen ? 60 : 80,
            height: isSmallScreen ? 60 : 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title line
                Container(
                  width: isSmallScreen ? size.width * 0.4 : size.width * 0.3,
                  height: isSmallScreen ? 16 : 20,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                // Subtitle line
                Container(
                  width: double.infinity,
                  height: isSmallScreen ? 12 : 14,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 6 : 8),
                // Description line
                Container(
                  width: isSmallScreen ? size.width * 0.6 : size.width * 0.5,
                  height: isSmallScreen ? 12 : 14,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridShimmer(ThemeData theme, Size size, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.all(isSmallScreen ? 4 : 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
          ),
        ),
      ),
    );
  }

  Widget _buildCardShimmer(ThemeData theme, Size size, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: isSmallScreen ? 120 : 160,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isSmallScreen ? 12 : 16),
                topRight: Radius.circular(isSmallScreen ? 12 : 16),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Container(
                  width: isSmallScreen ? size.width * 0.5 : size.width * 0.4,
                  height: isSmallScreen ? 16 : 18,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                // Description
                Container(
                  width: double.infinity,
                  height: isSmallScreen ? 12 : 14,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 4 : 6),
                Container(
                  width: isSmallScreen ? size.width * 0.7 : size.width * 0.6,
                  height: isSmallScreen ? 12 : 14,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileShimmer(ThemeData theme, Size size, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: isSmallScreen ? 60 : 80,
                height: isSmallScreen ? 60 : 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: isSmallScreen ? 16 : 24),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    3,
                        (index) => Column(
                      children: [
                        Container(
                          width: isSmallScreen ? 24 : 30,
                          height: isSmallScreen ? 16 : 20,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: isSmallScreen ? 40 : 50,
                          height: isSmallScreen ? 12 : 14,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
          Container(
            width: double.infinity,
            height: isSmallScreen ? 14 : 16,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 10),
          Container(
            width: isSmallScreen ? size.width * 0.8 : size.width * 0.7,
            height: isSmallScreen ? 14 : 16,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsShimmer(ThemeData theme, Size size, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : size.height * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isSmallScreen ? 40 : size.width * 0.12,
            height: isSmallScreen ? 40 : size.width * 0.12,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : size.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 12 : size.width * 0.04),
                  constraints: BoxConstraints(
                    minHeight: isSmallScreen ? 60 : 80,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: isSmallScreen ? size.width * 0.4 : size.width * 0.3,
                        height: isSmallScreen ? 14 : size.height * 0.02,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 8 : size.height * 0.015),
                      Container(
                        width: double.infinity,
                        height: isSmallScreen ? 12 : size.height * 0.016,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 6 : size.height * 0.008),
                      Container(
                        width: isSmallScreen ? size.width * 0.6 : size.width * 0.5,
                        height: isSmallScreen ? 12 : size.height * 0.016,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : size.height * 0.01),
                Container(
                  width: isSmallScreen ? 60 : size.width * 0.2,
                  height: isSmallScreen ? 10 : size.height * 0.014,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildReelShimmer(ThemeData theme, Size size, bool isSmallScreen,BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 320,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  theme.colorScheme.onSurface.withOpacity(0.9),
                  Colors.transparent,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            height: 14,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 80,
                            height: 12,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: 70,
                        height: 28,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: size.width * 0.8,
                    height: 16,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 150,
                        height: 14,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          right: 16,
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      size: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              _buildReelActionItem(theme),
              const SizedBox(height: 25),
              _buildReelActionItem(theme),
              const SizedBox(height: 25),
              _buildReelActionItem(theme),
              const SizedBox(height: 25),
              _buildReelActionItem(theme),
              const SizedBox(height: 25),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.music_note,
                  color: theme.colorScheme.onSurface,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          right: 16,
          child: Row(
            children: List.generate(5, (index) => Expanded(
              child: Container(
                height: 2.5,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: BoxDecoration(
                  color: index == 0
                      ? theme.colorScheme.surfaceContainerHighest
                      : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            )),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 70,
                  height: 24,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReelActionItem(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.favorite,
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 36,
          height: 12,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

}

enum LoadingType {
  list,
  grid,
  card,
  profile,
  comments,
  reel,
}