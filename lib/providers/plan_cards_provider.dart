import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlanNotifier extends StateNotifier<int> {
  PlanNotifier() : super(1); // Default to Standard plan

  void selectPlan(int index) {
    state = index;
  }
}

final planProvider = StateNotifierProvider<PlanNotifier, int>((ref) {
  return PlanNotifier();
});