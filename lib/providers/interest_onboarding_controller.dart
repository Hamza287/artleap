import 'package:flutter_riverpod/flutter_riverpod.dart';

final interestOnboardingStepProvider = StateProvider<int>((ref) => 0);

// Add this to your providers file
final selectedRoleIndexProvider = StateProvider<int?>((ref) => null);