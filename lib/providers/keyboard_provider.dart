import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final keyboardVisibleProvider = StateProvider<bool>((ref) => false);

final keyboardControllerProvider = Provider<KeyboardController>((ref) {
  return KeyboardController(ref);
});

class KeyboardController {
  final Ref ref;
  KeyboardController(this.ref);

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
    ref.read(keyboardVisibleProvider.notifier).state = false;
  }

  void showKeyboard(FocusNode node) {
    node.requestFocus();
    ref.read(keyboardVisibleProvider.notifier).state = true;
  }

  void setVisible(bool visible) {
    ref.read(keyboardVisibleProvider.notifier).state = visible;
  }
}
