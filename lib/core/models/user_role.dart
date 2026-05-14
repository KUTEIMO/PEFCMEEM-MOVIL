enum UserRole {
  student,
  teacher;

  static UserRole? tryParse(String? raw) {
    switch (raw) {
      case 'teacher':
        return UserRole.teacher;
      case 'student':
        return UserRole.student;
      default:
        return null;
    }
  }

  String get storageValue => name;
}
