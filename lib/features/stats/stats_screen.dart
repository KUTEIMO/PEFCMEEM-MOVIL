import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/services/gamification.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final p = app.progress;
    final acc = app.progress.totalQuestionsAnswered == 0
        ? null
        : (app.accuracy * 100).round();
    final level = Gamification.levelFromTotalXp(p.totalXp);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Resumen de desempeño',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          _StatCard(
            icon: Icons.track_changes_rounded,
            title: 'Precisión',
            value: acc == null ? 'Sin datos aún' : '$acc%',
            detail: '${p.totalQuestionsCorrect} correctas de ${p.totalQuestionsAnswered} intentos registrados',
          ),
          _StatCard(
            icon: Icons.category_outlined,
            title: 'Temas dominados',
            value: '${app.topicsMasteredCount} / ${app.catalog?.courses.length ?? 0}',
            detail: 'Un tema se considera dominado al completar todas sus micro-lecciones.',
          ),
          _StatCard(
            icon: Icons.schedule_rounded,
            title: 'Tiempo de estudio aproximado',
            value: '${p.studyMinutesApprox} min',
            detail: 'Suma de la duración estimada de lecciones completadas.',
          ),
          _StatCard(
            icon: Icons.military_tech_outlined,
            title: 'Nivel actual',
            value: '$level',
            detail: 'Progresión simple basada en XP total.',
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.event_repeat_outlined),
              title: const Text('Repasos inteligentes'),
              subtitle: const Text(
                'Próxima fase: repetición espaciada según temas débiles y recordatorios locales.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    detail,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
