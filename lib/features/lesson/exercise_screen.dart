import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({
    required this.courseId,
    required this.lessonId,
    required this.exerciseIndex,
    super.key,
  });

  final String courseId;
  final String lessonId;
  final int exerciseIndex;

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  int? _selected;
  bool _revealed = false;
  bool _feedbackPositive = false;

  @override
  void didUpdateWidget(covariant ExerciseScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exerciseIndex != widget.exerciseIndex) {
      _selected = null;
      _revealed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final ref = app.catalog?.findLessonRef(widget.courseId, widget.lessonId);
    if (ref == null) {
      return const Scaffold(body: Center(child: Text('Lección no encontrada')));
    }
    final exs = ref.lesson.exercises;
    if (widget.exerciseIndex < 0 || widget.exerciseIndex >= exs.length) {
      return const Scaffold(body: Center(child: Text('Ejercicio no válido')));
    }
    final ex = exs[widget.exerciseIndex];
    final total = exs.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicio ${widget.exerciseIndex + 1} de $total'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (widget.exerciseIndex + (_revealed ? 1 : 0)) / total,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Te faltan ${total - widget.exerciseIndex - (_revealed ? 1 : 0)} ejercicios en esta lección',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ex.prompt,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _revealed
                            ? (_feedbackPositive
                                ? Theme.of(context).colorScheme.secondaryContainer
                                : Theme.of(context).colorScheme.errorContainer)
                            : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: _revealed
                          ? Text(
                              ex.explanation,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 20),
                    ...List.generate(ex.options.length, (i) {
                      final selected = _selected == i;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            backgroundColor: selected
                                ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.35)
                                : null,
                          ),
                          onPressed: _revealed
                              ? null
                              : () => setState(() {
                                    _selected = i;
                                  }),
                          child: Text(ex.options[i]),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            FilledButton(
              onPressed: _selected == null
                  ? null
                  : () async {
                      if (!_revealed) {
                        final ok = _selected == ex.correctIndex;
                        setState(() {
                          _revealed = true;
                          _feedbackPositive = ok;
                        });
                        app.setExerciseResultAt(widget.exerciseIndex, ok);
                        return;
                      }
                      final last = widget.exerciseIndex >= total - 1;
                      if (last) {
                        if (context.mounted) {
                          context.go('/course/${widget.courseId}/lesson/${widget.lessonId}/results');
                        }
                      } else {
                        if (context.mounted) {
                          context.pushReplacement(
                            '/course/${widget.courseId}/lesson/${widget.lessonId}/exercise/${widget.exerciseIndex + 1}',
                          );
                        }
                      }
                    },
              child: Text(_revealed ? (widget.exerciseIndex >= total - 1 ? 'Ver resultados' : 'Siguiente') : 'Comprobar'),
            ),
          ],
        ),
      ),
    );
  }
}
