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
      loading: () => _buildLoadingScreen(context),
      error: (error, stack) => _buildErrorScreen(error, stack, ref, context),
      data: (updateState) => _buildAppWithUpdateCheck(updateState, child, context),
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    final theme = Theme.of(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated loading indicator
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                        strokeWidth: 3,
                      ),
                      Icon(
                        Icons.rocket_launch_outlined,
                        size: 32,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Typography with proper hierarchy
                Text(
                  'Checking for Updates',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Please wait while we verify the latest version',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onBackground.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Subtle progress indicator
                SizedBox(
                  width: 120,
                  child: LinearProgressIndicator(
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary.withOpacity(0.3),
                    ),
                    minHeight: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(Object error, StackTrace? stack, WidgetRef ref, BuildContext context) {
    final theme = Theme.of(context);
    final isConnectionError = _isConnectionError(error);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Contextual icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isConnectionError ? Icons.wifi_off : Icons.error_outline,
                      size: 48,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Error title
                  Text(
                    isConnectionError ? 'Connection Error' : 'Update Check Failed',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onBackground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Error description
                  Text(
                    isConnectionError
                        ? 'Please check your internet connection and try again.'
                        : 'We encountered an issue while checking for updates.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Retry button
                      ElevatedButton.icon(
                        onPressed: () => ref.invalidate(forceUpdateProvider),
                        icon: const Icon(Icons.refresh, size: 20),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Alternative action for non-connection errors
                      if (!isConnectionError)
                        OutlinedButton(
                          onPressed: () {
                            // Optionally proceed without update check
                            // This could be handled by your provider state
                          },
                          child: const Text('Continue Anyway'),
                        ),
                    ],
                  ),
                  // Debug info (only in debug mode)
                  if (stack != null && !const bool.fromEnvironment('dart.vm.product'))
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Text(
                        'Error: $error',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppWithUpdateCheck(ForceUpdateState updateState, Widget child, BuildContext context) {
    if (updateState.status == UpdateStatus.required) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: ForceUpdateScreen(updateState: updateState),
      );
    }

    return child;
  }

  bool _isConnectionError(Object error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('connection') ||
        errorString.contains('network') ||
        errorString.contains('socket') ||
        errorString.contains('internet');
  }
}