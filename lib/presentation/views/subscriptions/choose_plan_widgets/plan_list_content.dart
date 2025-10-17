import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/subscriptions/subscription_model.dart';
import '../apple_payment_screen.dart';
import '../google_payment_screen.dart';
import 'plan_card.dart';
import '../../../../shared/constants/app_textstyle.dart';
import '../../../../providers/user_profile_provider.dart';
import '../../../../shared/constants/user_data.dart';

final selectedPlanProvider = StateProvider<SubscriptionPlanModel?>((ref) => null);

class PlanListContent extends ConsumerStatefulWidget {
  final List<SubscriptionPlanModel> plans;
  const PlanListContent({
    super.key,
    required this.plans,
  });

  @override
  ConsumerState<PlanListContent> createState() => _PlanListContentState();
}

class _PlanListContentState extends ConsumerState<PlanListContent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.plans.isNotEmpty) {
        ref.read(selectedPlanProvider.notifier).state = widget.plans.first;
      }
      ref.read(userProfileProvider).getUserProfileData(UserData.ins.userId ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final selectedPlan = ref.watch(selectedPlanProvider);

    SubscriptionPlanModel? weekly;
    SubscriptionPlanModel? monthly;
    SubscriptionPlanModel? yearly;

    for (var p in widget.plans) {
      final lower = p.type.toLowerCase();
      if (weekly == null && lower.contains('basic')) weekly = p;
      if (monthly == null && lower.contains('standard')) monthly = p;
      if (yearly == null && lower.contains('premium')) yearly = p;
    }

    // Fallbacks
    weekly ??= widget.plans.isNotEmpty ? widget.plans[0] : null;
    monthly ??= widget.plans.length > 1 ? widget.plans[1] : null;
    yearly ??= widget.plans.length > 2 ? widget.plans[2] : null;

    final plansToShow = [weekly, monthly, yearly].whereType<SubscriptionPlanModel>().toList();

    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < plansToShow.length; i++) ...[
              Expanded(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        ref.read(selectedPlanProvider.notifier).state = plansToShow[i];
                        // final route = Platform.isIOS
                        //     ? ApplePaymentScreen.routeName
                        //     : PaymentScreen.routeName;
                        // Navigator.pushNamed(context, route, arguments: plansToShow[i]);
                      },
                      child: PlanCard(
                        plan: plansToShow[i],
                        isCompact: true,
                        selected: selectedPlan?.id == plansToShow[i].id,
                        highlighted: plansToShow[i].type.toLowerCase().contains('standard'),
                      ),
                    ),
                    if (plansToShow[i].type.toLowerCase().contains('standard'))
                      Positioned(
                        right: -8,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD6B26A),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Text(
                            "Mostly Used",
                            style: AppTextstyle.interMedium(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (i < plansToShow.length - 1)
                SizedBox(width: screenSize.width * 0.035),
            ]
          ],
        ),
        SizedBox(height: screenSize.height * 0.025),
        _subscribeButton(context),
        SizedBox(height: screenSize.height * 0.02),
        Text(
          "\$${(selectedPlan?.price ?? monthly?.price ?? 0).toStringAsFixed(2)} billed annually. Cancel anytime.",
          style: AppTextstyle.interMedium(
            fontSize: 12,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: screenSize.height * 0.03),
      ],
    );
  }

  Widget _subscribeButton(BuildContext context) {
    final selectedPlan = ref.watch(selectedPlanProvider);
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          if (selectedPlan == null) return;
          final route = Platform.isIOS ? ApplePaymentScreen.routeName : GooglePaymentScreen.routeName;
          Navigator.pushNamed(context, route, arguments: selectedPlan);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFAF8B47),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 6,
          shadowColor: Colors.black45,
        ),
        child: Text(
          "SUBSCRIBE NOW",
          style: AppTextstyle.interBold(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
