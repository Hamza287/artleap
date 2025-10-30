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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConnectivityState &&
        other.isConnected == isConnected &&
        other.isChecking == isChecking;
  }

  @override
  int get hashCode => Object.hash(isConnected, isChecking);
}

class ConnectivityNotifier extends Notifier<ConnectivityState> {
  StreamSubscription<bool>? _connectivitySubscription;

  @override
  ConnectivityState build() {
    _startListening();
    return const ConnectivityState(
      isConnected: true,
      isChecking: false,
    );
  }

  void _startListening() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = ref
        .watch(connectivityServiceProvider)
        .connectionStream
        .distinct()
        .listen(_onConnectivityChanged);
  }

  void _onConnectivityChanged(bool isConnected) {
    if (state.isConnected != isConnected) {
      state = state.copyWith(
        isConnected: isConnected,
        lastChecked: DateTime.now(),
      );
    }
  }

  Future<void> checkConnection() async {
    state = state.copyWith(isChecking: true);
    try {
      final isConnected = await ref.read(connectivityServiceProvider).checkConnection();
      state = state.copyWith(
        isConnected: isConnected,
        isChecking: false,
        lastChecked: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isConnected: false,
        isChecking: false,
        lastChecked: DateTime.now(),
      );
    }
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

final connectivityNotifierProvider =
NotifierProvider<ConnectivityNotifier, ConnectivityState>(
  ConnectivityNotifier.new,
);

final isConnectedProvider = Provider<bool>((ref) {
  return ref.watch(connectivityNotifierProvider.select((state) => state.isConnected));
});