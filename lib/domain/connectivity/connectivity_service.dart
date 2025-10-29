import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Stream<bool> get connectivityStream => _connectivity.onConnectivityChanged
      .map((results) => results.any(_isConnected));

  bool _isConnected(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }

  Future<bool> checkConnection() async {
    final results = await _connectivity.checkConnectivity();
    return results.any(_isConnected);
  }

  void dispose() {
    _subscription?.cancel();
  }
}

// Providers
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

final connectivityStateProvider = StreamProvider<bool>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  return connectivityService.connectivityStream;
});

final initialConnectionCheckProvider = FutureProvider<bool>((ref) {
  final connectivityService = ref.read(connectivityServiceProvider);
  return connectivityService.checkConnection();
});

final internetConnectivityProvider = Provider<InternetConnectivityNotifier>((ref) {
  return InternetConnectivityNotifier(ref);
});

class InternetConnectivityNotifier {
  final Ref ref;

  InternetConnectivityNotifier(this.ref);

  bool? get currentStatus => ref.read(connectivityStateProvider).value;

  Stream<bool> get connectivityStream => ref.read(connectivityStateProvider.stream);

  Future<bool> checkConnection() async {
    return await ref.read(connectivityServiceProvider).checkConnection();
  }

  Future<void> retryConnection() async {
    ref.invalidate(initialConnectionCheckProvider);
  }
}