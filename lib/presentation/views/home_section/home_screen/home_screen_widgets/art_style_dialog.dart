import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/home_section/home_screen/home_screen_widgets/filter_result_chips.dart';
import 'package:photoroomapp/providers/home_screen_provider.dart';
import 'package:photoroomapp/providers/models_list_provider.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';
import 'package:photoroomapp/shared/navigation/navigation.dart';
import 'package:photoroomapp/shared/shared.dart';

import '../../../../../shared/constants/app_static_data.dart';

class ArtStyleDilog extends ConsumerWidget {
  const ArtStyleDilog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 110, bottom: 140),
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
                      child: Container(
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
            FilterResultChips(),
            15.spaceY,
            // Text(
            //   "Filter Artstyles",
            //   style: AppTextstyle.interMedium(
            //       color: AppColors.white, fontSize: 16),
            // ),
            // 10.spaceY,
            // Wrap(
            //   runSpacing: 10,
            //   spacing: 5,
            //   children: [
            //     ...ref
            //         .watch(modelsListProvider)
            //         .dataOfModels
            //         .take(6)
            //         .map(
            //           (e) {
            //             return e.modelName == "Mo Di Diffusion"
            //                 ? GestureDetector(
            //                     onTap: () {
            //                       ref
            //                           .read(homeScreenProvider)
            //                           .clearFilteredList();
            //                       Navigation.pop();
            //                     },
            //                     child: Container(
            //                         // width: 66,
            //                         decoration: BoxDecoration(
            //                             borderRadius: BorderRadius.circular(3),
            //                             border: Border.all(
            //                                 color: ref
            //                                         .watch(homeScreenProvider)
            //                                         .filteredCreations
            //                                         .isEmpty
            //                                     ? AppColors.pinkColor
            //                                     : Colors.transparent)),
            //                         child: Padding(
            //                           padding: const EdgeInsets.only(
            //                               top: 5, left: 4, bottom: 4),
            //                           child: Container(
            //                             height: 62,
            //                             width: 56,
            //                             margin: const EdgeInsets.only(right: 5),
            //                             decoration: BoxDecoration(
            //                                 borderRadius:
            //                                     BorderRadius.circular(5),
            //                                 color: AppColors.lightIndigo),
            //                             child: Column(
            //                               mainAxisAlignment:
            //                                   MainAxisAlignment.center,
            //                               children: [
            //                                 Padding(
            //                                   padding: EdgeInsets.only(
            //                                       left: 3, right: 3),
            //                                   child: Text(
            //                                     "All Styles",
            //                                     style: AppTextstyle.interMedium(
            //                                         fontSize: 10,
            //                                         color: AppColors.white),
            //                                   ),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         )))
            //                 : GestureDetector(
            //                     onTap: () {
            //                       print(e.modelId);
            //                       ref
            //                           .read(homeScreenProvider)
            //                           .filteredListFtn(e.modelId);
            //                       Navigation.pop();
            //                     },
            //                     child: Container(
            //                       // width: 66,
            //                       decoration: BoxDecoration(
            //                           borderRadius: BorderRadius.circular(3),
            //                           border: Border.all(
            //                               color: ref
            //                                       .watch(homeScreenProvider)
            //                                       .filteredCreations
            //                                       .any(
            //                                         (element) =>
            //                                             element["model_name"] ==
            //                                             e.modelId,
            //                                       )
            //                                   ? AppColors.pinkColor
            //                                   : Colors.transparent)),
            //                       child: Padding(
            //                         padding:
            //                             const EdgeInsets.only(top: 5, left: 4),
            //                         child: Column(
            //                           crossAxisAlignment:
            //                               CrossAxisAlignment.center,
            //                           mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                           children: [
            //                             Container(
            //                               height: 60,
            //                               width: 58,
            //                               margin:
            //                                   const EdgeInsets.only(right: 5),
            //                               decoration: BoxDecoration(
            //                                 borderRadius:
            //                                     BorderRadius.circular(5),
            //                                 color: AppColors.blue,
            //                               ),
            //                               child: Padding(
            //                                   padding: const EdgeInsets.only(
            //                                       left: 2),
            //                                   child: Padding(
            //                                     padding: const EdgeInsets.only(
            //                                         right: 2),
            //                                     child: ClipRRect(
            //                                       borderRadius:
            //                                           BorderRadius.circular(5),
            //                                       child: CachedNetworkImage(
            //                                         imageUrl: e.screenshots,
            //                                         fit: BoxFit.cover,
            //                                       ),
            //                                     ),
            //                                   )),
            //                             ),
            //                             Container(
            //                               width: 60,
            //                               child: Text(
            //                                 e.modelId,
            //                                 style: AppTextstyle.interRegular(
            //                                     fontSize: 10,
            //                                     color: AppColors.white),
            //                                 overflow: TextOverflow.ellipsis,
            //                               ),
            //                             )
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   );
            //           },
            //         )
            //         .toList()
            //         .reversed
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
