enum UserRole {
  student,
  teacher,
  admin;

  static UserRole? tryParse(String? raw) {
    switch (raw) {
      case 'teacher':
        return UserRole.teacher;
      case 'student':
        return UserRole.student;
      case 'admin':
        return UserRole.admin;
      default:
        return null;
    }
  }

  String get storageValue => name;
}
