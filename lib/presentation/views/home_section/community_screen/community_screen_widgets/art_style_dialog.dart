import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/shared.dart';
import 'filter_result_chips.dart';

class ArtStyleDilog extends ConsumerWidget {
  const ArtStyleDilog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 110, bottom: 140),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                  ),
                  child: GestureDetector(
                      onTap: () {
                        Navigation.pop();
                      },
                      child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(AppAssets.cross))),
                ),
              ],
            ),
            Text(
              "Filter Results",
              style: AppTextstyle.interMedium(
                  color: AppColors.darkBlue, fontSize: 16),
            ),
            10.spaceY,
            const FilterResultChips(),
            15.spaceY,
          ],
        ),
      ),
    );
  }
}
