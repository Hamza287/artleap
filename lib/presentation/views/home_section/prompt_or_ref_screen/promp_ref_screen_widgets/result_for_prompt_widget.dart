import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photoroomapp/providers/generate_image_provider.dart';
import 'package:photoroomapp/shared/shared.dart';

class ResultForPromptWidget extends ConsumerWidget {
  const ResultForPromptWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(children: [
          TextSpan(
              text: "Results for your",
              style:
                  AppTextstyle.interBold(fontSize: 14, color: AppColors.white)),
          TextSpan(
              text: " Prompt",
              style:
                  AppTextstyle.interBold(fontSize: 14, color: AppColors.indigo))
        ])),
        10.spaceY,

        // ref.watch(generateImageProvider).generatedData == null ||
        //         ref.watch(generateImageProvider).generatedImage == null
        //     ? const SizedBox()
        //     : ref.watch(generateImageProvider).generatedData != null
        //         ?
        if (ref.watch(generateImageProvider).generatedData != null)
          Wrap(
            runSpacing: 10,
            spacing: 10,
            children: [
              ...ref.watch(generateImageProvider).generatedData!.output.map(
                (e) {
                  return Container(
                    height: 200,
                    width: 155,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: NetworkImage(e), fit: BoxFit.fill)),
                  );
                },
              )
            ],
          ),
        10.spaceY,
        if (ref.watch(generateImageProvider).generatedImage != null)
          Container(
            height: 400,
            margin: EdgeInsets.only(left: 0, right: 0),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(ref
                        .watch(generateImageProvider)
                        .generatedImage!
                        .output[0]),
                    fit: BoxFit.fill)),
          ),
        80.spaceY,
      ],
    );
  }
}
