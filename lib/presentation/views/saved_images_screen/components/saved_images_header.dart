import 'package:Artleap.ai/shared/route_export.dart';

class SavedImagesHeader extends ConsumerWidget {
  final AsyncValue<int> savedCountAsync;

  const SavedImagesHeader({
    super.key,
    required this.savedCountAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SliverAppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      pinned: true,
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary.withOpacity(0.1),
                theme.colorScheme.secondary.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primaryContainer,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.bookmark_rounded,
                        color: theme.colorScheme.onPrimary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saved Images',
                            style: AppTextstyle.interBold(
                              fontSize: 28,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildSavedCount(theme),
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
    );
  }

  Widget _buildSavedCount(ThemeData theme) {
    return savedCountAsync.when(
      data: (count) => Text(
        '$count ${count == 1 ? 'precious memory' : 'precious memories'} saved',
        style: AppTextstyle.interRegular(
          fontSize: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      loading: () => Text(
        'Loading your collection...',
        style: AppTextstyle.interRegular(
          fontSize: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      error: (error, stack) => Text(
        'Your saved collection',
        style: AppTextstyle.interRegular(
          fontSize: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
    );
  }
}