import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

/// Inicializa solo Firebase Core. El login lo gestiona [AuthService] + pantalla `/auth`.
class FirebaseBootstrap {
  FirebaseBootstrap._();

  static bool firebaseInitialized = false;
  static String? lastError;

  /// Firebase Core listo (sin exigir usuario).
  static bool get firebaseAppReady => firebaseInitialized;

  /// App con usuario autenticado (email o invitado anónimo).
  static bool get isReady => firebaseInitialized && FirebaseAuth.instance.currentUser != null;

  static Future<void> initCore() async {
    lastError = null;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      firebaseInitialized = true;
    } catch (e, st) {
      firebaseInitialized = false;
      lastError = e.toString();
      assert(() {
        // ignore: avoid_print
        print('FirebaseBootstrap: $e\n$st');
        return true;
      }());
    }
  }

  static User? get currentUser => FirebaseAuth.instance.currentUser;

  /// Si el doc `meta/bootstrap` falla (p. ej. permisos), queda el mensaje aquí.
  static String? metaSeedError;

  /// Llama tras login: crea/actualiza doc de esquema en Firestore.
  static Future<void> seedMetaBootstrapDoc() async {
    metaSeedError = null;
    if (!isReady) return;
    try {
      await FirebaseFirestore.instance.collection('meta').doc('bootstrap').set(
        {
          'schemaVersion': 2,
          'hint':
              'v2: users/{uid}, groups/{id}+members; colegio en groups.schoolName.',
          'lastWriteMs': DateTime.now().millisecondsSinceEpoch,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e, st) {
      metaSeedError = e.toString();
      developer.log(
        'FirebaseBootstrap meta seed failed',
        name: 'pefcmeem.firebase',
        error: e,
        stackTrace: st,
      );
    }
  }
}
