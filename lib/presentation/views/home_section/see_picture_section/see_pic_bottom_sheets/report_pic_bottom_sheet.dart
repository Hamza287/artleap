import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_pic_bottom_sheets/bottom_sheet_widget.dart/header_text.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_pic_bottom_sheets/bottom_sheet_widget.dart/row_buttons.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_pic_bottom_sheets/others_bottom_sheet.dart';
import 'package:Artleap.ai/providers/image_actions_provider.dart';
import '../../../../../shared/constants/app_static_data.dart';
import '../../../../../shared/shared.dart';

class ReportImageBottomSheet extends ConsumerWidget {
  final String? imageId;

  final String? creatorId;

  const ReportImageBottomSheet({super.key, this.imageId, this.creatorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 690,
      width: double.infinity,
      // margin: EdgeInsets.only(left: 10, right: 10),
      decoration: const BoxDecoration(
          color: AppColors.darkBlue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 10),
                child: InkWell(
                  onTap: () {
                    Navigation.pop();
                  },
                  child: const SizedBox(
                    height: 25,
                    width: 25,
                    child: Icon(
                      Icons.cancel,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          10.spaceY,
          const HeaderText(),
          ...reportOptions.map(
            (e) {
              return InkWell(
                onTap: () {
                  ref.watch(imageActionsProvider).reportReason = e["title"];
                  ref.watch(imageActionsProvider).reportReasonId = e["id"];
                },
                child: Container(
                  color:
                      ref.watch(imageActionsProvider).reportReason == e["title"]
                          ? AppColors.blue
                          : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        color: AppColors.white.withOpacity(0.3),
                      ),
                      20.spaceY,
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e["title"],
                              style: AppTextstyle.interRegular(
                                  color: AppColors.white, fontSize: 14),
                            ),
                            if (e["id"] == "5")
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.white,
                                size: 20,
                              )
                          ],
                        ),
                      ),
                      20.spaceY,
                      if (e["id"] == "5")
                        Container(
                          height: 1,
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          color: AppColors.white.withOpacity(0.3),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          40.spaceY,
          RowButtons(
            onSendPress: ref.watch(imageActionsProvider).reportReason == null
                ? () {}
                : ref.watch(imageActionsProvider).reportReasonId == "5"
                    ? () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return OthersBottomSheet(
                              onpress: ref
                                      .read(imageActionsProvider)
                                      .othersTextController
                                      .text
                                      .isEmpty
                                  ? () {}
                                  : () {
                                      ref
                                          .read(imageActionsProvider)
                                          .reportImage(imageId!, creatorId!);
                                    },
                            );
                          },
                        );
                      }
                    : () {
                        ref
                            .read(imageActionsProvider)
                            .reportImage(imageId!, creatorId!);
                      },
            onCancelPress: () {
              Navigation.pop();
            },
          )
        ],
      ),
    );
  }
}
