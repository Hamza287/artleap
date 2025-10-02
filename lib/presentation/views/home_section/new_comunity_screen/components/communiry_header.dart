import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/home_screen_provider.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
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
    final homeProvider = ref.watch(homeScreenProvider);
    final hasActiveFilter = homeProvider.selectedStyleTitle != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  color: AppColors.darkBlue,
                ),
              ),
              Text(
                'Discover amazing AI art',
                style: AppTextstyle.interRegular(
                  fontSize: 12,
                  color: Colors.grey.shade600,
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
                            colors: [AppColors.darkBlue, AppColors.pinkColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [
                              Colors.grey.shade100,
                              Colors.grey.shade100
                            ],
                          ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (hasActiveFilter ? AppColors.darkBlue : Colors.grey)
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
                            ? Colors.white
                            : Colors.grey.shade700,
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
                              ? Colors.white
                              : Colors.grey.shade700,
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
                      decoration: const BoxDecoration(
                        color: Colors.red,
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
