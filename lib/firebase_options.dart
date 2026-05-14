// Generado con `flutterfire configure` (proyecto pefcmeem-633d9).
// Android: también `android/app/google-services.json`.
// iOS: también `ios/Runner/GoogleService-Info.plist`.
// ignore_for_file: lines_longer_than_80_chars

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAZcaIVV1M0qYvP6Yy6oa7U_edxyCs_FiQ',
    appId: '1:1084677395538:web:7f2c840f309f6bfc417b8b',
    messagingSenderId: '1084677395538',
    projectId: 'pefcmeem-633d9',
    authDomain: 'pefcmeem-633d9.firebaseapp.com',
    storageBucket: 'pefcmeem-633d9.firebasestorage.app',
    measurementId: 'G-N1LT1JH038',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwGUFNw6e9tmHVXi992N_YBREKt9TZUp8',
    appId: '1:1084677395538:android:5e11b2d4ba3cc367417b8b',
    messagingSenderId: '1084677395538',
    projectId: 'pefcmeem-633d9',
    storageBucket: 'pefcmeem-633d9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBE4pwp3Xf6Z88SI_AA5P8DXzvanZIe8PE',
    appId: '1:1084677395538:ios:6502687f28d5716b417b8b',
    messagingSenderId: '1084677395538',
    projectId: 'pefcmeem-633d9',
    storageBucket: 'pefcmeem-633d9.firebasestorage.app',
    iosBundleId: 'com.pefcmeem.app.pefcmeem',
  );

}