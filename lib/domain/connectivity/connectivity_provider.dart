import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'connectivity_service.dart';

class ConnectivityState {
  final bool isConnected;
  final bool isChecking;
  final DateTime? lastChecked;

  const ConnectivityState({
    required this.isConnected,
    required this.isChecking,
    this.lastChecked,
  });

  ConnectivityState copyWith({
    bool? isConnected,
    bool? isChecking,
    DateTime? lastChecked,
  }) {
    return ConnectivityState(
      isConnected: isConnected ?? this.isConnected,
      isChecking: isChecking ?? this.isChecking,
      lastChecked: lastChecked ?? this.lastChecked,
    );
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final svc = ConnectivityService();
  ref.onDispose(() => svc.dispose());
  return svc;
});

class ConnectivityNotifier extends Notifier<ConnectivityState> {
  StreamSubscription<bool>? _sub;

  @override
  ConnectivityState build() {
    state = const ConnectivityState(isConnected: true, isChecking: false);
    _sub?.cancel();
    _sub = ref.read(connectivityServiceProvider).connectionStream.distinct().listen((online) {
      state = state.copyWith(
        isConnected: online,
        isChecking: false,
        lastChecked: DateTime.now(),
      );
    });
    ref.onDispose(() => _sub?.cancel());
    Future.microtask(checkConnection);
    return state;
  }

  Future<void> checkConnection() async {
    state = state.copyWith(isChecking: true);
    final ok = await ref.read(connectivityServiceProvider).checkConnection();
    state = state.copyWith(
      isConnected: ok,
      isChecking: false,
      lastChecked: DateTime.now(),
    );
  }
}

final connectivityNotifierProvider =
NotifierProvider<ConnectivityNotifier, ConnectivityState>(
  ConnectivityNotifier.new,
);

final isConnectedProvider = Provider<bool>((ref) {
  return ref.watch(connectivityNotifierProvider.select((s) => s.isConnected));
});
