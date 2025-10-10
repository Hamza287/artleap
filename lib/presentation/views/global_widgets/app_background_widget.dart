import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/theme_provider.dart';

class AppBackgroundWidget extends ConsumerWidget {
  final Widget widget;
  const AppBackgroundWidget({super.key, required this.widget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(currentThemeProvider);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.colorScheme.surface,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            // gradient: _getBackgroundGradient(theme),
          ),
          child: widget,
        ),
      ),
    );
  }

  // LinearGradient? _getBackgroundGradient(ThemeData theme) {
  //   if (theme.brightness == Brightness.dark) {
  //     return const LinearGradient(
  //       begin: Alignment.topCenter,
  //       end: Alignment.bottomCenter,
  //       colors: [
  //         Color(0xFF1A1A2E),
  //         Color(0xFF16213E),
  //         Color(0xFF0F3460),
  //       ],
  //     );
  //   } else {
  //     return const LinearGradient(
  //       begin: Alignment.topCenter,
  //       end: Alignment.bottomCenter,
  //       colors: [
  //         Color(0xFFF8F9FA),
  //         Color(0xFFE9ECEF),
  //         Colors.white,
  //       ],
  //     );
  //   }
  // }
}