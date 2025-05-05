import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/home_section/home_screen/home_screen_widgets/filter_result_chips.dart';
import 'package:photoroomapp/shared/shared.dart';

import '../../../../../providers/home_screen_provider.dart';
import '../../../../../providers/models_list_provider.dart';

class ArtStyleDilog extends ConsumerWidget {
  const ArtStyleDilog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 110, bottom: 140),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.blue,
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
                  color: AppColors.white, fontSize: 16),
            ),
            10.spaceY,
            const FilterResultChips(),
            15.spaceY,
            // Wrap(
            //   runSpacing: 10,
            //   spacing: 5,
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         ref.read(homeScreenProvider).clearFilteredList();
            //         Navigation.pop();
            //       },
            //       child: Container(
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(3),
            //           border: Border.all(color: AppColors.pinkColor),
            //         ),
            //         child: Padding(
            //           padding: const EdgeInsets.all(6.0),
            //           child: Text("All Styles",
            //               style: AppTextstyle.interMedium(
            //                   fontSize: 10, color: AppColors.white)),
            //         ),
            //       ),
            //     ),
            //     ...ref
            //         .watch(homeScreenProvider)
            //         .communityImagesList
            //         .map((img) => img.modelName)
            //         .toSet()
            //         .map((e) {
            //       return GestureDetector(
            //         onTap: () {
            //           ref.read(homeScreenProvider).filteredListFtn(e);
            //           print(e);
            //           print(ref.watch(homeScreenProvider).filteredCreations);

            //           Navigation.pop();
            //         },
            //         child: Container(
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(3),
            //             border: Border.all(
            //               color: ref
            //                       .watch(homeScreenProvider)
            //                       .filteredCreations
            //                       .any((img) => img?.modelName == e)
            //                   ? AppColors.pinkColor
            //                   : Colors.transparent,
            //             ),
            //           ),
            //           child: Column(
            //             children: [
            //               Container(
            //                 height: 60,
            //                 width: 58,
            //                 margin: const EdgeInsets.only(right: 5),
            //                 decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(5),
            //                   color: AppColors.blue,
            //                 ),
            //                 child: ClipRRect(
            //                   borderRadius: BorderRadius.circular(5),
            //                   child: CachedNetworkImage(
            //                     imageUrl: e,
            //                     fit: BoxFit.cover,
            //                   ),
            //                 ),
            //               ),
            //               SizedBox(
            //                 width: 60,
            //                 child: Text(
            //                   e,
            //                   style: AppTextstyle.interRegular(
            //                       fontSize: 10, color: AppColors.white),
            //                   overflow: TextOverflow.ellipsis,
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       );
            //     }),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
