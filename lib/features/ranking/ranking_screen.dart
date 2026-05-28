import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/firebase_bootstrap.dart';
import '../../core/services/group_repository.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  static const _seed = <Map<String, Object>>[
    {'name': 'Colegio A · Laura M.', 'xp': 1840},
    {'name': 'Colegio B · Andrés P.', 'xp': 1720},
    {'name': 'Colegio A · Valentina R.', 'xp': 1650},
    {'name': 'Colegio C · Diego S.', 'xp': 1580},
    {'name': 'Colegio B · Camila T.', 'xp': 1490},
  ];

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final userXp = app.progress.totalXp;
    final gid = app.currentGroupId;
    final code = app.currentGroupCode;

    if (gid != null && FirebaseBootstrap.isReady) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ranking del grupo'),
          actions: [
            IconButton(
              tooltip: 'Chat con el grupo',
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              onPressed: () => context.push(AppRoutes.groupChat(gid)),
            ),
          ],
        ),
        body: StreamBuilder<List<GroupMember>>(
          stream: GroupRepository().leaderboardStream(gid),
          builder: (context, snap) {
            if (snap.hasError) {
              return Center(child: Text('Error: ${snap.error}'));
            }
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final rows = snap.data!;
            if (rows.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    'Aún no hay miembros con XP en este grupo. ¡Completa una lección!',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: rows.length,
              itemBuilder: (context, i) {
                final m = rows[i];
                final you = m.uid == FirebaseBootstrap.currentUser?.uid;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${i + 1}'),
                    ),
                    title: Text(
                      you ? 'Tú · ${m.displayName}' : m.displayName,
                      style: TextStyle(fontWeight: you ? FontWeight.w700 : FontWeight.w500),
                    ),
                    trailing: Text(
                      '${m.totalXp} XP',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Ranking de demostración',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    gid != null && !FirebaseBootstrap.isReady
                        ? 'Tu grupo está guardado (código: ${code ?? "—"}), pero Firebase no está configurado todavía. Sigue docs/FIREBASE_SETUP.md.'
                        : 'Únete a un grupo con código del profe para ver el ranking en vivo entre compañeros.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.push('/join-group'),
                    child: const Text('Unirme con código'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ..._seed.asMap().entries.map((e) {
            final i = e.key;
            final row = e.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${i + 1}'),
                ),
                title: Text(row['name']! as String),
                trailing: Text(
                  '${row['xp']} XP',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            );
          }),
          Card(
            margin: const EdgeInsets.only(top: 8),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person_rounded),
              ),
              title: Text('Tú · ${app.progress.displayName}'),
              subtitle: const Text('Tu XP local'),
              trailing: Text(
                '$userXp XP',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
