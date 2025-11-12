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
    apiKey: 'AIzaSyDummyKeyForWeb',
    appId: '1:123456789:web:dummywebappid',
    messagingSenderId: '123456789',
    projectId: 'listynest-app',
    authDomain: 'listynest-app.firebaseapp.com',
    storageBucket: 'listynest-app.appspot.com',
    measurementId: 'G-DUMMYID',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForAndroid',
    appId: '1:123456789:android:dummyandroidappid',
    messagingSenderId: '123456789',
    projectId: 'listynest-app',
    storageBucket: 'listynest-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForIOS',
    appId: '1:123456789:ios:dummyiosappid',
    messagingSenderId: '123456789',
    projectId: 'listynest-app',
    storageBucket: 'listynest-app.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForMacOS',
    appId: '1:123456789:macos:dummymacosappid',
    messagingSenderId: '123456789',
    projectId: 'listynest-app',
    storageBucket: 'listynest-app.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForWindows',
    appId: '1:123456789:windows:dummywindowsappid',
    messagingSenderId: '123456789',
    projectId: 'listynest-app',
    storageBucket: 'listynest-app.appspot.com',
  );
}