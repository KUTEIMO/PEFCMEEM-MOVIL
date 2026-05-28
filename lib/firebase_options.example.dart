// Plantilla: copia a firebase_options.dart y ejecuta `flutterfire configure`
// (proyecto pefcmeem-633d9). No commitees el archivo generado con claves reales.
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
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'pefcmeem-633d9',
    authDomain: 'pefcmeem-633d9.firebaseapp.com',
    storageBucket: 'pefcmeem-633d9.firebasestorage.app',
    measurementId: 'REPLACE_ME',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'pefcmeem-633d9',
    storageBucket: 'pefcmeem-633d9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'pefcmeem-633d9',
    storageBucket: 'pefcmeem-633d9.firebasestorage.app',
    iosBundleId: 'com.pefcmeem.app.pefcmeem',
  );
}
