import 'package:flutter_riverpod/flutter_riverpod.dart';

final interestOnboardingStepProvider = StateProvider<int>((ref) => 0);

// Add this to your providers file
final step1SelectedIndexProvider = StateProvider<int?>((ref) => null);
final step2SelectedIndexProvider = StateProvider<int?>((ref) => null);
final step3SelectedIndexProvider = StateProvider<int?>((ref) => null);
final step4SelectedIndexProvider = StateProvider<int?>((ref) => null);
