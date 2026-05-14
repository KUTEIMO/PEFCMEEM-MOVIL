class UserProgress {
  UserProgress({
    required this.totalXp,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActivityDateIso,
    required this.completedLessonIds,
    required this.totalQuestionsAnswered,
    required this.totalQuestionsCorrect,
    required this.studyMinutesApprox,
    required this.displayName,
    required this.gradeLabel,
    required this.goalLabel,
    required this.avatarColorIndex,
  });

  int totalXp;
  int currentStreak;
  int longestStreak;
  String? lastActivityDateIso;
  Set<String> completedLessonIds;
  int totalQuestionsAnswered;
  int totalQuestionsCorrect;
  int studyMinutesApprox;
  String displayName;
  String gradeLabel;
  String goalLabel;
  int avatarColorIndex;

  factory UserProgress.initial() {
    return UserProgress(
      totalXp: 0,
      currentStreak: 0,
      longestStreak: 0,
      lastActivityDateIso: null,
      completedLessonIds: {},
      totalQuestionsAnswered: 0,
      totalQuestionsCorrect: 0,
      studyMinutesApprox: 0,
      displayName: 'Estudiante',
      gradeLabel: '10',
      goalLabel: 'Saber 11',
      avatarColorIndex: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalXp': totalXp,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastActivityDateIso': lastActivityDateIso,
      'completedLessonIds': completedLessonIds.toList(),
      'totalQuestionsAnswered': totalQuestionsAnswered,
      'totalQuestionsCorrect': totalQuestionsCorrect,
      'studyMinutesApprox': studyMinutesApprox,
      'displayName': displayName,
      'gradeLabel': gradeLabel,
      'goalLabel': goalLabel,
      'avatarColorIndex': avatarColorIndex,
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    final ids = (json['completedLessonIds'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toSet() ??
        <String>{};
    return UserProgress(
      totalXp: json['totalXp'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastActivityDateIso: json['lastActivityDateIso'] as String?,
      completedLessonIds: ids,
      totalQuestionsAnswered: json['totalQuestionsAnswered'] as int? ?? 0,
      totalQuestionsCorrect: json['totalQuestionsCorrect'] as int? ?? 0,
      studyMinutesApprox: json['studyMinutesApprox'] as int? ?? 0,
      displayName: json['displayName'] as String? ?? 'Estudiante',
      gradeLabel: json['gradeLabel'] as String? ?? '10',
      goalLabel: json['goalLabel'] as String? ?? 'Saber 11',
      avatarColorIndex: json['avatarColorIndex'] as int? ?? 0,
    );
  }
}
