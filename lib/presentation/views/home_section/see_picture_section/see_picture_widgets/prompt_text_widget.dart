import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';

import '../../../../../shared/app_snack_bar.dart';

class PromptTextWidget extends ConsumerWidget {
  final String? prompt;
  const PromptTextWidget({super.key, this.prompt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Prompt details",
                style: AppTextstyle.interBold(
                    color: AppColors.darkBlue, fontSize: 14),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: prompt!)).whenComplete(
                        () {
                      appSnackBar("Copied", "Prompt copied to clipboard",
                          AppColors.green);
                    },
                  );
                },
                child: Image.asset(
                  AppAssets.copyicon,
                  scale: 2.50,
                  color: AppColors.darkBlue,
                ),
              )
            ],
          ),
        ),
        10.spaceY,
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0x30875EFF),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  margin:
                  EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 7),
                    child: Text(
                      prompt!,
                      style: AppTextstyle.interRegular(
                          color: Colors.black54, fontSize: 11),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Category Name Container Button
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            )
                          ],
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              // Handle category name button press
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.category_outlined,
                                      color: AppColors.purple),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Category Name",
                                    style: AppTextstyle.interMedium(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Reference Image Container Button
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            )
                          ],
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              // Handle reference image button press
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_outlined,
                                      color: AppColors.purple),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Reference Image",
                                    style: AppTextstyle.interMedium(fontSize: 12),
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
              ],
            ),
          ),
        )
      ],
    );
  }
}