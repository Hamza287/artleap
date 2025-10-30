import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'connectivity_provider.dart';

class ConnectivityOverlay extends ConsumerStatefulWidget {
  final Widget child;

  const ConnectivityOverlay({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  ConsumerState<ConnectivityOverlay> createState() => _ConnectivityOverlayState();
}

class _ConnectivityOverlayState extends ConsumerState<ConnectivityOverlay> {
  bool _isDialogShowing = false;
  DateTime? _lastConnectionChange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeConnectivityListener();
    });
  }

  void _initializeConnectivityListener() {
    ref.listen<ConnectivityState>(
      connectivityNotifierProvider,
          (previous, current) {
        _handleConnectivityChange(previous, current);
      },
    );
  }

  void _handleConnectivityChange(ConnectivityState? previous, ConnectivityState current) {
    final now = DateTime.now();

    if (_lastConnectionChange != null &&
        now.difference(_lastConnectionChange!) < const Duration(seconds: 1)) {
      return;
    }

    _lastConnectionChange = now;

    if (!current.isConnected && !_isDialogShowing) {
      print('No internet - showing dialog');
      _showNoInternetDialog();
    } else if (current.isConnected && _isDialogShowing) {
      print('Internet restored - hiding dialog');
      _hideNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    if (_isDialogShowing) return;

    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: _NoInternetDialog(
          onRetry: _onRetryPressed,
        ),
      ),
    ).then((_) {
      _isDialogShowing = false;
    });
  }

  void _hideNoInternetDialog() {
    if (!_isDialogShowing) return;

    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    _isDialogShowing = false;
  }

  Future<void> _onRetryPressed() async {
    try {
      await ref.read(connectivityNotifierProvider.notifier).checkConnection();
      final currentState = ref.read(connectivityNotifierProvider);

      if (!currentState.isConnected) {
        _showRetryError();
      }
    } catch (e) {
      _showRetryError();
    }
  }

  void _showRetryError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Still no internet connection'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _NoInternetDialog extends StatelessWidget {
  final VoidCallback onRetry;

  const _NoInternetDialog({
    Key? key,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 40,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Internet Connection',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Your device is not connected to the internet. '
                  'Please check your connection and try again.',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Retry Connection',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}