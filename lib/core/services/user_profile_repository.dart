import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile_doc.dart';
import '../models/user_role.dart';
import 'firebase_bootstrap.dart';

class UserProfileRepository {
  UserProfileRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  DocumentReference<Map<String, dynamic>> _ref(String uid) => _db.collection('users').doc(uid);

  Future<UserProfileDoc?> fetchProfile(String uid) async {
    if (!FirebaseBootstrap.firebaseInitialized) return null;
    final snap = await _ref(uid).get();
    if (!snap.exists) return null;
    final user = _auth.currentUser;
    return UserProfileDoc.fromMap(snap.data(), fallbackEmail: user?.email ?? '');
  }

  Future<void> createProfile({
    required String uid,
    required String email,
    required String displayName,
    required UserRole role,
    String? schoolName,
  }) async {
    if (!FirebaseBootstrap.firebaseInitialized) {
      throw StateError('Firebase no inicializado');
    }
    final cleanSchool = schoolName?.trim();
    await _ref(uid).set(
      {
        'email': email.trim(),
        'displayName': displayName.trim().isEmpty ? 'Usuario' : displayName.trim(),
        'role': role.storageValue,
        if (role == UserRole.teacher &&
            cleanSchool != null &&
            cleanSchool.isNotEmpty)
          'schoolName': cleanSchool,
      },
      SetOptions(merge: true),
    );
  }

  Future<void> updateTeacherSchool(String uid, String schoolName) async {
    if (!FirebaseBootstrap.firebaseInitialized) return;
    final s = schoolName.trim();
    if (s.length < 2) return;
    await _ref(uid).set({'schoolName': s}, SetOptions(merge: true));
  }

  Future<void> updateDisplayName(String uid, String displayName) async {
    if (!FirebaseBootstrap.firebaseInitialized) return;
    final d = displayName.trim().isEmpty ? 'Usuario' : displayName.trim();
    await _ref(uid).set({'displayName': d}, SetOptions(merge: true));
  }
}
