import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';


final isPromptExpandedProvider = StateProvider<bool>((ref) => false);

class PostDescription extends ConsumerWidget {
  final dynamic image;

  const PostDescription({super.key, required this.image});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(isPromptExpandedProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          if (image.prompt != null && image.prompt!.isNotEmpty)
            GestureDetector(
              onTap: () {
                ref.read(isPromptExpandedProvider.notifier).state = !isExpanded;
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.darkBlue.withOpacity(0.05), AppColors.pinkColor.withOpacity(0.02)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.darkBlue.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              color: AppColors.darkBlue,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'AI Prompt',
                              style: AppTextstyle.interBold(
                                fontSize: 14,
                                color: AppColors.darkBlue,
                              ),
                            ),
                          ],
                        ),
                        // Expand/Collapse indicator
                        Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: AppColors.darkBlue.withOpacity(0.6),
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      image.prompt!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                      maxLines: isExpanded ? null : 3,
                      overflow: isExpanded ? TextOverflow.clip : TextOverflow.ellipsis,
                    ),
                    if (!isExpanded && _isTextLong(image.prompt!))
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Tap to expand',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.darkBlue.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  bool _isTextLong(String text) {
    // Consider text long if it has more than 100 characters or 2 lines worth
    return text.length > 100 || text.split('\n').length > 2;
  }
}