import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/home_screen_provider.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../widegts/art_style_dialog.dart';


class CommunityHeader extends ConsumerStatefulWidget {
  const CommunityHeader({super.key});

  @override
  ConsumerState<CommunityHeader> createState() => _CommunityHeaderState();
}

class _CommunityHeaderState extends ConsumerState<CommunityHeader> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeProvider = ref.watch(homeScreenProvider);
    final hasActiveFilter = homeProvider.selectedStyleTitle != null;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Community',
                style: AppTextstyle.interBold(
                  fontSize: 24,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'Discover amazing AI art',
                style: AppTextstyle.interRegular(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => {
              showDialog(
                context: context,
                builder: (context) => const ArtStyleDialog(),
              ),
            },
            child: Stack(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: hasActiveFilter
                        ? LinearGradient(
                      colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : LinearGradient(
                      colors: [
                        theme.colorScheme.surfaceVariant,
                        theme.colorScheme.surfaceVariant
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color:
                        (hasActiveFilter ? theme.colorScheme.primary : theme.colorScheme.outline)
                            .withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.filter_alt_rounded,
                        color: hasActiveFilter
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        hasActiveFilter
                            ? homeProvider.selectedStyleTitle!
                            : 'Filter',
                        style: AppTextstyle.interMedium(
                          fontSize: 14,
                          color: hasActiveFilter
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasActiveFilter)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                      ),
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