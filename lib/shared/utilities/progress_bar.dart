import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/interest_onboarding_controller.dart';

class ProgressBar extends ConsumerWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(interestOnboardingStepProvider);
    final progress = (step + 1) / 4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: Colors.grey.shade300,
        color: Colors.deepPurple,
        minHeight: 6,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
