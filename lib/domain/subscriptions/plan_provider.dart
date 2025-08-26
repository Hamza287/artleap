import 'package:Artleap.ai/domain/subscriptions/subscription_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/api_services/api_response.dart';
import '../../domain/api_repos_abstract/user_profile_repo.dart';

final userProfileRepoProvider = Provider<UserProfileRepo>((ref) {
  throw UnimplementedError('UserProfileRepoImpl should be provided');
});

final plansProvider = FutureProvider<List<SubscriptionPlanModel>>((ref) async {
  final repo = ref.read(userProfileRepoProvider);
  final response = await repo.getSubscriptionPlans();
  if (response.status == Status.completed) {
    return response.data ?? [];
  } else {
    throw Exception(response.message ?? 'Failed to fetch plans');
  }
});

final selectedPlanProvider = StateProvider<SubscriptionPlanModel?>((ref) => null);

// final selectedPaymentMethodProvider = StateProvider<String?>((ref) => null);

// final termsAcceptedProvider = StateProvider<bool>((ref) => false);