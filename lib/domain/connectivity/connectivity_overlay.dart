import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'connectivity_provider.dart';
import 'package:Artleap.ai/shared/navigation/navigator_key.dart';

class ConnectivityOverlay extends ConsumerStatefulWidget {
  final Widget child;
  const ConnectivityOverlay({Key? key, required this.child}) : super(key: key);

  @override
  ConsumerState<ConnectivityOverlay> createState() => _ConnectivityOverlayState();
}

class _ConnectivityOverlayState extends ConsumerState<ConnectivityOverlay> with WidgetsBindingObserver {
  bool _isDialogShowing = false;
  DateTime? _lastChange;
  late final ProviderSubscription<ConnectivityState> _sub;
  Timer? _deferTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _sub = ref.listenManual<ConnectivityState>(
      connectivityNotifierProvider,
          (prev, next) => _handleChange(next),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(connectivityNotifierProvider.notifier).checkConnection();
      _handleChange(ref.read(connectivityNotifierProvider));
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(connectivityNotifierProvider.notifier).checkConnection();
    }
  }

  void _handleChange(ConnectivityState current) {
    final now = DateTime.now();
    if (_lastChange != null && now.difference(_lastChange!) < const Duration(milliseconds: 300)) return;
    _lastChange = now;

    if (!current.isConnected && !_isDialogShowing) {
      _showNoInternetDialog();
    } else if (current.isConnected && _isDialogShowing) {
      _hideNoInternetDialog();
    }
  }

  BuildContext? get _navContext => navigatorKey.currentContext;

  void _showNoInternetDialog() {
    if (_isDialogShowing || !mounted) return;

    final ctx = _navContext;
    if (ctx == null) {
      _deferTimer?.cancel();
      _deferTimer = Timer(const Duration(milliseconds: 50), _showNoInternetDialog);
      return;
    }

    _isDialogShowing = true;

    showGeneralDialog(
      context: ctx,
      barrierDismissible: false,
      barrierLabel: 'No Internet',
      barrierColor: Colors.black54,
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, anim, __, ___) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim.value),
          child: _NoInternetDialog(onRetry: _onRetry),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    ).then((_) => _isDialogShowing = false);
  }

  void _hideNoInternetDialog() {
    if (!_isDialogShowing) return;

    final state = navigatorKey.currentState;
    if (state != null && state.canPop()) {
      state.pop();
    }
    _isDialogShowing = false;
  }

  Future<void> _onRetry() async {
    await ref.read(connectivityNotifierProvider.notifier).checkConnection();
    final online = ref.read(connectivityNotifierProvider).isConnected;
    if (!online && mounted) {
      final ctx = _navContext ?? context;
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('Still no internet connection'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _sub.close();
    _deferTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _NoInternetDialog extends ConsumerWidget {
  final VoidCallback onRetry;
  const _NoInternetDialog({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final checking = ref.watch(connectivityNotifierProvider.select((s) => s.isChecking));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.wifi_off_rounded, size: 40, color: Colors.orange),
            ),
            const SizedBox(height: 20),
            Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Please turn on Wi-Fi or Mobile Data to continue using the app.',
              style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface.withOpacity(0.75), height: 1.35),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: checking ? null : onRetry,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: checking
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
