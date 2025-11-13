import 'package:Artleap.ai/widgets/custom_text/custom_text_widget.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/navigation/navigator_key.dart';

final snackbarVisibilityProvider = StateProvider<bool>((ref) => true);

void appSnackBar(
    String title,
    String message, {
      Color backgroundColor = Colors.green,
      Color textColor = Colors.white,
      Color titleColor = Colors.white,
      Duration duration = const Duration(seconds: 2),
      FlushbarPosition position = FlushbarPosition.BOTTOM,
      bool showProgressIndicator = false,
      FlushbarStyle flushbarStyle = FlushbarStyle.FLOATING,
      EdgeInsets margin = const EdgeInsets.all(16),
      BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12)),
      bool isDismissible = true,
      bool shouldIconPulse = true,
      IconData? icon,
      Color? iconColor,
      VoidCallback? onDismiss,
    }) {
  final BuildContext? context = appContext ?? navigatorKey.currentContext;

  void showFlushbar() {
    if (context == null || !context.mounted) {
      debugPrint('Cannot show Flushbar: Context is null or not mounted. Message: $title - $message');
      return;
    }

    final container = ProviderContainer();

    Flushbar(
      titleText: AppText(
        title,
        size: 16,
        weight: FontWeight.w600,
        color: titleColor,
      ),
      messageText: AppText(
        message,
        size: 14,
        weight: FontWeight.w400,
        color: textColor,
      ),
      flushbarPosition: position,
      backgroundColor: backgroundColor,
      duration: duration,
      margin: margin,
      borderRadius: borderRadius,
      isDismissible: isDismissible,
      shouldIconPulse: shouldIconPulse,
      showProgressIndicator: showProgressIndicator,
      flushbarStyle: flushbarStyle,
      icon: icon != null
          ? Icon(
        icon,
        color: iconColor ?? textColor,
        size: 24,
      )
          : _getDefaultIcon(backgroundColor),
      mainButton: isDismissible
          ? TextButton(
        onPressed: () {
          container.read(snackbarVisibilityProvider.notifier).state = false;
          onDismiss?.call();
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: AppText(
          'DISMISS',
          size: 12,
          weight: FontWeight.bold,
          color: textColor,
        ),
      )
          : null,
      onStatusChanged: (status) {
        if (status == FlushbarStatus.DISMISSED) {
          container.read(snackbarVisibilityProvider.notifier).state = false;
          onDismiss?.call();
          container.dispose();
        }
      },
    ).show(context);
  }

  if (context == null || !context.mounted) {
    debugPrint('Context not available immediately, scheduling Flushbar for next frame');
    SchedulerBinding.instance.addPostFrameCallback((_) {
      showFlushbar();
    });
    return;
  }

  showFlushbar();
}

class AppSnackBarHelper {
  static void showDismissibleSnackBar({
    required WidgetRef ref,
    required String title,
    required String message,
    Color backgroundColor = Colors.green,
    VoidCallback? onDismiss,
  }) {
    final BuildContext? context = appContext ?? navigatorKey.currentContext;

    if (context == null || !context.mounted) return;

    ref.read(snackbarVisibilityProvider.notifier).state = true;

    Flushbar(
      titleText: AppText(
        title,
        size: 16,
        weight: FontWeight.w600,
        color: Colors.white,
      ),
      messageText: AppText(
        message,
        size: 14,
        weight: FontWeight.w400,
        color: Colors.white,
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
      mainButton: TextButton(
        onPressed: () {
          ref.read(snackbarVisibilityProvider.notifier).state = false;
          onDismiss?.call();
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: AppText(
          'DISMISS',
          size: 12,
          weight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      onStatusChanged: (status) {
        if (status == FlushbarStatus.DISMISSED) {
          ref.read(snackbarVisibilityProvider.notifier).state = false;
          onDismiss?.call();
        }
      },
    ).show(context);
  }
}

Icon? _getDefaultIcon(Color backgroundColor) {
  if (backgroundColor == Colors.red ||
      backgroundColor == Colors.redAccent ||
      backgroundColor.value == Colors.red.value) {
    return Icon(Icons.error_outline, color: Colors.white, size: 24);
  } else if (backgroundColor == Colors.orange ||
      backgroundColor == Colors.orangeAccent) {
    return Icon(Icons.warning_amber, color: Colors.white, size: 24);
  } else if (backgroundColor == Colors.blue ||
      backgroundColor == Colors.blueAccent) {
    return Icon(Icons.info_outline, color: Colors.white, size: 24);
  } else if (backgroundColor == Colors.green ||
      backgroundColor == Colors.greenAccent) {
    return Icon(Icons.check_circle_outline, color: Colors.white, size: 24);
  }
  return null;
}

void appSuccessSnackBar(
    String title,
    String message, {
      FlushbarPosition position = FlushbarPosition.BOTTOM,
      VoidCallback? onDismiss,
    }) {
  appSnackBar(
    title,
    message,
    backgroundColor: Colors.green,
    icon: Icons.check_circle_outline,
    position: position,
    onDismiss: onDismiss,
  );
}

void appErrorSnackBar(
    String title,
    String message, {
      FlushbarPosition position = FlushbarPosition.BOTTOM,
      VoidCallback? onDismiss,
    }) {
  appSnackBar(
    title,
    message,
    backgroundColor: Colors.redAccent,
    icon: Icons.error_outline,
    position: position,
    onDismiss: onDismiss,
  );
}

void appWarningSnackBar(
    String title,
    String message, {
      FlushbarPosition position = FlushbarPosition.BOTTOM,
      VoidCallback? onDismiss,
    }) {
  appSnackBar(
    title,
    message,
    backgroundColor: Colors.orangeAccent,
    icon: Icons.warning_amber,
    position: position,
    onDismiss: onDismiss,
  );
}

void appInfoSnackBar(
    String title,
    String message, {
      FlushbarPosition position = FlushbarPosition.BOTTOM,
      VoidCallback? onDismiss,
    }) {
  appSnackBar(
    title,
    message,
    backgroundColor: Colors.blueAccent,
    icon: Icons.info_outline,
    position: position,
    onDismiss: onDismiss,
  );
}