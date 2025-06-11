import 'package:extended_wrap/extended_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_static_data.dart';
import 'package:Artleap.ai/shared/shared.dart';

import '../../../../../providers/home_screen_provider.dart';

class FilterResultChips extends ConsumerWidget {
  const FilterResultChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allStyles = [...freePikStyles, ...textToImageStyles];

    return Container(
      constraints: const BoxConstraints(maxHeight: 350, maxWidth: 500
          // restrict height but allow vertical wrap inside
          ),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            GestureDetector( 
              onTap: () {
                ref.read(homeScreenProvider).clearFilteredList();
                Navigation.pop();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color:
                        ref.watch(homeScreenProvider).selectedStyleTitle == null
                            ? AppColors.pinkColor
                            : AppColors.white,
                  ),
                ),
                child: Text(
                  "All Styles",
                  style: AppTextstyle.interMedium(
                    fontSize: 12,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            ...allStyles.map((e) {
              return GestureDetector(
                onTap: () {
                  ref.read(homeScreenProvider).filteredListFtn(e["title"]!);
                  print(ref.watch(homeScreenProvider).filteredCreations);
                  Navigation.pop();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: ref.watch(homeScreenProvider).selectedStyleTitle ==
                              e["title"]
                          ? AppColors.pinkColor
                          : AppColors.white,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(e['icon']!),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        e["title"]!.toUpperCase(),
                        style: AppTextstyle.interRegular(
                          fontSize: 12,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
