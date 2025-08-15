import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'navigation/navigator_key.dart';

void appSnackBar(String title, String message, Color color) {
  if (navigatorKey.currentState == null || appContext == null) {
    debugPrint('Cannot show Flushbar: Navigator state or context is null. Message: $title - $message');
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentState != null && appContext != null) {
        Flushbar(
          title: title,
          message: message,
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: color,
          duration: const Duration(seconds: 3),
        ).show(appContext!);
      } else {
        debugPrint('Cannot show Flushbar: Navigator state or context still null.');
      }
    });
    return;
  }

  Flushbar(
    title: title,
    message: message,
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: color,
    duration: const Duration(seconds: 3),
  ).show(appContext!);
}