import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/subscription_model/subscription_moderl.dart';

final subscriptionProvider = StateProvider<SubscriptionModel>((ref) {
  return SubscriptionModel(
    currentPlan: 'Premium',
    status: 'Active',
    nextBillingDate: DateTime.now().add(const Duration(days: 30)),
    remainingGenerations: 120,
    totalGenerations: 150,
    features: [
      'Commercial Use',
      'Ultra fast processing',
      '5 Simultaneous generations',
      'Premium AI Models',
      'Batch Upscale',
      'Priority Support',
      'No Watermark',
      'Ad-Free Experience',
    ],
  );
});