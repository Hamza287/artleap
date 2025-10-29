import 'package:flutter/material.dart';
import 'connectivity_overlay.dart';

class ConnectivityAwareWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityAwareWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConnectivityOverlay(child: child);
  }
}