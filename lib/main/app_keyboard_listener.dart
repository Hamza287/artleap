import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/keyboard_provider.dart';

class AppKeyboardListener extends ConsumerStatefulWidget {
  final Widget child;
  const AppKeyboardListener({super.key, required this.child});

  @override
  ConsumerState<AppKeyboardListener> createState() => _AppKeyboardListenerState();
}

class _AppKeyboardListenerState extends ConsumerState<AppKeyboardListener> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final isVisible = bottomInset > 0.0;
    ref.read(keyboardVisibleProvider.notifier).state = isVisible;
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
