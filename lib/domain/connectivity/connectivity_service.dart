import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final StreamController<bool> _connectionController = StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionController.stream;

  ConnectivityService() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final initialResult = await _connectivity.checkConnectivity();
      final initialConnected = initialResult.any(_isConnected);
      _connectionController.add(initialConnected);

      _subscription = _connectivity.onConnectivityChanged.listen((results) {
        final isConnected = results.any(_isConnected);
        print('Connectivity changed: $isConnected');
        _connectionController.add(isConnected);
      });
    } catch (e) {
      print('Connectivity service error: $e');
      _connectionController.add(false);
    }
  }

  bool _isConnected(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }

  Future<bool> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final isConnected = results.any(_isConnected);
      _connectionController.add(isConnected);
      return isConnected;
    } catch (e) {
      _connectionController.add(false);
      return false;
    }
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _connectionController.close();
  }
}