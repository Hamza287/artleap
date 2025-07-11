import 'package:flutter_riverpod/flutter_riverpod.dart';

final helpScreenProvider = StateNotifierProvider<HelpScreenNotifier, bool>(
      (ref) => HelpScreenNotifier(),
);

class HelpScreenNotifier extends StateNotifier<bool> {
  HelpScreenNotifier() : super(false);

  void setLoading(bool isLoading) {
    state = isLoading;
  }
}