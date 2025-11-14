import 'package:Artleap.ai/shared/route_export.dart';


class NoContentWidget extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final bool showActionButton;
  final String actionText;
  final VoidCallback? onActionPressed;
  final Color? backgroundColor;

  const NoContentWidget({
    super.key,
    required this.title,
    required this.description,
    this.iconPath = 'assets/images/empty_state.png',
    this.showActionButton = false,
    this.actionText = 'Try Again',
    this.onActionPressed,
    this.backgroundColor,
  });

  factory NoContentWidget.noImagesForFilter({
    String? filterName,
    VoidCallback? onClearFilter,
  }) {
    return NoContentWidget(
      title: "No images found",
      description: filterName != null
          ? "No images available for '$filterName' filter. Try changing your filter or browse other styles."
          : "No images available Right Now write Creating Images",
      iconPath: 'assets/images/filter_empty.png',
      showActionButton: onClearFilter != null,
      actionText: 'Clear Filter',
      onActionPressed: onClearFilter,
    );
  }

  factory NoContentWidget.emptyCommunity() {
    return NoContentWidget(
      title: "Community is quiet",
      description: "Be the first to share your creation and inspire others!",
      iconPath: 'assets/images/community_empty.png',
      showActionButton: false,
    );
  }

  factory NoContentWidget.networkError({
    VoidCallback? onRetry,
  }) {
    return NoContentWidget(
      title: "Connection Error",
      description: "Unable to load images. Please check your internet connection and try again.",
      iconPath: 'assets/images/network_error.png',
      showActionButton: true,
      actionText: 'Retry',
      onActionPressed: onRetry,
    );
  }

  factory NoContentWidget.noSearchResults({String? query}) {
    return NoContentWidget(
      title: "No results found",
      description: query != null
          ? 'No posts found for "$query". Try different keywords or check your spelling.'
          : 'Try searching for prompts, usernames, or styles.',
      iconPath: 'assets/images/search_empty.png',
      showActionButton: false,
    );
  }

  factory NoContentWidget.noImages() {
    return NoContentWidget(
      title: "No images yet",
      description: "Start creating amazing AI art to see it appear here!",
      iconPath: 'assets/images/empty_state.png',
      showActionButton: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: backgroundColor ?? theme.colorScheme.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIllustration(theme),
              const SizedBox(height: 32),
              Text(
                title,
                style: AppTextstyle.interMedium(
                  fontSize: 20,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  description,
                  style: AppTextstyle.interRegular(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              if (showActionButton && onActionPressed != null)
                _buildActionButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration(ThemeData theme) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getIconForType(),
        size: 48,
        color: theme.colorScheme.onSurface.withOpacity(0.4),
      ),
    );
  }

  IconData _getIconForType() {
    if (title.toLowerCase().contains('filter')) {
      return Icons.filter_alt_outlined;
    } else if (title.toLowerCase().contains('community')) {
      return Icons.people_outline;
    } else if (title.toLowerCase().contains('error')) {
      return Icons.wifi_off_outlined;
    } else if (title.toLowerCase().contains('search') || title.toLowerCase().contains('results')) {
      return Icons.search_off_outlined;
    } else {
      return Icons.image_not_supported_outlined;
    }
  }

  Widget _buildActionButton(ThemeData theme) {
    return SizedBox(
      width: 160,
      child: ElevatedButton(
        onPressed: onActionPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (actionText == 'Clear Filter')
              const Icon(Icons.clear_all, size: 18),
            if (actionText == 'Retry')
              const Icon(Icons.refresh, size: 18),
            const SizedBox(width: 8),
            Text(
              actionText,
              style: AppTextstyle.interMedium(
                fontSize: 14,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}