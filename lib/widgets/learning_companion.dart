import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Lightweight mascot states (Duolingo-style feedback without Lottie).
enum CompanionMood {
  idle,
  success,
  streak,
  hint,
}

class LearningCompanion extends StatelessWidget {
  const LearningCompanion({
    required this.mood,
    this.message,
    this.compact = false,
    super.key,
  });

  final CompanionMood mood;
  final String? message;
  final bool compact;

  String _defaultLine(BuildContext context) {
    switch (mood) {
      case CompanionMood.idle:
        return 'Soy Pibo, tu guía. Vamos paso a paso.';
      case CompanionMood.success:
        return '¡Bien! Cada acierto suma confianza.';
      case CompanionMood.streak:
        return 'Tu racha cuenta: un poco cada día.';
      case CompanionMood.hint:
        return 'Lee con calma: el enunciado ya trae pistas.';
    }
  }

  IconData _icon() {
    switch (mood) {
      case CompanionMood.idle:
        return Icons.auto_awesome_rounded;
      case CompanionMood.success:
        return Icons.celebration_rounded;
      case CompanionMood.streak:
        return Icons.local_fire_department_rounded;
      case CompanionMood.hint:
        return Icons.lightbulb_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = context.tokens;
    final text = message ?? _defaultLine(context);
    final size = compact ? 44.0 : 72.0;

    return Semantics(
      label: 'Mascota Pibo. $text',
      child: AnimatedContainer(
        duration: tokens.motionMedium,
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(compact ? 10 : 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(tokens.radiusLg),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.primaryContainer.withValues(alpha: 0.85),
              scheme.tertiaryContainer.withValues(alpha: 0.55),
            ],
          ),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.6),
            width: tokens.challengeCardBorderWidth,
          ),
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: tokens.motionFast,
              child: Container(
                key: ValueKey(mood),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: scheme.surface.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon(), size: compact ? 24 : 36, color: scheme.primary),
              ),
            ),
            SizedBox(width: compact ? 12 : 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: tokens.motionMedium,
                child: Text(
                  text,
                  key: ValueKey(text),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
