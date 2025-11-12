import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'force_update_provider.dart';
import 'force_update_screen.dart';

class ForceUpdateWrapper extends ConsumerWidget {
  final Widget child;

  const ForceUpdateWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forceUpdateAsync = ref.watch(forceUpdateProvider);

    return forceUpdateAsync.when(
      loading: () => _buildLoadingScreen(),
      error: (error, stack) => _buildErrorScreen(error, ref),
      data: (updateState) => _buildAppWithUpdateCheck(updateState, child),
    );
  }

  Widget _buildLoadingScreen() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Checking for updates...'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(Object error, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64),
                SizedBox(height: 20),
                Text('Update Check Failed'),
                SizedBox(height: 16),
                Text('Please check your internet connection.'),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ref.invalidate(forceUpdateProvider),
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppWithUpdateCheck(ForceUpdateState updateState, Widget child) {
    if (updateState.status == UpdateStatus.required) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ForceUpdateScreen(updateState: updateState),
      );
    }

    return child;
  }
}