import 'package:Artleap.ai/presentation/views/home_section/home_screen/home_screen_sections/home_screen_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/shared.dart';
import '../../../../../providers/user_profile_provider.dart';
import '../../../login_and_signup_section/login_section/login_screen.dart';
import 'components/action_buttons_row.dart';
import 'components/feature_buttons.dart';
import 'components/image_results_grid.dart';
import 'components/prompt_section.dart';
import 'components/result_header.dart';

class ResultScreenRedesign extends ConsumerStatefulWidget {
  const ResultScreenRedesign({super.key});
  static const String routeName = "result_screen";

  @override
  ConsumerState<ResultScreenRedesign> createState() =>
      _ResultScreenRedesignState();
}

class _ResultScreenRedesignState extends ConsumerState<ResultScreenRedesign> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = UserData.ins.userId;
      if (userId != null && userId.isNotEmpty) {
        ref.read(userProfileProvider).getUserProfileData(userId);
      } else {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(generateImageProvider).isGenerateImageLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Container(
            color: AppColors.topBar,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: HomeScreenTopBar(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const ResultHeader(),
            const SizedBox(height: 24),
            ImageResultsGrid(ref: ref),
            const SizedBox(height: 24),
            if (!isLoading) const ActionButtonsRow(),
            const SizedBox(height: 20),
            if (!isLoading)
              const FeatureButton(
                icon: Icons.auto_awesome,
                label: "Re Generate",
                isPrimary: true,
              ),
            const SizedBox(height: 24),
            PromptSection(ref: ref),
            const SizedBox(height: 20),
            if (!isLoading) ...[
              const FeatureButton(
                icon: Icons.open_in_full,
                label: "Upscale",
                isPrimary: true,
              ),
              const SizedBox(height: 12),
              const FeatureButton(
                icon: Icons.brush_outlined,
                label: "Add/Remove Object",
                isPrimary: true,
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
