import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../../../domain/subscriptions/subscription_model.dart';
import 'choose_plan_widgets/plan_selection_content.dart';

final selectedPlanProvider = StateProvider<SubscriptionPlanModel?>((ref) => null);

class ChoosePlanScreen extends ConsumerWidget {
  const ChoosePlanScreen({super.key});
  static const String routeName = "choose_plan_screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Choose Your Plan',
          style: AppTextstyle.interBold(
            fontSize: 20,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.refresh),
          //   onPressed: () {
          //     ref.read(selectedPlanProvider.notifier).state = null;
          //     ref.invalidate(subscriptionPlansProvider);
          //   },
          // ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/planbg.png',
              fit: BoxFit.cover,
            ),
          ),
          const SafeArea(
            child: PlanSelectionContent(),
          ),
        ],
      ),
    );
  }
}
