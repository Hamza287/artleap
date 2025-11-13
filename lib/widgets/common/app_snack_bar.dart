import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../shared/navigation/navigator_key.dart';

void appSnackBar(
    String title,
    String message, {
      Color backgroundColor = Colors.green,
      Color textColor = Colors.white,
      Color titleColor = Colors.white,
      Duration duration = const Duration(seconds: 4),
      FlushbarPosition position = FlushbarPosition.BOTTOM,
      bool showProgressIndicator = false,
      FlushbarStyle flushbarStyle = FlushbarStyle.FLOATING,
      EdgeInsets margin = const EdgeInsets.all(16),
      BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12)),
      bool isDismissible = true,
      bool shouldIconPulse = true,
      IconData? icon,
      Color? iconColor,
    }) {
  final BuildContext? context = appContext ?? navigatorKey.currentContext;

  void showFlushbar() {
    if (context == null || !context.mounted) {
      debugPrint('Cannot show Flushbar: Context is null or not mounted. Message: $title - $message');
      return;
    }

    Flushbar(
      titleText: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: titleColor,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: textColor,
        ),
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
          // Dismiss button will automatically close the flushbar
        },
        child: Text(
          'DISMISS',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      )
          : null,
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

void appSuccessSnackBar(String title, String message, {FlushbarPosition position = FlushbarPosition.BOTTOM}) {
  appSnackBar(
    title,
    message,
    backgroundColor: Colors.green,
    icon: Icons.check_circle_outline,
    position: position,
  );
}

void appErrorSnackBar(String title, String message, {FlushbarPosition position = FlushbarPosition.BOTTOM}) {
  appSnackBar(
    title,
    message,
    backgroundColor: Colors.redAccent,
    icon: Icons.error_outline,
    position: position,
  );
}

void appWarningSnackBar(String title, String message, {FlushbarPosition position = FlushbarPosition.BOTTOM}) {
  appSnackBar(
    title,
    message,
    backgroundColor: Colors.orangeAccent,
    icon: Icons.warning_amber,
    position: position,
  );
}

void appInfoSnackBar(String title, String message, {FlushbarPosition position = FlushbarPosition.BOTTOM}) {
  appSnackBar(
    title,
    message,
    backgroundColor: Colors.blueAccent,
    icon: Icons.info_outline,
    position: position,
  );
}