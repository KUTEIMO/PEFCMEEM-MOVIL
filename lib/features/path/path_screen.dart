import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/models/course_models.dart';
import '../../theme/app_tokens.dart';

class PathScreen extends StatelessWidget {
  const PathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final cat = app.catalog;
    final tokens = context.tokens;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruta de aprendizaje'),
      ),
      body: cat == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: cat.courses.length,
              itemBuilder: (context, i) {
                final c = cat.courses[i];
                final progress = app.unitProgressForCourse(c.id);
                final refs = cat.orderedLessonRefsForCourse(c.id);
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 12, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: c.area.accentColor.withValues(alpha: 0.15),
                            child: Icon(Icons.route_rounded, color: c.area.accentColor),
                          ),
                          title: Text(
                            c.title,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            '${c.units.length} unidad · ${c.allLessons.length} micro-lecciones',
                          ),
                          trailing: Text(
                            '${(progress * 100).round()}%',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: c.area.accentColor,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(tokens.radiusSm),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            color: c.area.accentColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...refs.asMap().entries.map((e) {
                          final idx = e.key;
                          final r = e.value;
                          final done = app.isLessonCompleted(r.lesson.id);
                          final unlocked = app.isLessonUnlocked(c.id, r.lesson.id);
                          final last = idx == refs.length - 1;
                          return _LessonNode(
                            index: idx + 1,
                            title: r.lesson.title,
                            difficulty: r.lesson.difficulty,
                            accent: c.area.accentColor,
                            done: done,
                            unlocked: unlocked,
                            showLineBelow: !last,
                            onTap: unlocked
                                ? () => context.push('/course/${c.id}/lesson/${r.lesson.id}')
                                : null,
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _LessonNode extends StatelessWidget {
  const _LessonNode({
    required this.index,
    required this.title,
    required this.difficulty,
    required this.accent,
    required this.done,
    required this.unlocked,
    required this.showLineBelow,
    this.onTap,
  });

  final int index;
  final String title;
  final int difficulty;
  final Color accent;
  final bool done;
  final bool unlocked;
  final bool showLineBelow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done
                          ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.25)
                          : unlocked
                              ? accent.withValues(alpha: 0.2)
                              : Theme.of(context).disabledColor.withValues(alpha: 0.15),
                      border: Border.all(
                        color: done ? Theme.of(context).colorScheme.secondary : accent,
                        width: unlocked ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: done
                          ? Icon(Icons.check_rounded, size: 16, color: Theme.of(context).colorScheme.secondary)
                          : Text(
                              '$index',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: unlocked ? accent : Theme.of(context).disabledColor,
                              ),
                            ),
                    ),
                  ),
                  if (showLineBelow)
                    Container(
                      width: 2,
                      height: 18,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: accent.withValues(alpha: unlocked ? 0.35 : 0.12),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: unlocked ? null : Theme.of(context).disabledColor,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      children: [
                        Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text('Nivel $difficulty/3', style: const TextStyle(fontSize: 11)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        if (!unlocked)
                          const Chip(
                            visualDensity: VisualDensity.compact,
                            avatar: Icon(Icons.lock_outline, size: 14),
                            label: Text('Bloqueada', style: TextStyle(fontSize: 11)),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
