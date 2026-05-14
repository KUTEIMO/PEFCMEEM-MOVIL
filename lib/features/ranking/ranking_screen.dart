import 'package:flutter/material.dart';

import '../../app.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking semanal (demo)'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Datos ilustrativos para la ponencia. La versión completa integrará colegios y cuentas reales.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
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
              subtitle: const Text('Tu posición local'),
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
