import 'user_role.dart';

/// Perfil remoto en `users/{uid}` (Firestore).
class UserProfileDoc {
  const UserProfileDoc({
    required this.email,
    required this.displayName,
    required this.role,
    this.schoolName,
  });

  final String email;
  final String displayName;
  final UserRole role;
  final String? schoolName;

  static UserProfileDoc? fromMap(Map<String, dynamic>? data, {required String fallbackEmail}) {
    if (data == null) return null;
    final roleRaw = data['role'] as String?;
    final role = UserRole.tryParse(roleRaw) ?? UserRole.student;
    return UserProfileDoc(
      email: (data['email'] as String?)?.trim() ?? fallbackEmail,
      displayName: (data['displayName'] as String?)?.trim().isNotEmpty == true
          ? (data['displayName'] as String).trim()
          : 'Usuario',
      role: role,
      schoolName: (data['schoolName'] as String?)?.trim(),
    );
  }
}
