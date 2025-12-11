import 'package:Artleap.ai/ads/rewarded_ads/user_credits_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RewardedAdInitializer extends ConsumerWidget {
  final Widget child;

  const RewardedAdInitializer({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditsState = ref.watch(userCreditsNotifierProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!creditsState.isLoading && creditsState.credits == 0) {
        ref.read(userCreditsNotifierProvider.notifier).fetchUserCredits();
      }
    });

    return child;
  }
}