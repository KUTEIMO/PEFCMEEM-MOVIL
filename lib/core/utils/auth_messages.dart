import 'package:firebase_auth/firebase_auth.dart';

String formatAuthError(Object e) {
  if (e is FirebaseAuthException) {
    switch (e.code) {
      case 'invalid-email':
        return 'El correo no es válido.';
      case 'user-disabled':
        return 'Esta cuenta está deshabilitada.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos. Revisa mayúsculas y, si acabas de registrarte, que sea el mismo correo.';
      case 'too-many-requests':
        return 'Demasiados intentos. Espera unos minutos e inténtalo de nuevo.';
      case 'network-request-failed':
        return 'Sin conexión a Internet o Firebase no responde.';
      case 'email-already-in-use':
        return 'Ese correo ya tiene cuenta. Usa la pestaña «Entrar».';
      case 'weak-password':
        return 'La contraseña es demasiado débil (mínimo 6 caracteres).';
      case 'operation-not-allowed':
        return 'Email/contraseña no habilitado en Firebase Console (Authentication → Sign-in method).';
      case 'internal-error':
        return 'Error interno de autenticación. Revisa que google-services.json / Firebase estén bien configurados.';
      default:
        return 'Error (${e.code}): ${e.message ?? e.toString()}';
    }
  }
  return e.toString();
}
