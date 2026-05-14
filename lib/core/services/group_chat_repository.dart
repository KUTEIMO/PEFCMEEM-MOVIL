import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_bootstrap.dart';

class GroupChatMessage {
  const GroupChatMessage({
    required this.id,
    required this.senderUid,
    required this.senderName,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String senderUid;
  final String senderName;
  final String text;
  final DateTime? createdAt;
}

class GroupChatRepository {
  GroupChatRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  bool get _ok => FirebaseBootstrap.isReady && _auth.currentUser != null;

  CollectionReference<Map<String, dynamic>> _col(String groupId) =>
      _db.collection('groups').doc(groupId).collection('messages');

  Stream<List<GroupChatMessage>> messagesStream(String groupId) {
    if (!_ok) return const Stream.empty();
    return _col(groupId).orderBy('createdAt', descending: true).limit(100).snapshots().map((snap) {
      return snap.docs.map((d) {
        final m = d.data();
        final ts = m['createdAt'];
        DateTime? at;
        if (ts is Timestamp) at = ts.toDate();
        return GroupChatMessage(
          id: d.id,
          senderUid: m['senderUid'] as String? ?? '',
          senderName: m['senderName'] as String? ?? '—',
          text: m['text'] as String? ?? '',
          createdAt: at,
        );
      }).toList();
    });
  }

  Future<void> sendMessage({
    required String groupId,
    required String text,
    required String senderName,
  }) async {
    if (!_ok) throw StateError('Sin sesión');
    final uid = _auth.currentUser!.uid;
    final t = text.trim();
    if (t.isEmpty) return;
    await _col(groupId).add({
      'senderUid': uid,
      'senderName': senderName.trim().isEmpty ? 'Usuario' : senderName.trim(),
      'text': t,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
