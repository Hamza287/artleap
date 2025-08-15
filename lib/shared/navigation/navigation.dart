import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'navigator_key.dart';

class Navigation {
  static void pushNamed(String routeName,
      {bool rootNavigator = false, Object? arguments}) {
    if (appContext == null || navigatorKey.currentState == null) {
      debugPrint('Cannot push route: $routeName. Navigator context is null. Deferring navigation.');
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (appContext != null && navigatorKey.currentState != null) {
          Navigator.of(appContext!, rootNavigator: rootNavigator)
              .pushNamed(routeName, arguments: arguments);
        } else {
          debugPrint('Cannot push route: $routeName. Navigator context still null.');
        }
      });
      return;
    }
    Navigator.of(appContext!, rootNavigator: rootNavigator)
        .pushNamed(routeName, arguments: arguments);
  }

  static void pushReplacementNamed(String routeName,
      {bool rootNavigator = false, Object? arguments}) {
    if (appContext == null || navigatorKey.currentState == null) {
      debugPrint('Cannot push replacement route: $routeName. Navigator context is null. Deferring navigation.');
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (appContext != null && navigatorKey.currentState != null) {
          Navigator.of(appContext!, rootNavigator: rootNavigator)
              .pushReplacementNamed(routeName, arguments: arguments);
        } else {
          debugPrint('Cannot push replacement route: $routeName. Navigator context still null.');
        }
      });
      return;
    }
    Navigator.of(appContext!, rootNavigator: rootNavigator)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  static void pushNamedAndRemoveUntil(String routeName,
      {bool rootNavigator = false, Object? arguments}) {
    if (appContext == null || navigatorKey.currentState == null) {
      debugPrint('Cannot push and remove until route: $routeName. Navigator context is null. Deferring navigation.');
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (appContext != null && navigatorKey.currentState != null) {
          Navigator.of(appContext!, rootNavigator: rootNavigator)
              .pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments);
        } else {
          debugPrint('Cannot push and remove until route: $routeName. Navigator context still null.');
        }
      });
      return;
    }
    Navigator.of(appContext!, rootNavigator: rootNavigator)
        .pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments);
  }

  static void pop({bool rootNavigator = false, int delay = 0}) {
    Timer(Duration(milliseconds: delay), () {
      if (appContext == null || navigatorKey.currentState == null) {
        debugPrint('Cannot pop route. Navigator context is null.');
        return;
      }
      Navigator.of(appContext!, rootNavigator: rootNavigator).pop();
    });
  }

  static String currentScreen() {
    if (appContext == null || navigatorKey.currentState == null) {
      debugPrint('Cannot get current screen: Navigator context is null.');
      return '';
    }
    return ModalRoute.of(appContext!)?.settings.name ?? '';
  }
}