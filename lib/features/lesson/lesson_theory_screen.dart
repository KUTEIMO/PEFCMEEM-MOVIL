import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../widgets/learning_companion.dart';

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
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        label: Text('~${lesson.estimatedMinutes} min'),
                        avatar: const Icon(Icons.schedule, size: 18),
                      ),
                      Chip(
                        label: Text('Intensidad ${lesson.difficulty}/3'),
                        avatar: const Icon(Icons.speed_rounded, size: 18),
                      ),
                      if (done)
                        Chip(
                          label: const Text('Completada'),
                          avatar: const Icon(Icons.verified_outlined, size: 18),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const LearningCompanion(mood: CompanionMood.hint, compact: true),
                  const SizedBox(height: 16),
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
                  : lesson.exercises.isEmpty
                      ? FilledButton(
                          onPressed: () async {
                            await app.completeLessonSession(
                              lessonId: lesson.id,
                              estimatedMinutes: lesson.estimatedMinutes,
                              correctCount: 0,
                              totalQuestions: 0,
                            );
                            if (context.mounted) context.pop();
                          },
                          child: const Text('Marcar lección como vista'),
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
