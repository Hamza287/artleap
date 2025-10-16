import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../../../../domain/subscriptions/subscription_model.dart';

class PlanCard extends StatelessWidget {
  final SubscriptionPlanModel plan;
  final bool isCompact;
  final bool selected;
  final bool highlighted;

  const PlanCard({
    super.key,
    required this.plan,
    this.isCompact = false,
    this.selected = false,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final border = selected ? Border.all(color: const Color(0xFFD9B86F), width: 3) : null;
    final radius = BorderRadius.circular(16);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.022,
        horizontal: size.width * 0.045,
      ),
      decoration: BoxDecoration(
        borderRadius: radius,
        border: border,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: highlighted
              ? [const Color(0xFF2B2B2B), const Color(0xFF0E0E0E)]
              : [const Color(0xFF1C1C1C), const Color(0xFF0B0B0B)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // PLAN NAME
          Text(
            plan.name.toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTextstyle.interMedium(
              fontSize: size.width * 0.035,
              color: Colors.white.withOpacity(0.9),
            ),
          ),

          SizedBox(height: size.height * 0.012),

          // PRICE + PERIOD
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '\$${plan.price.toStringAsFixed(0)}',
                  style: AppTextstyle.interBold(
                    fontSize: size.width * 0.085,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  _periodText(plan),
                  style: AppTextstyle.interMedium(
                    fontSize: size.width * 0.032,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: size.height * 0.008),

          // SUBTEXT (optional visual polish)
          Text(
            _planDurationLabel(plan),
            textAlign: TextAlign.center,
            style: AppTextstyle.interMedium(
              fontSize: size.width * 0.028,
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }

  String _periodText(SubscriptionPlanModel plan) {
    final lower = plan.type.toLowerCase();
    if (lower.contains('basic')) return '/week';
    if (lower.contains('standard')) return '/month';
    if (lower.contains('premium')) return '/year';
    return '';
  }

  String _planDurationLabel(SubscriptionPlanModel plan) {
    final lower = plan.type.toLowerCase();
    if (lower.contains('basic')) return 'Weekly Plan';
    if (lower.contains('standard')) return 'Monthly Plan';
    if (lower.contains('premium')) return 'Yearly Plan';
    return '';
  }
}
