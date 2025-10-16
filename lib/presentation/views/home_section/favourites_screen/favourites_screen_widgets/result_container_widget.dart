import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/api_models/user_favourites_model.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:Artleap.ai/shared/navigation/screen_params.dart';

class ResultContainerWidget extends ConsumerWidget {
  final List<dynamic> data;
  const ResultContainerWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 0.85,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var reverseIndex = data.length - 1 - index;
          Favorites e = data[reverseIndex];
          return _buildFavoriteCard(context, e, theme);
        },
        childCount: data.length,
      ),
    );
  }

  Widget _buildFavoriteCard(
      BuildContext context, Favorites favorite, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        Navigation.pushNamed(
          SeePictureScreen.routeName,
          arguments: SeePictureParams(
            imageId: favorite.id,
            image: favorite.imageUrl,
            modelName: favorite.modelName,
            profileName: favorite.username,
            prompt: favorite.prompt,
            userId: favorite.userId,
            creatorEmail: favorite.creatorEmail,
            privacy: favorite.privacy,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Image
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: favorite.imageUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 300),
                  placeholder: (context, url) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: Icon(
                        Icons.error_outline_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (favorite.username.isNotEmpty)
                        Text(
                          favorite.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (favorite.prompt.isNotEmpty)
                        Text(
                          favorite.prompt,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),

              // Favorite Icon
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite_rounded,
                    color: theme.colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
