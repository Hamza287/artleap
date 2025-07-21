import 'package:flutter_riverpod/flutter_riverpod.dart';

class RefreshNotifier extends StateNotifier<bool> {
  RefreshNotifier() : super(false);

  void refresh() {
    // Toggle to force UI to re-fetch
    state = !state;
  }
}

final refreshProvider = StateNotifierProvider<RefreshNotifier, bool>(
      (ref) => RefreshNotifier(),
);