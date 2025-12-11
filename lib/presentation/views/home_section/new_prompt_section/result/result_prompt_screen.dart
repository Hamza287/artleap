import 'components/action_buttons_row.dart';
import 'components/image_results_grid.dart';
import 'components/result_header.dart';
import 'package:Artleap.ai/shared/route_export.dart';

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
        ref.read(userProfileProvider.notifier).getUserProfileData(userId);
      } else {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = ref.watch(generateImageProvider).isGenerateImageLoading;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Container(
            color: theme.colorScheme.surface,
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
            if (!isLoading) ActionButtonsRow(ref: ref),
            const SizedBox(height: 20),
            // if (!isLoading)
            //   const FeatureButton(
            //     icon: Icons.auto_awesome,
            //     label: "Re Generate",
            //     isPrimary: true,
            //   ),
            // const SizedBox(height: 24),
            // PromptSection(ref: ref),
            // const SizedBox(height: 20),
            // if (!isLoading) ...[
            //   const FeatureButton(
            //     icon: Icons.open_in_full,
            //     label: "Upscale",
            //     isPrimary: true,
            //   ),
            //   const SizedBox(height: 12),
            //   const FeatureButton(
            //     icon: Icons.brush_outlined,
            //     label: "Add/Remove Object",
            //     isPrimary: true,
            //   ),
            // ],
            // const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}