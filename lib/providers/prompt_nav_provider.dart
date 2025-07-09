import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PromptNavItem { create, edit, animate, enhance }

final promptNavProvider = StateNotifierProvider<PromptNavNotifier, PromptNavItem>(
      (ref) => PromptNavNotifier(),
);

class PromptNavNotifier extends StateNotifier<PromptNavItem> {
  PromptNavNotifier() : super(PromptNavItem.create);

  void setNavItem(PromptNavItem item) {
    state = item;
  }
}