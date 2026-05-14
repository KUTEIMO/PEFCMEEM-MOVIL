import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app.dart';
import '../theme/app_tokens.dart';
import 'learning_companion.dart';

/// Pibo flotante sobre el contenido: tap para ver consejo largo.
class CompanionDock extends StatelessWidget {
  const CompanionDock({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final scheme = Theme.of(context).colorScheme;
    final tokens = context.tokens;

    return Material(
      elevation: 6,
      shadowColor: Colors.black38,
      borderRadius: BorderRadius.circular(tokens.radiusXl),
      child: InkWell(
        borderRadius: BorderRadius.circular(tokens.radiusXl),
        onTap: () {
          final mq = MediaQuery.of(context);
          final sheetW = math.min(mq.size.width - 32, 480.0);
          final sheetH = mq.size.height * 0.88;
          showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            constraints: BoxConstraints(maxWidth: sheetW, maxHeight: sheetH),
            builder: (ctx) {
              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Pibo',
                        style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 12),
                      LearningCompanion(
                        mood: app.companionMood,
                        message: app.companionShortTip,
                        compact: true,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        app.companionLongTip,
                        style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(height: 1.45),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Entendido'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(tokens.radiusXl),
            gradient: LinearGradient(
              colors: [
                scheme.primary.withValues(alpha: 0.92),
                scheme.primary.withValues(alpha: 0.75),
              ],
            ),
            border: Border.all(color: scheme.onPrimary.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: scheme.onPrimary, size: 26),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    app.companionShortTip,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onPrimary,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                  ),
                ),
                Icon(Icons.touch_app_outlined, color: scheme.onPrimary.withValues(alpha: 0.85), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
