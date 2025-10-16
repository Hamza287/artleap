import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:flutter/material.dart';

class AiFiltersGrid extends StatelessWidget {
  const AiFiltersGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filters = [
      _AiFilter(
        name: "Fantasy Portraits",
        backgroundImage: "https://images.unsplash.com/photo-1541963463532-d68292c34b19?w=400",
        isNew: true,
      ),
      _AiFilter(
        name: "Hunkify",
        backgroundImage: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400",
        isNew: true,
      ),
      _AiFilter(
        name: "AI Stickers",
        backgroundImage: "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=400",
      ),
      _AiFilter(
        name: "AI Headshots",
        backgroundImage: "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400",
      ),
      _AiFilter(
        name: "AI Scenes",
        backgroundImage: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400",
      ),
      _AiFilter(
        name: "AI Avatars",
        backgroundImage: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400",
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "AI Filters",
                    style: AppTextstyle.interMedium(
                      fontSize: 20,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, '/all-ai-filters');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "View All",
                            style: AppTextstyle.interMedium(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "Transform your images with a single click",
                style: AppTextstyle.interMedium(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            itemCount: filters.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              return _buildFilterCard(filters[index], theme, context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterCard(_AiFilter filter, ThemeData theme, BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
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
              Positioned.fill(
                child: Image.network(
                  filter.backgroundImage,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                          color: theme.colorScheme.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.error_outline_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 32,
                        ),
                      ),
                    );
                  },
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
                      Colors.black.withOpacity(0.6),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filter Name
                      Text(
                        filter.name,
                        style: AppTextstyle.interMedium(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Coming Soon",
                          style: AppTextstyle.interMedium(
                            fontSize: 10,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (filter.isNew)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "NEW",
                      style: AppTextstyle.interMedium(
                        fontSize: 8,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              if (!filter.isPremium)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 8,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          "PRO",
                          style: AppTextstyle.interMedium(
                            fontSize: 7,
                            color: Colors.white,
                          ),
                        ),
                      ],
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

class _AiFilter {
  final String name;
  final String backgroundImage;
  final bool isNew;
  final bool isPremium;

  const _AiFilter({
    required this.name,
    required this.backgroundImage,
    this.isNew = false,
    this.isPremium = false,
  });
}