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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB6fJRx6B2HNYp0nE6zWP6x1NziB3uqtJk',
    appId: '1:805182271280:web:586c0d32d2e41dea3562f5',
    messagingSenderId: '805182271280',
    projectId: 'barbershop-79626',
    authDomain: 'barbershop-79626.firebaseapp.com',
    storageBucket: 'barbershop-79626.appspot.com',
    measurementId: 'G-59QVH3Q7MS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyApRtDlMyH1g-IXyWZwW75vb7Eiyc1RFLs',
    appId: '1:805182271280:android:7dc0f3f181060e0b3562f5',
    messagingSenderId: '805182271280',
    projectId: 'barbershop-79626',
    storageBucket: 'barbershop-79626.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDeUkvdy7V_NPOfjv2EjHshC2sB6q9lQjg',
    appId: '1:805182271280:ios:945df07943d228a13562f5',
    messagingSenderId: '805182271280',
    projectId: 'barbershop-79626',
    storageBucket: 'barbershop-79626.appspot.com',
    iosBundleId: 'com.example.flutterProjectBtl',
  );
}
