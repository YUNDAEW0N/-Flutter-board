// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyDXv0YHyXC6wO26U5i2u90okRyR9lX4aV8',
    appId: '1:392419754101:web:b03f8a9d0446efddd0783c',
    messagingSenderId: '392419754101',
    projectId: 'ydwborder',
    authDomain: 'ydwborder.firebaseapp.com',
    storageBucket: 'ydwborder.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDsI_9FA8ju7h8jRQE9kXffpbetITSUKe0',
    appId: '1:392419754101:android:206be1ae123ed01ad0783c',
    messagingSenderId: '392419754101',
    projectId: 'ydwborder',
    storageBucket: 'ydwborder.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVPJl7g-RDjxB7OXxiayAPjCsRpnf8Jjk',
    appId: '1:392419754101:ios:34deb72be9ffdbf3d0783c',
    messagingSenderId: '392419754101',
    projectId: 'ydwborder',
    storageBucket: 'ydwborder.appspot.com',
    iosBundleId: 'com.example.ydwBorder',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBVPJl7g-RDjxB7OXxiayAPjCsRpnf8Jjk',
    appId: '1:392419754101:ios:11fea0a8a3be994bd0783c',
    messagingSenderId: '392419754101',
    projectId: 'ydwborder',
    storageBucket: 'ydwborder.appspot.com',
    iosBundleId: 'com.example.ydwBorder.RunnerTests',
  );
}