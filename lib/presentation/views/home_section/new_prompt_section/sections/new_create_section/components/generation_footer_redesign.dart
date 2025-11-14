import 'package:Artleap.ai/presentation/views/home_section/new_prompt_section/sections/new_create_section/components/prompt_generate_button.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class GenerationFooterRedesign extends ConsumerWidget {
  final VoidCallback onGenerate;
  final bool isLoading;

  const GenerationFooterRedesign({
    super.key,
    required this.onGenerate,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final generateImageProviderState = ref.watch(generateImageProvider);
    final userProfile = ref.watch(userProfileProvider).userProfileData;
    final credits = userProfile?.user.totalCredits ?? 0;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface.withOpacity(0.0),
              theme.colorScheme.surface.withOpacity(0.3),
              theme.colorScheme.surface.withOpacity(0.6),
              theme.colorScheme.surface.withOpacity(0.8),
              theme.colorScheme.surface.withOpacity(0.9),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Credits Info
                // _buildCreditsInfo(theme, credits),
                const SizedBox(height: 16),
                PromptScreenButtonRedesign(
                  height: 56,
                  width: double.infinity,
                  imageIcon: AppAssets.generateicon,
                  title: "Generate Art",
                  suffixRow: true,
                  credits: generateImageProviderState.images.isNotEmpty ? '24' : '2',
                  onpress: onGenerate,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildCreditsInfo(ThemeData theme, int credits) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //     decoration: BoxDecoration(
  //       color: theme.colorScheme.primary.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(
  //         color: theme.colorScheme.primary.withOpacity(0.2),
  //       ),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(
  //               Icons.bolt_rounded,
  //               color: theme.colorScheme.primary,
  //               size: 20,
  //             ),
  //             const SizedBox(width: 8),
  //             Text(
  //               "Available Credits",
  //               style: AppTextstyle.interMedium(
  //                 color: theme.colorScheme.onSurface,
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ],
  //         ),
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //           decoration: BoxDecoration(
  //             color: theme.colorScheme.primary,
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           child: Text(
  //             credits.toString(),
  //             style: AppTextstyle.interMedium(
  //               color: theme.colorScheme.onPrimary,
  //               fontSize: 14,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}