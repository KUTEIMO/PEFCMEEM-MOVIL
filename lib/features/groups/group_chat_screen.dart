import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/services/firebase_bootstrap.dart';
import '../../core/services/group_chat_repository.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({required this.groupId, super.key});

  final String groupId;

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _repo = GroupChatRepository();
  final _text = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _text.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final raw = _text.text.trim();
    if (raw.isEmpty) return;
    try {
      await _repo.sendMessage(
        groupId: widget.groupId,
        text: raw,
        senderName: context.app.progress.displayName,
      );
      _text.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final uid = app.firebaseUser?.uid;

    if (!FirebaseBootstrap.isReady) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat del grupo')),
        body: const Center(child: Text('Inicia sesión para usar el chat.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat del grupo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<GroupChatMessage>>(
              stream: _repo.messagesStream(widget.groupId),
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(child: Text('${snap.error}'));
                }
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final list = snap.data!;
                if (list.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Aún no hay mensajes. Saluda o pregunta a tu docente.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scroll,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final m = list[i];
                    final mine = m.senderUid == uid;
                    return Align(
                      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.82),
                        child: Card(
                          color: mine
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mine ? 'Tú' : m.senderName,
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                SelectableText(m.text),
                                if (m.createdAt != null) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    _fmt(m.createdAt!),
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _text,
                      minLines: 1,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un mensaje…',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _send,
                    child: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) {
    final t = TimeOfDay.fromDateTime(d);
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }
}
