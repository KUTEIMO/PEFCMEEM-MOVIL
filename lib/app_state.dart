import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/models/course_models.dart';
import 'core/models/user_profile_doc.dart';
import 'core/models/user_progress.dart';
import 'core/models/user_role.dart';
import 'core/services/auth_service.dart';
import 'core/services/companion_context.dart';
import 'core/services/course_repository.dart';
import 'core/services/firebase_bootstrap.dart';
import 'core/services/gamification.dart';
import 'core/services/group_repository.dart';
import 'core/services/progress_store.dart';
import 'core/services/user_profile_repository.dart';
import 'widgets/learning_companion.dart';

class AppState extends ChangeNotifier {
  AppState({
    CourseRepository? courseRepository,
    GroupRepository? groupRepository,
    AuthService? authService,
    UserProfileRepository? userProfileRepository,
  })  : _courses = courseRepository ?? CourseRepository(),
        _groupRepository = groupRepository ?? GroupRepository(),
        _auth = authService ?? AuthService(),
        _profiles = userProfileRepository ?? UserProfileRepository();

  final CourseRepository _courses;
  final GroupRepository _groupRepository;
  final AuthService _auth;
  final UserProfileRepository _profiles;

  GoRouter? _goRouter;

  /// [GoRouter] estable: debe asignarse con [attachRouter] tras [init].
  GoRouter get router {
    final r = _goRouter;
    if (r == null) {
      throw StateError('GoRouter no adjuntado. Llama attachRouter tras init().');
    }
    return r;
  }

  /// El bootstrap crea el router **una sola vez** y lo enlaza aquí (evita recrear el router en cada rebuild).
  void attachRouter(GoRouter router) {
    if (_goRouter != null && !identical(_goRouter, router)) {
      _goRouter!.dispose();
    }
    _goRouter = router;
  }

  StreamSubscription<User?>? _authSub;

  UserProgress progress = UserProgress.initial();
  CourseCatalog? catalog;
  /// Error al cargar `assets/courses.json` o catálogo remoto (null si OK).
  String? catalogLoadError;
  bool onboardingDone = false;
  ThemeMode themeMode = ThemeMode.system;
  UserRole userRole = UserRole.student;
  String? currentGroupId;
  String? currentGroupCode;
  bool _ready = false;

  User? firebaseUser;
  UserProfileDoc? remoteProfile;
  /// Último fallo al leer/crear `users/{uid}` (p. ej. reglas o red).
  String? profileSyncError;

  CompanionMood companionMood = CompanionMood.idle;
  String companionShortTip = 'Soy Pibo: te acompaño en cada pantalla.';
  String companionLongTip =
      'EULER — Domina las matemáticas. — combina rutas cortas con grupos y ranking. Toca este recuadro cuando quieras un consejo más largo.';

  bool get isReady => _ready;

  String? get remoteSchoolName => remoteProfile?.schoolName;

  void updateCompanionForRoute(String path) {
    final s = CompanionContextLogic.resolve(path: path, role: userRole);
    if (companionMood != s.mood ||
        companionShortTip != s.shortTip ||
        companionLongTip != s.longTip) {
      companionMood = s.mood;
      companionShortTip = s.shortTip;
      companionLongTip = s.longTip;
      notifyListeners();
    }
  }

  Future<void> init() async {
    final snap = await ProgressStore.loadBootstrapSnapshot();
    progress = snap.progress;
    onboardingDone = snap.onboardingDone;
    userRole = UserRole.tryParse(snap.userRoleRaw) ?? UserRole.student;
    currentGroupId = snap.currentGroupId;
    currentGroupCode = snap.currentGroupCode;
    final tm = snap.themeModeRaw;
    if (tm == 'light') {
      themeMode = ThemeMode.light;
    } else if (tm == 'dark') {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.system;
    }

    catalogLoadError = null;
    try {
      _courses.onCatalogUpdated = _onRemoteCatalogUpdated;
      catalog = await _courses.loadCatalog();
    } catch (e) {
      catalogLoadError = e.toString();
      catalog = CourseCatalog.fromJson({'courses': <dynamic>[]});
    }

    firebaseUser = _auth.currentUser;
    if (firebaseUser?.isAnonymous == true) {
      await _auth.signOut();
      firebaseUser = null;
    } else if (firebaseUser != null) {
      if (kIsWeb) {
        try {
          await _syncRemoteProfile().timeout(const Duration(seconds: 5));
        } on TimeoutException {
          profileSyncError ??= 'Red lenta: el perfil se sincronizará al reconectar.';
        }
        try {
          await ensureFirestoreUserProfileIfMissing().timeout(const Duration(seconds: 5));
        } on TimeoutException {
          _swallowWebFirestoreTimeout();
        }
        try {
          await FirebaseBootstrap.seedMetaBootstrapDoc().timeout(const Duration(seconds: 3));
        } on TimeoutException {
          _swallowWebFirestoreTimeout();
        }
      } else {
        await _syncRemoteProfile();
        await ensureFirestoreUserProfileIfMissing();
        await FirebaseBootstrap.seedMetaBootstrapDoc();
      }
    }

    _authSub = _auth.authStateChanges().listen(_onAuthUser);

    _ready = true;
    notifyListeners();
  }

  void _onRemoteCatalogUpdated() {
    final next = _courses.cachedCatalog;
    if (next != null) {
      catalog = next;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _courses.onCatalogUpdated = null;
    _authSub?.cancel();
    _goRouter?.dispose();
    super.dispose();
  }

  Future<void> _onAuthUser(User? u) async {
    if (u?.isAnonymous == true) {
      await _auth.signOut();
      firebaseUser = null;
      remoteProfile = null;
      notifyListeners();
      return;
    }
    firebaseUser = u;
    if (u != null) {
      if (kIsWeb) {
        try {
          await _syncRemoteProfile().timeout(const Duration(seconds: 5));
        } on TimeoutException {
          profileSyncError ??= 'Red lenta: el perfil se sincronizará al reconectar.';
        }
        try {
          await ensureFirestoreUserProfileIfMissing().timeout(const Duration(seconds: 5));
        } on TimeoutException {
          _swallowWebFirestoreTimeout();
        }
        try {
          await FirebaseBootstrap.seedMetaBootstrapDoc().timeout(const Duration(seconds: 3));
        } on TimeoutException {
          _swallowWebFirestoreTimeout();
        }
      } else {
        await _syncRemoteProfile();
        await ensureFirestoreUserProfileIfMissing();
        await FirebaseBootstrap.seedMetaBootstrapDoc();
      }
    } else {
      remoteProfile = null;
    }
    notifyListeners();
  }

  Future<void> _syncRemoteProfile() async {
    final u = firebaseUser ?? _auth.currentUser;
    if (u == null) return;
    profileSyncError = null;
    try {
      final doc = await _profiles.fetchProfile(u.uid);
      remoteProfile = doc;
      if (doc != null) {
        userRole = doc.role;
        await ProgressStore.saveUserRole(userRole.storageValue);
        if (doc.displayName.isNotEmpty) {
          progress.displayName = doc.displayName;
          await ProgressStore.saveProgress(progress);
        }
        if (doc.onboardingComplete && !onboardingDone) {
          onboardingDone = true;
          await ProgressStore.setOnboardingDone(true);
        }
      }
    } catch (e) {
      profileSyncError = e.toString();
    }
  }

  /// Si hay sesión pero no existe `users/{uid}` (p. ej. registro interrumpido), crea un perfil mínimo.
  Future<void> ensureFirestoreUserProfileIfMissing() async {
    final u = firebaseUser ?? _auth.currentUser;
    if (u == null || !FirebaseBootstrap.firebaseAppReady) return;
    if (remoteProfile != null) return;
    final email = (u.email ?? '').trim();
    if (email.length < 5 || !email.contains('@')) {
      profileSyncError =
          'Esta cuenta no tiene un correo válido en Firebase Auth; no se puede crear el perfil en Firestore.';
      notifyListeners();
      return;
    }
    final name = progress.displayName.trim().isEmpty
        ? (email.split('@').first.isEmpty ? 'Usuario' : email.split('@').first)
        : progress.displayName.trim();
    try {
      await _profiles.createProfile(
        uid: u.uid,
        email: email,
        displayName: name,
        role: userRole,
        schoolName: userRole == UserRole.teacher ? remoteSchoolName : null,
      );
      profileSyncError = null;
      await _syncRemoteProfile();
    } catch (e) {
      profileSyncError = e.toString();
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    firebaseUser = null;
    remoteProfile = null;
    profileSyncError = null;
    notifyListeners();
  }

  Future<void> registerAndCreateProfile({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
    String? schoolName,
  }) async {
    final cred = await _auth.registerWithEmail(email: email, password: password);
    final u = cred.user!;
    try {
      await _profiles.createProfile(
        uid: u.uid,
        email: email,
        displayName: displayName,
        role: role,
        schoolName: role == UserRole.teacher ? schoolName : null,
      );
    } catch (e) {
      try {
        await u.delete();
      } catch (_) {}
      rethrow;
    }
    progress.displayName = displayName.trim().isEmpty
        ? (role == UserRole.teacher ? 'Docente' : 'Estudiante')
        : displayName.trim();
    await ProgressStore.saveProgress(progress);
    firebaseUser = u;
    profileSyncError = null;
    await _syncRemoteProfile();
    await FirebaseBootstrap.seedMetaBootstrapDoc();
    notifyListeners();
  }

  /// Tras registro docente (colegio ya en Firestore): marca onboarding local hecho.
  Future<void> finishTeacherRegistrationBootstrap(String displayName) async {
    userRole = UserRole.teacher;
    await ProgressStore.saveUserRole(UserRole.teacher.storageValue);
    progress.displayName = displayName.trim().isEmpty ? 'Docente' : displayName.trim();
    progress.gradeLabel = '—';
    progress.goalLabel = 'Seguimiento de grupo';
    onboardingDone = true;
    await ProgressStore.setOnboardingDone(true);
    await ProgressStore.saveProgress(progress);
    final u = firebaseUser ?? _auth.currentUser;
    if (u != null) {
      try {
        await _profiles.setOnboardingComplete(u.uid);
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    profileSyncError = null;
    final cred = await _auth.signInWithEmail(email: email, password: password);
    firebaseUser = cred.user;
    await _syncRemoteProfile();
    await ensureFirestoreUserProfileIfMissing();
    await FirebaseBootstrap.seedMetaBootstrapDoc();
    notifyListeners();
  }

  /// Tras publicar un catálogo nuevo en Firestore (`published/courses`).
  Future<void> refreshCatalog() async {
    _courses.clearCache();
    catalogLoadError = null;
    try {
      catalog = await _courses.loadCatalog();
    } catch (e) {
      catalogLoadError = e.toString();
    }
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

  Future<void> setUserRole(UserRole role) async {
    userRole = role;
    await ProgressStore.saveUserRole(role.storageValue);
    notifyListeners();
  }

  Future<void> setCurrentGroup(String groupId, String code) async {
    currentGroupId = groupId;
    currentGroupCode = code;
    await ProgressStore.saveCurrentGroupId(groupId);
    await ProgressStore.saveCurrentGroupCode(code);
    if (FirebaseBootstrap.isReady) {
      await _groupRepository.ensureMemberDisplayName(groupId, progress.displayName);
    }
    notifyListeners();
  }

  Future<void> clearCurrentGroup() async {
    currentGroupId = null;
    currentGroupCode = null;
    await ProgressStore.clearGroup();
    notifyListeners();
  }

  Future<void> completeOnboarding({
    required UserRole role,
    required String displayName,
    required String gradeLabel,
    required String goalLabel,
  }) async {
    userRole = role;
    await ProgressStore.saveUserRole(role.storageValue);
    progress.displayName = displayName.trim().isEmpty ? 'Estudiante' : displayName.trim();
    progress.gradeLabel = gradeLabel;
    progress.goalLabel = goalLabel;
    onboardingDone = true;
    await ProgressStore.setOnboardingDone(true);
    await ProgressStore.saveProgress(progress);
    final u = firebaseUser;
    if (u != null && !u.isAnonymous) {
      try {
        await _profiles.updateDisplayName(u.uid, progress.displayName);
        await _profiles.setOnboardingComplete(u.uid);
      } catch (_) {}
    }
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
    if (currentGroupId != null && FirebaseBootstrap.isReady) {
      try {
        await _groupRepository.addXpToMember(currentGroupId!, xpGain);
      } catch (_) {}
    }
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

/// Evita `empty_catches` en timeouts web (Firestore opcional al arranque).
void _swallowWebFirestoreTimeout() {}
