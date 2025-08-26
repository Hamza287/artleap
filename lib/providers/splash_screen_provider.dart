import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SplashState {
  initializing,
  checkingConnection,
  connected,
  noInternet,
  firebaseError,
  readyToNavigate,
}

class SplashStateNotifier extends StateNotifier<SplashState> {
  SplashStateNotifier() : super(SplashState.initializing);

  Future<void> initializeApp() async {
    try {
      state = SplashState.checkingConnection;

      // Check internet connection
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        state = SplashState.noInternet;
        return;
      }

      // Initialize Firebase with retry logic
      int attempts = 0;
      bool firebaseInitialized = false;

      while (attempts < 3 && !firebaseInitialized) {
        try {
          state = SplashState.initializing;
          await FirebaseMessaging.instance.getToken();
          firebaseInitialized = true;

          // Add a small delay before marking as ready to navigate
          await Future.delayed(const Duration(milliseconds: 500));
          state = SplashState.readyToNavigate;
        } catch (e) {
          attempts++;
          if (attempts >= 3) {
            state = SplashState.firebaseError;
          }
          await Future.delayed(Duration(seconds: attempts));
        }
      }
    } catch (e) {
      state = SplashState.firebaseError;
    }
  }

  void retryInitialization() {
    initializeApp();
  }
}

final splashStateProvider = StateNotifierProvider<SplashStateNotifier, SplashState>(
      (ref) => SplashStateNotifier(),
);