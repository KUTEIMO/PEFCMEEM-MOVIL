import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';

class LessonTheoryScreen extends StatelessWidget {
  const LessonTheoryScreen({
    required this.courseId,
    required this.lessonId,
    super.key,
  });

  final String courseId;
  final String lessonId;

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final ref = app.catalog?.findLessonRef(courseId, lessonId);
    if (ref == null) {
      return const Scaffold(body: Center(child: Text('Lección no encontrada')));
    }
    final lesson = ref.lesson;
    final done = app.isLessonCompleted(lessonId);

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(
                        label: Text('~${lesson.estimatedMinutes} min'),
                        avatar: const Icon(Icons.schedule, size: 18),
                      ),
                      const SizedBox(width: 8),
                      if (done)
                        Chip(
                          label: const Text('Completada'),
                          avatar: const Icon(Icons.verified_outlined, size: 18),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Teoría',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lesson.theoryPlain,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: done
                  ? OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Volver'),
                    )
                  : FilledButton(
                      onPressed: () {
                        app.startLessonAttempt(lesson.id, lesson.exercises.length);
                        context.push('/course/$courseId/lesson/$lessonId/exercise/0');
                      },
                      child: const Text('Practicar'),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
