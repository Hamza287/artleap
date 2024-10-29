import 'package:extended_wrap/extended_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_static_data.dart';
import 'package:photoroomapp/shared/shared.dart';

import '../../../../../providers/home_screen_provider.dart';

class FilterResultChips extends ConsumerWidget {
  const FilterResultChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExtendedWrap(
        maxLines: 8,
        minLines: 1,
        spacing: 8,
        runSpacing: 8,
        direction: Axis.horizontal,
        children: [
          ...freePikStyles.map(
            (e) {
              return GestureDetector(
                onTap: () {
                  ref.read(homeScreenProvider).filteredListFtn(e["title"]!);
                  Navigation.pop();
                },
                child: FittedBox(
                    child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppColors.white)),
                  child: Row(children: [
                    5.spaceX,
                    Text(e["title"]!,
                        style: AppTextstyle.interRegular(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: AppColors.white))
                  ]),
                )),
              );
            },
          )
        ]);
  }
}
