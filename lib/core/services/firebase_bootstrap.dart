import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

/// Inicializa Firebase y sesión anónima. Si falla (opciones placeholder), [isReady] queda en false.
class FirebaseBootstrap {
  FirebaseBootstrap._();

  static bool isReady = false;
  static String? lastError;

  static Future<void> init() async {
    lastError = null;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }
      isReady = true;
    } catch (e, st) {
      isReady = false;
      lastError = e.toString();
      assert(() {
        // ignore: avoid_print
        print('FirebaseBootstrap: $e\n$st');
        return true;
      }());
    }
  }

  static User? get currentUser => FirebaseAuth.instance.currentUser;
}
