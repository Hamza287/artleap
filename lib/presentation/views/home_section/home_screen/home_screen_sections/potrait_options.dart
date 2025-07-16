import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:flutter/material.dart';

class PortraitOptions extends StatelessWidget {
  const PortraitOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final options = ["Better Selfie", "Old Photo", "Cool Headshot"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title at the top
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 8),
          child: Text(
            "Portrait",
            style: AppTextstyle.interMedium(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),

        // Boxes row below
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: options.map((label) {
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9EBF5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(Icons.add_circle,color: Colors.transparent,),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: AppTextstyle.interMedium(

                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}