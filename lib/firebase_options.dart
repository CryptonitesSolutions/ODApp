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
    apiKey: 'AIzaSyD5Wc09DGPwAtIPAVFvqculecgldCOZYOo',
    appId: '1:365455953847:web:55c0c792fe81b78e752232',
    messagingSenderId: '365455953847',
    projectId: 'chatapp-4deb3',
    authDomain: 'chatapp-4deb3.firebaseapp.com',
    storageBucket: 'chatapp-4deb3.appspot.com',
    measurementId: 'G-QTRXPP7W8M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBwmx4HjFR8a9eFmqTMcwWN5DnTsIL9bs',
    appId: '1:365455953847:android:0d9e121d18f4bd7d752232',
    messagingSenderId: '365455953847',
    projectId: 'chatapp-4deb3',
    storageBucket: 'chatapp-4deb3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJPQyAUmqm-S_f0W3-ZZHdTFTkkAUJwSk',
    appId: '1:365455953847:ios:c4348e404a34a0a5752232',
    messagingSenderId: '365455953847',
    projectId: 'chatapp-4deb3',
    storageBucket: 'chatapp-4deb3.appspot.com',
    iosBundleId: 'com.responsiveapp.clg.responsiveapp',
  );
}
