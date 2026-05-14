import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_bootstrap.dart';

class GroupMember {
  const GroupMember({
    required this.uid,
    required this.displayName,
    required this.totalXp,
  });

  final String uid;
  final String displayName;
  final int totalXp;
}

class GroupInfo {
  const GroupInfo({
    required this.id,
    required this.name,
    required this.code,
    required this.teacherUid,
  });

  final String id;
  final String name;
  final String code;
  final String teacherUid;
}

class GroupRepository {
  GroupRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  bool get _ok => FirebaseBootstrap.isReady && _auth.currentUser != null;

  CollectionReference<Map<String, dynamic>> get _groups =>
      _db.collection('groups');

  static const _codeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  String _randomCode() {
    final r = Random.secure();
    return List.generate(6, (_) => _codeChars[r.nextInt(_codeChars.length)]).join();
  }

  Future<String> _uniqueCode() async {
    for (var attempt = 0; attempt < 12; attempt++) {
      final code = _randomCode();
      final snap = await _groups.where('code', isEqualTo: code).limit(1).get();
      if (snap.docs.isEmpty) return code;
    }
    throw StateError('No se pudo generar un código único');
  }

  /// Crea un grupo; el usuario actual debe ser el docente (se guarda [teacherUid]).
  Future<GroupInfo> createGroup({required String name}) async {
    if (!_ok) {
      throw StateError('Firebase no está listo. Configura firebase_options y google-services.');
    }
    final uid = _auth.currentUser!.uid;
    final code = await _uniqueCode();
    final doc = _groups.doc();
    final cleanName = name.trim().isEmpty ? 'Grupo' : name.trim();
    await doc.set({
      'name': cleanName,
      'code': code,
      'teacherUid': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return GroupInfo(id: doc.id, name: cleanName, code: code, teacherUid: uid);
  }

  /// Busca grupo por código y añade al usuario como miembro.
  Future<GroupInfo> joinGroupByCode(
    String rawCode, {
    required String memberDisplayName,
  }) async {
    if (!_ok) {
      throw StateError('Firebase no está listo.');
    }
    final code = rawCode.trim().toUpperCase();
    if (code.length < 4) {
      throw ArgumentError('Código demasiado corto');
    }
    final snap = await _groups.where('code', isEqualTo: code).limit(1).get();
    if (snap.docs.isEmpty) {
      throw StateError('No existe un grupo con ese código');
    }
    final doc = snap.docs.first;
    final data = doc.data();
    final uid = _auth.currentUser!.uid;
    final teacherUid = data['teacherUid'] as String? ?? '';
    if (uid == teacherUid) {
      return GroupInfo(
        id: doc.id,
        name: data['name'] as String? ?? 'Grupo',
        code: data['code'] as String? ?? code,
        teacherUid: teacherUid,
      );
    }
    final memberRef = doc.reference.collection('members').doc(uid);
    final displayName = memberDisplayName.trim().isEmpty ? 'Estudiante' : memberDisplayName.trim();
    await memberRef.set({
      'displayName': displayName,
      'totalXp': 0,
      'joinedAt': FieldValue.serverTimestamp(),
      'lastActiveAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return GroupInfo(
      id: doc.id,
      name: data['name'] as String? ?? 'Grupo',
      code: data['code'] as String? ?? code,
      teacherUid: teacherUid,
    );
  }

  Future<void> ensureMemberDisplayName(String groupId, String displayName) async {
    if (!_ok) return;
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _groups.doc(groupId).collection('members').doc(uid).set(
      {
        'displayName': displayName.trim().isEmpty ? 'Estudiante' : displayName.trim(),
        'lastActiveAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> addXpToMember(String groupId, int delta) async {
    if (!_ok || delta == 0) return;
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _groups.doc(groupId).collection('members').doc(uid).set(
      {
        'totalXp': FieldValue.increment(delta),
        'lastActiveAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Stream<List<GroupMember>> leaderboardStream(String groupId) {
    if (!_ok) {
      return const Stream.empty();
    }
    return _groups
        .doc(groupId)
        .collection('members')
        .orderBy('totalXp', descending: true)
        .limit(50)
        .snapshots()
        .map((snap) {
      return snap.docs.map((d) {
        final m = d.data();
        return GroupMember(
          uid: d.id,
          displayName: m['displayName'] as String? ?? '—',
          totalXp: (m['totalXp'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    });
  }

  Future<List<GroupInfo>> groupsWhereTeacher() async {
    if (!_ok) return [];
    final uid = _auth.currentUser!.uid;
    final snap = await _groups.where('teacherUid', isEqualTo: uid).get();
    return snap.docs.map((d) {
      final m = d.data();
      return GroupInfo(
        id: d.id,
        name: m['name'] as String? ?? 'Grupo',
        code: m['code'] as String? ?? '',
        teacherUid: m['teacherUid'] as String? ?? '',
      );
    }).toList();
  }
}
