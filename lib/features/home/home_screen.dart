import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/branding_strings.dart';
import '../../core/models/course_models.dart';
import '../../core/services/gamification.dart';
import '../../theme/app_tokens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final cat = app.catalog;
    final p = app.progress;
    final cont = app.continueLessonRef();
    final level = Gamification.levelFromTotalXp(p.totalXp);
    final xpNext = Gamification.xpForNextLevel(p.totalXp);

    final tokens = context.tokens;
    final daily = cat?.dailyChallengeRef();
    final dailyDone = daily != null && app.isLessonCompleted(daily.lesson.id);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/branding/pefcmeem_mark.svg',
              height: 26,
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    BrandingStrings.acronym,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    BrandingStrings.appTagline,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(tokens.radiusXl),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  tokens.heroGradientStart,
                  tokens.heroGradientEnd,
                ],
              ),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola, ${p.displayName}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Grado ${p.gradeLabel} · Meta: ${p.goalLabel}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (app.currentGroupCode != null) ...[
                  const SizedBox(height: 8),
                  Chip(
                    avatar: const Icon(Icons.groups_rounded, size: 18),
                    label: Text('Grupo ${app.currentGroupCode}'),
                  ),
                ],
                const SizedBox(height: 12),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.calendar_view_week_outlined,
                  label: 'Racha',
                  value: '${p.currentStreak} d',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  icon: Icons.military_tech_outlined,
                  label: 'Nivel',
                  value: '$level',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  icon: Icons.bolt_outlined,
                  label: 'XP',
                  value: '${p.totalXp}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Siguiente nivel en $xpNext XP',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          if (daily != null) ...[
            const SizedBox(height: 24),
            Text(
              'Reto del día',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Icon(Icons.flag_rounded, color: daily.course.area.accentColor),
                title: Text(daily.lesson.title),
                subtitle: Text(
                  '${daily.course.title} · Intensidad ${daily.lesson.difficulty}/3${dailyDone ? ' · Hecho' : ''}',
                ),
                trailing: FilledButton(
                  onPressed: dailyDone || !app.isLessonUnlocked(daily.course.id, daily.lesson.id)
                      ? null
                      : () => context.push(
                            '/course/${daily.course.id}/lesson/${daily.lesson.id}',
                          ),
                  child: Text(dailyDone ? 'Listo' : 'Ir'),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            'Continúa tu progreso',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: cont == null
                  ? null
                  : () => context.push(
                        '/course/${cont.course.id}/lesson/${cont.lesson.id}',
                      ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: cont == null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Has completado el recorrido semilla',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Explora la ruta para repasar temas o revisa estadísticas.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cont.lesson.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cont.course.title,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.schedule, size: 18, color: cont.course.area.accentColor),
                              const SizedBox(width: 6),
                              Text(
                                '~${cont.lesson.estimatedMinutes} min',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const Spacer(),
                              FilledButton(
                                onPressed: () => context.push(
                                  '/course/${cont.course.id}/lesson/${cont.lesson.id}',
                                ),
                                child: const Text('Continuar'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: app.unitProgressForCourse(cont.course.id),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Avance en ${cont.course.title}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Hoy puedes avanzar con',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          if (cat != null)
            ...cat.courses.take(3).map(
                  (c) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.circle, color: c.area.accentColor, size: 12),
                    title: Text(c.title),
                    subtitle: Text('Micro-lecciones: ${c.allLessons.length}'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/course/${c.id}'),
                  ),
                ),
          const SizedBox(height: 16),
          Text(
            'Resumen rápido',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _MiniMetric(
                  label: 'Precisión',
                  value: app.progress.totalQuestionsAnswered == 0
                      ? '—'
                      : '${(app.accuracy * 100).round()}%',
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: 'Temas dominados',
                  value: '${app.topicsMasteredCount}/${cat?.courses.length ?? 0}',
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: 'Tiempo aprox.',
                  value: '${p.studyMinutesApprox} min',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
