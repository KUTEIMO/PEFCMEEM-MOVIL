import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_progress.dart';
import 'firebase_bootstrap.dart';
import 'progress_store.dart';

/// Fase 2: sincroniza `users/{uid}/learning_progress/default` con caché local.
class ProgressFirestoreService {
  static const _docId = 'default';

  static DocumentReference<Map<String, dynamic>>? _ref(String uid) {
    if (!FirebaseBootstrap.firebaseAppReady) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('learning_progress')
        .doc(_docId);
  }

  static UserProgress _fromMap(Map<String, dynamic> data) {
    final base = UserProgress.initial();
    final ids = data['completedLessonIds'];
    return UserProgress(
      totalXp: data['totalXp'] as int? ?? 0,
      currentStreak: data['currentStreak'] as int? ?? 0,
      longestStreak: data['longestStreak'] as int? ?? 0,
      lastActivityDateIso: data['lastActivityDateIso'] as String?,
      completedLessonIds: ids is List
          ? ids.map((e) => e as String).toSet()
          : base.completedLessonIds,
      totalQuestionsAnswered: data['totalQuestionsAnswered'] as int? ?? 0,
      totalQuestionsCorrect: data['totalQuestionsCorrect'] as int? ?? 0,
      studyMinutesApprox: data['studyMinutesApprox'] as int? ?? 0,
      displayName: data['displayName'] as String? ?? base.displayName,
      gradeLabel: data['gradeLabel'] as String? ?? base.gradeLabel,
      goalLabel: data['goalLabel'] as String? ?? base.goalLabel,
      avatarColorIndex: data['avatarColorIndex'] as int? ?? 0,
    );
  }

  static Map<String, dynamic> _toMap(UserProgress p) => {
        ...p.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  static UserProgress merge(UserProgress local, UserProgress remote) {
    final lessons = {...local.completedLessonIds, ...remote.completedLessonIds};
    final pickRemote = remote.totalXp > local.totalXp ||
        remote.totalQuestionsAnswered > local.totalQuestionsAnswered;
    final base = pickRemote ? remote : local;
    return UserProgress(
      totalXp: local.totalXp > remote.totalXp ? local.totalXp : remote.totalXp,
      currentStreak: local.currentStreak > remote.currentStreak
          ? local.currentStreak
          : remote.currentStreak,
      longestStreak: local.longestStreak > remote.longestStreak
          ? local.longestStreak
          : remote.longestStreak,
      lastActivityDateIso: base.lastActivityDateIso,
      completedLessonIds: lessons,
      totalQuestionsAnswered: local.totalQuestionsAnswered >
              remote.totalQuestionsAnswered
          ? local.totalQuestionsAnswered
          : remote.totalQuestionsAnswered,
      totalQuestionsCorrect: local.totalQuestionsCorrect >
              remote.totalQuestionsCorrect
          ? local.totalQuestionsCorrect
          : remote.totalQuestionsCorrect,
      studyMinutesApprox: local.studyMinutesApprox > remote.studyMinutesApprox
          ? local.studyMinutesApprox
          : remote.studyMinutesApprox,
      displayName:
          remote.displayName.isNotEmpty ? remote.displayName : local.displayName,
      gradeLabel: remote.gradeLabel.isNotEmpty ? remote.gradeLabel : local.gradeLabel,
      goalLabel: remote.goalLabel.isNotEmpty ? remote.goalLabel : local.goalLabel,
      avatarColorIndex: base.avatarColorIndex,
    );
  }

  static Future<UserProgress> syncOnLogin(String uid) async {
    final local = await ProgressStore.loadProgress();
    final ref = _ref(uid);
    if (ref == null) return local;
    final snap = await ref.get();
    if (!snap.exists) {
      if (local.totalXp > 0 || local.completedLessonIds.isNotEmpty) {
        await ref.set(_toMap(local), SetOptions(merge: true));
      }
      return local;
    }
    final remote = _fromMap(snap.data()!);
    final merged = merge(local, remote);
    await ProgressStore.saveProgress(merged);
    await ref.set(_toMap(merged), SetOptions(merge: true));
    return merged;
  }

  static Future<void> push(String uid, UserProgress progress) async {
    final ref = _ref(uid);
    if (ref == null) return;
    await ref.set(_toMap(progress), SetOptions(merge: true));
  }
}
