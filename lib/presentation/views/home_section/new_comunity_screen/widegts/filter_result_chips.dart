import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_static_data.dart';
import 'package:Artleap.ai/shared/shared.dart';
import '../../../../../providers/home_screen_provider.dart';

class FilterResultChips extends ConsumerWidget {
  const FilterResultChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allStyles = [...freePikStyles, ...textToImageStyles];

    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            // All Styles Chip
            FilterChip(
              selected: ref.watch(homeScreenProvider).selectedStyleTitle == null,
              onSelected: (selected) {
                if (selected) {
                  ref.read(homeScreenProvider).clearFilteredList();
                }
              },
              label: Text(
                "All Styles",
                style: AppTextstyle.interMedium(
                  fontSize: 13,
                  color: ref.watch(homeScreenProvider).selectedStyleTitle == null
                      ? Colors.white
                      : AppColors.darkBlue,
                ),
              ),
              selectedColor: AppColors.darkBlue,
              backgroundColor: Colors.grey.shade100,
              side: BorderSide(
                color: ref.watch(homeScreenProvider).selectedStyleTitle == null
                    ? AppColors.darkBlue
                    : Colors.grey.shade300,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            // Style Chips
            ...allStyles.map((e) {
              final isSelected = ref.watch(homeScreenProvider).selectedStyleTitle == e["title"];
              return FilterChip(
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    ref.read(homeScreenProvider).filteredListFtn(e["title"]!);
                  }
                },
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(e['icon']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      e["title"]!,
                      style: AppTextstyle.interMedium(
                        fontSize: 13,
                        color: isSelected ? Colors.white : AppColors.darkBlue,
                      ),
                    ),
                  ],
                ),
                selectedColor: AppColors.darkBlue,
                backgroundColor: Colors.grey.shade100,
                side: BorderSide(
                  color: isSelected ? AppColors.darkBlue : Colors.grey.shade300,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}