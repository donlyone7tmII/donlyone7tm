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
    apiKey: 'AIzaSyDfZQJXL0fD-gebLxI-0ZRPixHIbfnE9mw',
    appId: '1:923110657267:web:342a3cf01adff638997b86',
    messagingSenderId: '923110657267',
    projectId: 'subscription-manager-956fb',
    authDomain: 'subscription-manager-956fb.firebaseapp.com',
    storageBucket: 'subscription-manager-956fb.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBExHfptZuafowXoiLERndAoNw7LKsKXns',
    appId: '1:923110657267:android:b4280e030121591a997b86',
    messagingSenderId: '923110657267',
    projectId: 'subscription-manager-956fb',
    storageBucket: 'subscription-manager-956fb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA1xwn5wYW9aAJjVx2j6qxj2sX_D3YcRz8',
    appId: '1:923110657267:ios:08cad837f7f2dc06997b86',
    messagingSenderId: '923110657267',
    projectId: 'subscription-manager-956fb',
    storageBucket: 'subscription-manager-956fb.firebasestorage.app',
    iosBundleId: 'com.example.subscriptionManager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA1xwn5wYW9aAJjVx2j6qxj2sX_D3YcRz8',
    appId: '1:923110657267:ios:08cad837f7f2dc06997b86',
    messagingSenderId: '923110657267',
    projectId: 'subscription-manager-956fb',
    storageBucket: 'subscription-manager-956fb.firebasestorage.app',
    iosBundleId: 'com.example.subscriptionManager',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDfZQJXL0fD-gebLxI-0ZRPixHIbfnE9mw',
    appId: '1:923110657267:web:00692e56e636e1fb997b86',
    messagingSenderId: '923110657267',
    projectId: 'subscription-manager-956fb',
    authDomain: 'subscription-manager-956fb.firebaseapp.com',
    storageBucket: 'subscription-manager-956fb.firebasestorage.app',
  );

}