import 'package:flutter/material.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

BuildContext? get appContext => navigatorKey.currentState?.context;