import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'navigation/navigator_key.dart';

appSnackBar(String title, String message, Color color) {
  Flushbar(
    title: title, 
    message: message,
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: color,
    duration: const Duration(seconds: 3),
  ).show(appContext);
  // ScaffoldMessenger.of(appContext).showSnackBar(SnackBar(
  //   content: Text(message),
  //   duration: const Duration(seconds: 2),
  //   backgroundColor: color,
  // ));
}
