import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/plan_cards_provider.dart';
import 'choose_plan_widgets/plan_card.dart';

class ChoosePlanScreen extends ConsumerWidget {
  const ChoosePlanScreen({super.key});
  static const String routeName = "choose_plan_screen";

  final List<Map<String, dynamic>> plans = const [
    {
      'title': 'Basic',
      'description': 'Good for occasional use, limited features.',
      'generations': '50 Daily Generations',
      'features': [
        'Commercial Use',
        'Fast processing',
        '1 Simultaneous generation',
        'Basic AI Models',
        'No Watermark',
      ],
    },
    {
      'title': 'Standard',
      'description': 'Best for daily task, if you just generate for fun.',
      'generations': '150 Daily Generations',
      'features': [
        'Commercial Use',
        'Super fast processing',
        '2 Simultaneous generations',
        'Premium AI Models',
        'Batch Upscale',
        'No Watermark',
        'Ad-Free Experience',
      ],
    },
    {
      'title': 'Premium',
      'description': 'For professionals who need maximum capacity.',
      'generations': 'Unlimited Generations',
      'features': [
        'Commercial Use',
        'Ultra fast processing',
        '5 Simultaneous generations',
        'Premium AI Models',
        'Batch Upscale',
        'Priority Support',
        'No Watermark',
        'Ad-Free Experience',
      ],
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPlanIndex = ref.watch(planProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Choose Your Plan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select the plan that fits your needs',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10),

              // Plans Horizontal Scroll
              SizedBox(
                height: 480,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return PlanCard(
                      title: plan['title'],
                      description: plan['description'],
                      generations: plan['generations'],
                      features: List<String>.from(plan['features']),
                      isSelected: selectedPlanIndex == index,
                      index: index,
                    );
                  },
                ),
              ),

              const Spacer(),

              // Bottom White Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Plan: ${plans[selectedPlanIndex]['title']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      plans[selectedPlanIndex]['generations'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                        ).copyWith(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              return Colors.transparent;
                            },
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF61E6), Color(0xFF7D33F9)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'Continue with Plan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}