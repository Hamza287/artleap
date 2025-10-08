import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../../../../../shared/app_snack_bar.dart';

class PromptTextWidget extends ConsumerWidget {
  final String? prompt;
  const PromptTextWidget({super.key, this.prompt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.text_fields_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "AI Prompt Details",
                      style: AppTextstyle.interMedium(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: prompt!)).whenComplete(
                            () {
                          appSnackBar("Copied", "Prompt copied to clipboard", AppColors.green);
                        },
                      );
                    },
                    icon: Icon(Icons.copy_rounded, color: Colors.white, size: 20),
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: Colors.black26.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(minHeight: 150, maxHeight: 250),
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Text(
                      prompt!,
                      style: AppTextstyle.interRegular(
                        color: AppColors.darkBlue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.grey.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.all(16),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       // Category Name Container Button
                //       Expanded(
                //         child: Container(
                //           margin: const EdgeInsets.only(right: 8),
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(16),
                //             boxShadow: [
                //               BoxShadow(
                //                 color: Colors.grey.withOpacity(0.2),
                //                 spreadRadius: 1,
                //                 blurRadius: 8,
                //                 offset: const Offset(0, 3),
                //               )
                //             ],
                //             border: Border.all(color: Colors.grey.shade200),
                //           ),
                //           child: Material(
                //             color: Colors.transparent,
                //             child: InkWell(
                //               borderRadius: BorderRadius.circular(16),
                //               onTap: () {
                //                 // Handle category name button press
                //               },
                //               child: Padding(
                //                 padding: const EdgeInsets.symmetric(
                //                     vertical: 16, horizontal: 12),
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   children: [
                //                     Icon(Icons.category_outlined,
                //                         color: AppColors.purple, size: 18),
                //                     const SizedBox(width: 8),
                //                     Flexible(
                //                       child: Text(
                //                         "Category Name",
                //                         style: AppTextstyle.interMedium(fontSize: 12),
                //                         overflow: TextOverflow.ellipsis,
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //
                //       // Reference Image Container Button
                //       Expanded(
                //         child: Container(
                //           margin: const EdgeInsets.only(left: 8),
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(16),
                //             boxShadow: [
                //               BoxShadow(
                //                 color: Colors.grey.withOpacity(0.2),
                //                 spreadRadius: 1,
                //                 blurRadius: 8,
                //                 offset: const Offset(0, 3),
                //               )
                //             ],
                //             border: Border.all(color: Colors.grey.shade200),
                //           ),
                //           child: Material(
                //             color: Colors.transparent,
                //             child: InkWell(
                //               borderRadius: BorderRadius.circular(16),
                //               onTap: () {
                //                 // Handle reference image button press
                //               },
                //               child: Padding(
                //                 padding: const EdgeInsets.symmetric(
                //                     vertical: 16, horizontal: 12),
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   children: [
                //                     Icon(Icons.image_outlined,
                //                         color: AppColors.purple, size: 18),
                //                     const SizedBox(width: 8),
                //                     Flexible(
                //                       child: Text(
                //                         "Reference Image",
                //                         style: AppTextstyle.interMedium(fontSize: 12),
                //                         overflow: TextOverflow.ellipsis,
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}