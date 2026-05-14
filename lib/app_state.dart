import 'package:flutter/material.dart';

import 'core/models/course_models.dart';
import 'core/models/user_progress.dart';
import 'core/services/course_repository.dart';
import 'core/services/gamification.dart';
import 'core/services/progress_store.dart';

class AppState extends ChangeNotifier {
  AppState({
    CourseRepository? courseRepository,
  }) : _courses = courseRepository ?? CourseRepository();

  final CourseRepository _courses;

  UserProgress progress = UserProgress.initial();
  CourseCatalog? catalog;
  bool onboardingDone = false;
  ThemeMode themeMode = ThemeMode.system;
  bool _ready = false;

  bool get isReady => _ready;

  Future<void> init() async {
    progress = await ProgressStore.loadProgress();
    onboardingDone = await ProgressStore.loadOnboardingDone();
    final tm = await ProgressStore.loadThemeMode();
    if (tm == 'light') {
      themeMode = ThemeMode.light;
    } else if (tm == 'dark') {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.system;
    }
    catalog = await _courses.loadCatalog();
    _ready = true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    final s = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await ProgressStore.saveThemeMode(s);
    notifyListeners();
  }

  Future<void> completeOnboarding({
    required String displayName,
    required String gradeLabel,
    required String goalLabel,
  }) async {
    progress.displayName = displayName.trim().isEmpty ? 'Estudiante' : displayName.trim();
    progress.gradeLabel = gradeLabel;
    progress.goalLabel = goalLabel;
    onboardingDone = true;
    await ProgressStore.setOnboardingDone(true);
    await ProgressStore.saveProgress(progress);
    notifyListeners();
  }

  Future<void> setAvatarColorIndex(int index) async {
    progress.avatarColorIndex = index;
    await ProgressStore.saveProgress(progress);
    notifyListeners();
  }

  List<LessonRef> _refsForCourse(String courseId) {
    final cat = catalog;
    if (cat == null) return [];
    return cat.orderedLessonRefsForCourse(courseId);
  }

  bool isLessonUnlocked(String courseId, String lessonId) {
    final refs = _refsForCourse(courseId);
    final idx = refs.indexWhere((r) => r.lesson.id == lessonId);
    if (idx < 0) return false;
    if (idx == 0) return true;
    final prev = refs[idx - 1].lesson.id;
    return progress.completedLessonIds.contains(prev);
  }

  bool isLessonCompleted(String lessonId) =>
      progress.completedLessonIds.contains(lessonId);

  double unitProgressForCourse(String courseId) {
    final refs = _refsForCourse(courseId);
    if (refs.isEmpty) return 0;
    final done = refs.where((r) => progress.completedLessonIds.contains(r.lesson.id)).length;
    return done / refs.length;
  }

  LessonRef? continueLessonRef() {
    final cat = catalog;
    if (cat == null) return null;
    for (final c in cat.courses) {
      final refs = cat.orderedLessonRefsForCourse(c.id);
      for (final r in refs) {
        if (!isLessonUnlocked(c.id, r.lesson.id)) break;
        if (!progress.completedLessonIds.contains(r.lesson.id)) {
          return r;
        }
      }
    }
    return null;
  }

  /// Al finalizar una lección: actualiza XP, racha y minutos aproximados.
  Future<void> completeLessonSession({
    required String lessonId,
    required int estimatedMinutes,
    required int correctCount,
    required int totalQuestions,
  }) async {
    if (progress.completedLessonIds.contains(lessonId)) {
      await ProgressStore.saveProgress(progress);
      notifyListeners();
      return;
    }
    var xpGain = 0;
    for (var i = 0; i < correctCount; i++) {
      xpGain += Gamification.xpPerCorrectAnswer();
    }
    if (totalQuestions > 0 && correctCount == totalQuestions) {
      xpGain += Gamification.perfectLessonBonus();
    }

    progress.totalXp += xpGain;
    progress.totalQuestionsAnswered += totalQuestions;
    progress.totalQuestionsCorrect += correctCount;
    progress.studyMinutesApprox += estimatedMinutes;
    progress.completedLessonIds.add(lessonId);
    _updateStreak();
    if (progress.currentStreak > progress.longestStreak) {
      progress.longestStreak = progress.currentStreak;
    }
    await ProgressStore.saveProgress(progress);
    notifyListeners();
  }

  void _updateStreak() {
    final now = DateTime.now();
    final today = _isoDate(now);
    final last = progress.lastActivityDateIso;
    if (last == null) {
      progress.currentStreak = 1;
    } else if (last == today) {
      // Ya hubo actividad hoy; mantener racha
    } else {
      final lastDt = DateTime.tryParse(last);
      if (lastDt == null) {
        progress.currentStreak = 1;
      } else {
        final diff = now.difference(DateTime(lastDt.year, lastDt.month, lastDt.day)).inDays;
        if (diff == 1) {
          progress.currentStreak += 1;
        } else {
          progress.currentStreak = 1;
        }
      }
    }
    progress.lastActivityDateIso = today;
  }

  String _isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  double get accuracy {
    if (progress.totalQuestionsAnswered == 0) return 0;
    return progress.totalQuestionsCorrect / progress.totalQuestionsAnswered;
  }

  /// Intento actual de lección (respuestas por índice de ejercicio).
  String? activeLessonId;
  List<bool> activeLessonAnswers = [];

  void startLessonAttempt(String lessonId, int exerciseCount) {
    activeLessonId = lessonId;
    activeLessonAnswers = List.filled(exerciseCount, false);
    notifyListeners();
  }

  void setExerciseResultAt(int index, bool correct) {
    if (index < 0 || index >= activeLessonAnswers.length) return;
    activeLessonAnswers[index] = correct;
    notifyListeners();
  }

  int get activeCorrectCount =>
      activeLessonAnswers.where((e) => e).length;

  void clearLessonAttempt() {
    activeLessonId = null;
    activeLessonAnswers = [];
    notifyListeners();
  }

  int get topicsMasteredCount {
    final cat = catalog;
    if (cat == null) return 0;
    var n = 0;
    for (final c in cat.courses) {
      final all = c.allLessons.map((l) => l.id).toSet();
      if (all.isEmpty) continue;
      final done = all.every(progress.completedLessonIds.contains);
      if (done) n++;
    }
    return n;
  }
}
