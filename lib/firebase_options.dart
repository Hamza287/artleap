// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDy8prKHws6ECrtwjM3vxnAh3K5WiiwfI8',
    appId: '1:53715181958:web:e074f917e24bf14bdecc07',
    messagingSenderId: '53715181958',
    projectId: 'imaginary-verse',
    authDomain: 'imaginary-verse.firebaseapp.com',
    storageBucket: 'imaginary-verse.appspot.com',
    measurementId: 'G-NZ9THB6NQQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrfCe9kURknifcxmOgP69pqhasK3ZKfb4',
    appId: '1:53715181958:android:9dc78b65a64e54e4decc07',
    messagingSenderId: '53715181958',
    projectId: 'imaginary-verse',
    storageBucket: 'imaginary-verse.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCefdd4vFs6Va_9MR_Wf4BnX6jLdBbann4',
    appId: '1:53715181958:ios:34adf88a7361b9eadecc07',
    messagingSenderId: '53715181958',
    projectId: 'imaginary-verse',
    storageBucket: 'imaginary-verse.appspot.com',
    androidClientId: '53715181958-gktpd6i5oeqiej7a4i0v34p048trqcp9.apps.googleusercontent.com',
    iosClientId: '53715181958-10rq7oogskggumj2v40iku8o9homdf5t.apps.googleusercontent.com',
    iosBundleId: 'com.XrDIgital.ImaginaryVerse',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCefdd4vFs6Va_9MR_Wf4BnX6jLdBbann4',
    appId: '1:53715181958:ios:34adf88a7361b9eadecc07',
    messagingSenderId: '53715181958',
    projectId: 'imaginary-verse',
    storageBucket: 'imaginary-verse.appspot.com',
    androidClientId: '53715181958-gktpd6i5oeqiej7a4i0v34p048trqcp9.apps.googleusercontent.com',
    iosClientId: '53715181958-10rq7oogskggumj2v40iku8o9homdf5t.apps.googleusercontent.com',
    iosBundleId: 'com.XrDIgital.ImaginaryVerse',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDy8prKHws6ECrtwjM3vxnAh3K5WiiwfI8',
    appId: '1:53715181958:web:25e5c82f54a3ccbfdecc07',
    messagingSenderId: '53715181958',
    projectId: 'imaginary-verse',
    authDomain: 'imaginary-verse.firebaseapp.com',
    storageBucket: 'imaginary-verse.appspot.com',
    measurementId: 'G-4EELX69MT3',
  );

}