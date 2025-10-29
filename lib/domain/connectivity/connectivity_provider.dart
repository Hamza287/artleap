import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged.map((results) {
      return results.any(_isConnected);
    });
  }

  bool _isConnected(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }

  Future<bool> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any(_isConnected);
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}

class ConnectivityNotifier extends Notifier<ConnectivityState> {
  late ConnectivityService _connectivityService;

  @override
  ConnectivityState build() {
    _connectivityService = ConnectivityService();
    _startListening();
    _checkInitialConnection();

    return ConnectivityState(
      isConnected: true,
      isChecking: false,
    );
  }

  void _startListening() {
  }

  Future<void> _checkInitialConnection() async {
    state = state.copyWith(isChecking: true);
    try {
      final isConnected = await _connectivityService.checkConnection();
      state = state.copyWith(
        isConnected: isConnected,
        isChecking: false,
      );
    } catch (e) {
      state = state.copyWith(
        isConnected: false,
        isChecking: false,
      );
    }
  }

  Future<void> checkConnection() async {
    state = state.copyWith(isChecking: true);
    try {
      final isConnected = await _connectivityService.checkConnection();
      state = state.copyWith(
        isConnected: isConnected,
        isChecking: false,
      );
    } catch (e) {
      state = state.copyWith(
        isConnected: false,
        isChecking: false,
      );
    }
  }
}

class ConnectivityState {
  final bool isConnected;
  final bool isChecking;

  ConnectivityState({
    required this.isConnected,
    required this.isChecking,
  });

  ConnectivityState copyWith({
    bool? isConnected,
    bool? isChecking,
  }) {
    return ConnectivityState(
      isConnected: isConnected ?? this.isConnected,
      isChecking: isChecking ?? this.isChecking,
    );
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final connectivityNotifierProvider =
NotifierProvider<ConnectivityNotifier, ConnectivityState>(
  ConnectivityNotifier.new,
);

final isConnectedProvider = Provider<bool>((ref) {
  return ref.watch(connectivityNotifierProvider).isConnected;
});