/// Rutas v2: autenticación, shell estudiante (`/s/...`) y shell docente (`/t/...`).
abstract final class AppRoutes {
  /// Inicio web (landing). En móvil no se usa como pantalla principal.
  static const landing = '/';

  static const auth = '/auth';
  static const onboarding = '/onboarding';
  static const about = '/about';

  static const sHome = '/s/home';
  static const sPath = '/s/path';
  static const sRanking = '/s/ranking';
  static const sStats = '/s/stats';
  static const sProfile = '/s/profile';

  static const tDashboard = '/t/dashboard';
  static const tGroups = '/t/groups';
  static const tStats = '/t/stats';
  static const tAccount = '/t/account';

  static String groupChat(String groupId) => '/group-chat/$groupId';

  static String homeForRole(bool isTeacher) =>
      isTeacher ? tGroups : sHome;

  static String pathAfterOnboarding({required bool isTeacher, required bool openJoin}) {
    if (isTeacher) return tGroups;
    if (openJoin) return '/join-group';
    return sHome;
  }
}
