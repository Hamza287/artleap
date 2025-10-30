import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final InternetConnection _internet = InternetConnection();

  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  StreamSubscription? _connSub;
  StreamSubscription<InternetStatus>? _netSub;
  Timer? _pollTimer;

  bool? _lastEmitted;

  ConnectivityService() {
    _init();
  }

  Stream<bool> get connectionStream => _controller.stream;

  Future<void> _init() async {
    final initial = await _computeIsOnline();
    _emitIfChanged(initial);

    _connSub = _connectivity.onConnectivityChanged.listen((event) async {
      debugPrint('onConnectivityChanged: $event');
      final results = _asResultsList(event);
      final hasInterface = results.any((r) => r != ConnectivityResult.none);
      if (!hasInterface) {
        debugPrint('No interface -> offline');
        _emitIfChanged(false);
        return;
      }
      final online = await _computeIsOnline();
      debugPrint('Reachability after interface change: $online');
      _emitIfChanged(online);
    });

    _netSub = _internet.onStatusChange.listen((status) async {
      final online = await _computeIsOnline();
      debugPrint('onStatusChange (reachability): $status -> $online');
      _emitIfChanged(online);
    });
  }

  Future<bool> checkConnection() async {
    final online = await _computeIsOnline();
    _emitIfChanged(online);
    return online;
  }

  Future<bool> _computeIsOnline() async {
    final raw = await _connectivity.checkConnectivity();
    final results = _asResultsList(raw);
    final hasInterface = results.any((r) => r != ConnectivityResult.none);
    if (!hasInterface) return false;

    try {
      final ok = await _internet.hasInternetAccess;
      if (ok) return true;

      final socket = await Socket.connect('1.1.1.1', 53, timeout: const Duration(seconds: 2));
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  List<ConnectivityResult> _asResultsList(dynamic value) {
    if (value is List<ConnectivityResult>) return value;
    if (value is ConnectivityResult) return [value];
    return const [ConnectivityResult.none];
  }

  void _emitIfChanged(bool value) {
    if (_lastEmitted == value) return;
    _lastEmitted = value;
    _controller.add(value);
    _updatePoller(value);
  }

  void _updatePoller(bool online) {
    if (online) {
      _pollTimer?.cancel();
      _pollTimer = null;
    } else {
      _pollTimer ??= Timer.periodic(const Duration(seconds: 1), (_) async {
        final ok = await _computeIsOnline();
        if (ok) _emitIfChanged(true);
      });
    }
  }

  Future<void> dispose() async {
    await _connSub?.cancel();
    await _netSub?.cancel();
    _pollTimer?.cancel();
    await _controller.close();
  }
}
