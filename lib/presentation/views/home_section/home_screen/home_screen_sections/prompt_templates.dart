import 'package:Artleap.ai/widgets/common/app_snack_bar.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:flutter/material.dart';

class PromptTemplates extends StatelessWidget {
  const PromptTemplates({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final templates = [
      _PromptTemplate(
        name: "Fantasy Adventure",
        description: "Epic quests and magical worlds",
        backgroundImage: "https://images.unsplash.com/photo-1541963463532-d68292c34b19?w=400",
        category: "Adventure",
      ),
      _PromptTemplate(
        name: "Sci-Fi Future",
        description: "Futuristic cities and technology",
        backgroundImage: "https://images.unsplash.com/photo-1489599809505-fbe13c069980?w=400",
        category: "Sci-Fi",
      ),
      _PromptTemplate(
        name: "Mystery Noir",
        description: "Dark detective stories",
        backgroundImage: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400",
        category: "Mystery",
      ),
      _PromptTemplate(
        name: "Romantic Scene",
        description: "Love stories and emotions",
        backgroundImage: "https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=400",
        category: "Romance",
      ),
      _PromptTemplate(
        name: "Horror Night",
        description: "Spooky and scary scenarios",
        backgroundImage: "https://images.unsplash.com/photo-1509248961151-e30a8c8c0a07?w=400",
        category: "Horror",
      ),
      _PromptTemplate(
        name: "Comedy Moment",
        description: "Funny and humorous situations",
        backgroundImage: "https://images.unsplash.com/photo-1541336032412-2048a678540d?w=400",
        category: "Comedy",
      ),
      _PromptTemplate(
        name: "Historical Epic",
        description: "Ancient civilizations and events",
        backgroundImage: "https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400",
        category: "History",
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Prompt Templates",
                    style: AppTextstyle.interMedium(
                      fontSize: 20,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Ready-to-use creative prompts",
                    style: AppTextstyle.interMedium(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, '/all-prompt-templates');
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
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              return _buildTemplateCard(templates[index], theme, context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateCard(_PromptTemplate template, ThemeData theme, BuildContext context) {
    return GestureDetector(
      onTap: () {
        appSnackBar('Template', 'Using template: ${template.name}');
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
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
                  template.backgroundImage,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.description_rounded,
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              template.name,
                              style: AppTextstyle.interMedium(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
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
                      Colors.black.withOpacity(0.8),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          template.category,
                          style: AppTextstyle.interMedium(
                            fontSize: 8,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        template.name,
                        style: AppTextstyle.interMedium(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        template.description,
                        style: AppTextstyle.interMedium(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 10,
                        color: theme.colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        "Use",
                        style: AppTextstyle.interMedium(
                          fontSize: 10,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Coming\nSoon",
                            textAlign: TextAlign.center,
                            style: AppTextstyle.interMedium(
                              fontSize: 10,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
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

class _PromptTemplate {
  final String name;
  final String description;
  final String backgroundImage;
  final String category;

  const _PromptTemplate({
    required this.name,
    required this.description,
    required this.backgroundImage,
    required this.category,
  });
}