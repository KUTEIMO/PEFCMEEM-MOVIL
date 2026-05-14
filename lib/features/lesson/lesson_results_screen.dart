import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/services/gamification.dart';

class LessonResultsScreen extends StatefulWidget {
  const LessonResultsScreen({
    required this.courseId,
    required this.lessonId,
    super.key,
  });

  final String courseId;
  final String lessonId;

  @override
  State<LessonResultsScreen> createState() => _LessonResultsScreenState();
}

class _LessonResultsScreenState extends State<LessonResultsScreen> {
  bool _handled = false;
  bool _invalidSession = false;
  int _correct = 0;
  int _total = 0;
  int _xp = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_handled) return;
    final app = context.app;
    final ref = app.catalog?.findLessonRef(widget.courseId, widget.lessonId);
    final lesson = ref?.lesson;
    if (lesson == null) {
      _handled = true;
      _invalidSession = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/home');
      });
      return;
    }

    if (app.activeLessonId != widget.lessonId || app.activeLessonAnswers.isEmpty) {
      _handled = true;
      _invalidSession = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/home');
      });
      return;
    }

    _handled = true;

    _correct = app.activeCorrectCount;
    _total = app.activeLessonAnswers.length;
    if (_total == 0) {
      _total = lesson.exercises.length;
    }

    var xpGain = 0;
    for (var i = 0; i < _correct; i++) {
      xpGain += Gamification.xpPerCorrectAnswer();
    }
    if (_total > 0 && _correct == _total) {
      xpGain += Gamification.perfectLessonBonus();
    }
    _xp = xpGain;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await app.completeLessonSession(
        lessonId: widget.lessonId,
        estimatedMinutes: lesson.estimatedMinutes,
        correctCount: _correct,
        totalQuestions: _total,
      );
      app.clearLessonAttempt();
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_invalidSession) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final perfect = _total > 0 && _correct == _total;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Lección completada',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Respuestas correctas: $_correct / $_total',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (perfect)
              Text(
                'Bonificación por lección perfecta aplicada.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded, size: 32),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('XP obtenida', style: Theme.of(context).textTheme.labelMedium),
                        Text(
                          '+$_xp',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                context.go('/home');
              },
              child: const Text('Volver al inicio'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                context.go('/path');
              },
              child: const Text('Ir a la ruta'),
            ),
          ],
        ),
      ),
    );
  }
}
