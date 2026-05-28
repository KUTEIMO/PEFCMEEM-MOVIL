import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/models/course_models.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({required this.courseId, super.key});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final cat = app.catalog;
    if (cat == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    Course? course;
    for (final c in cat.courses) {
      if (c.id == courseId) {
        course = c;
        break;
      }
    }
    if (course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Curso')),
        body: const Center(child: Text('Curso no encontrado')),
      );
    }
    final selectedCourse = course;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCourse.title),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Text(
              'Progreso en el curso',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: app.unitProgressForCourse(selectedCourse.id),
                minHeight: 10,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...selectedCourse.units.map(
            (u) => ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                u.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              children: u.lessons.map((lesson) {
                final unlocked = app.isLessonUnlocked(selectedCourse.id, lesson.id);
                final done = app.isLessonCompleted(lesson.id);
                return ListTile(
                  leading: Icon(
                    done
                        ? Icons.check_circle_rounded
                        : unlocked
                            ? Icons.play_circle_outline_rounded
                            : Icons.lock_rounded,
                    color: done
                        ? Theme.of(context).colorScheme.secondary
                        : unlocked
                            ? selectedCourse.area.accentColor
                            : Theme.of(context).disabledColor,
                  ),
                  title: Text(lesson.title),
                  subtitle: Text('~${lesson.estimatedMinutes} min · ${lesson.exercises.length} ejercicios'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: unlocked
                      ? () => context.push('/course/${selectedCourse.id}/lesson/${lesson.id}')
                      : null,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
