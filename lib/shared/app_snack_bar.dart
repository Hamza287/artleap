import 'package:flutter/material.dart';

import 'navigation/navigator_key.dart';

appSnackBar(String message, Color color) {
  ScaffoldMessenger.of(appContext).showSnackBar(SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
    backgroundColor: color,
  ));
}
