import '../../widgets/learning_companion.dart';
import '../models/user_role.dart';

/// Textos y estado de Pibo según la ruta (asistente contextual).
class CompanionSnapshot {
  const CompanionSnapshot({
    required this.mood,
    required this.shortTip,
    required this.longTip,
  });

  final CompanionMood mood;
  final String shortTip;
  final String longTip;
}

abstract final class CompanionContextLogic {
  static CompanionSnapshot resolve({
    required String path,
    required UserRole role,
  }) {
    if (path.startsWith('/auth')) {
      return const CompanionSnapshot(
        mood: CompanionMood.idle,
        shortTip: 'Cuenta con correo: elige Entrar o Registro.',
        longTip:
            'Los docentes indican colegio al registrarse. Los estudiantes pueden unirse a un grupo con código después.',
      );
    }
    if (path.startsWith('/onboarding')) {
      return const CompanionSnapshot(
        mood: CompanionMood.hint,
        shortTip: 'Personaliza tu perfil: Pibo se adapta a tu rol.',
        longTip:
            'Responde con calma; puedes usar Saltar en estudiante. Luego tendrás el asistente flotante abajo.',
      );
    }
    if (path.startsWith('/group-chat')) {
      return const CompanionSnapshot(
        mood: CompanionMood.hint,
        shortTip: 'Escribe con respeto: el profe y tu clase leen aquí.',
        longTip:
            'El chat es solo para tu grupo. Puedes preguntar dudas de clase o coordinar con tu docente. Evita datos personales sensibles.',
      );
    }
    if (path.startsWith('/course/') && path.contains('/exercise')) {
      return const CompanionSnapshot(
        mood: CompanionMood.hint,
        shortTip: 'Antes de marcar: relee el enunciado en voz baja.',
        longTip:
            'Si te bloqueas, vuelve a la teoría con el botón atrás. Cada intento cuenta para tu XP y para el ranking del grupo.',
      );
    }
    if (path.contains('/lesson/') && path.contains('/results')) {
      return const CompanionSnapshot(
        mood: CompanionMood.success,
        shortTip: '¡Lección registrada! Un paso más en tu ruta.',
        longTip:
            'Revisa qué ejercicios fallaron y repásalos otro día: la ruta desbloquea contenido paso a paso.',
      );
    }
    if (path.startsWith('/course/')) {
      return const CompanionSnapshot(
        mood: CompanionMood.idle,
        shortTip: 'Lee la teoría con calma; luego atacamos ejercicios.',
        longTip:
            'Las micro-lecciones están pensadas para 5–10 minutos. Marca lo esencial y luego practica.',
      );
    }
    if (path.startsWith(AppPaths.join)) {
      return const CompanionSnapshot(
        mood: CompanionMood.hint,
        shortTip: 'Pide el código a tu profe (6 letras/números).',
        longTip:
            'Al unirte, tu XP de lecciones puede sumar al ranking del grupo. Si no tienes código, puedes seguir estudiando solo.',
      );
    }
    if (path.startsWith('/t/')) {
      if (path.contains('groups')) {
        return const CompanionSnapshot(
          mood: CompanionMood.idle,
          shortTip: 'Cada grupo tiene código y chat con estudiantes.',
          longTip:
              'Comparte el código por WhatsApp o proyector. Revisa el chat para dudas rápidas del grupo.',
        );
      }
      return const CompanionSnapshot(
        mood: CompanionMood.idle,
        shortTip: 'Panel docente: resumen, grupos y estadísticas.',
        longTip:
            'Desde Grupos creas códigos y ves el QR. Los estudiantes chatean contigo dentro de cada grupo.',
      );
    }
    if (path.startsWith('/s/path')) {
      return const CompanionSnapshot(
        mood: CompanionMood.streak,
        shortTip: 'La ruta ordena temas: sigue el orden recomendado.',
        longTip:
            'Completa una lección para desbloquear la siguiente. Tu racha crece si practicas varios días seguidos.',
      );
    }
    if (path.startsWith('/s/ranking')) {
      return const CompanionSnapshot(
        mood: CompanionMood.streak,
        shortTip: 'Ranking = XP del grupo en tiempo casi real.',
        longTip:
            'Si no ves compañeros, aún no se han unido o no han sumado XP. ¡Sigue practicando lecciones!',
      );
    }
    if (path.startsWith('/s/stats')) {
      return const CompanionSnapshot(
        mood: CompanionMood.idle,
        shortTip: 'Aquí ves tu constancia y precisión.',
        longTip:
            'Las estadísticas son locales al dispositivo salvo el XP que sincronizas al grupo en Firebase.',
      );
    }
    if (path.startsWith('/s/profile')) {
      return const CompanionSnapshot(
        mood: CompanionMood.hint,
        shortTip: 'Ajusta tu nombre y color; une chat si tienes grupo.',
        longTip:
            'Desde Perfil puedes unirte a un grupo o abrir el chat con tu docente si ya estás vinculado.',
      );
    }
    if (path.startsWith('/s/home') || path == '/home') {
      if (role == UserRole.teacher) {
        return const CompanionSnapshot(
          mood: CompanionMood.idle,
          shortTip: 'Docente: usa la pestaña Grupos para códigos y chat.',
          longTip:
              'En la barra inferior de docente tienes Resumen, Grupos, Estadísticas y Cuenta.',
        );
      }
      return const CompanionSnapshot(
        mood: CompanionMood.idle,
        shortTip: 'Hoy: un reto corto y tu ruta te esperan.',
        longTip:
            'El inicio resume tu nivel y el reto del día. Abajo tienes Ruta, Ranking (si hay grupo) y Perfil.',
      );
    }
    return const CompanionSnapshot(
      mood: CompanionMood.idle,
      shortTip: 'Soy Pibo: te guío según la pantalla en la que estés.',
      longTip:
          'PEFCMEEM — Domina las matemáticas. — combina rutas cortas con grupos y ranking. Usa el menú inferior para moverte.',
    );
  }
}

/// Evita dependencia circular con [AppRoutes].
abstract final class AppPaths {
  static const join = '/join-group';
}
