import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/models/user_role.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/gamification.dart';
import '../../widgets/learning_companion.dart';

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
        if (mounted) {
          context.go(AppRoutes.homeForRole(context.app.userRole == UserRole.teacher));
        }
      });
      return;
    }

    if (lesson.exercises.isEmpty) {
      _handled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await app.completeLessonSession(
          lessonId: widget.lessonId,
          estimatedMinutes: lesson.estimatedMinutes,
          correctCount: 0,
          totalQuestions: 0,
        );
        app.clearLessonAttempt();
        if (mounted) setState(() {});
      });
      return;
    }

    final sessionOk = app.activeLessonId == widget.lessonId &&
        app.activeLessonAnswers.isNotEmpty &&
        app.activeLessonAnswers.length == lesson.exercises.length;

    if (!sessionOk) {
      _handled = true;
      _invalidSession = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go(AppRoutes.homeForRole(context.app.userRole == UserRole.teacher));
        }
      });
      return;
    }

    _handled = true;

    _correct = app.activeCorrectCount;
    _total = app.activeLessonAnswers.length;

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

  void _goHome(BuildContext context) {
    final teacher = context.app.userRole == UserRole.teacher;
    context.go(AppRoutes.homeForRole(teacher));
  }

  @override
  Widget build(BuildContext context) {
    if (_invalidSession) {
      return Scaffold(
        appBar: AppBar(title: const Text('Práctica')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.hourglass_disabled_outlined, size: 48),
              const SizedBox(height: 16),
              Text(
                'No hay una sesión de práctica activa para esta lección.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Abre la lección, pulsa «Practicar» y responde los ejercicios en orden. Evita abrir esta pantalla desde un enlace guardado sin haber iniciado la práctica.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => _goHome(context),
                child: const Text('Ir al inicio'),
              ),
            ],
          ),
        ),
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
            LearningCompanion(
              mood: perfect ? CompanionMood.success : CompanionMood.idle,
              message: perfect
                  ? '¡Lección perfecta! Pibo está orgulloso.'
                  : 'Buen trabajo. Revisa la teoría si algo costó más.',
              compact: true,
            ),
            const SizedBox(height: 16),
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
              onPressed: () => _goHome(context),
              child: const Text('Volver al inicio'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                final teacher = context.app.userRole == UserRole.teacher;
                context.go(teacher ? AppRoutes.tDashboard : AppRoutes.sPath);
              },
              child: const Text('Ir a la ruta'),
            ),
          ],
        ),
      ),
    );
  }
}
