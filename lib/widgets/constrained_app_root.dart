import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Límites de maquetación para navegador de escritorio y ventanas anchas.
abstract final class AppLayout {
  AppLayout._();

  /// Ancho máximo del bloque de contenido (similar a muchas webs educativas).
  static const double maxContentWidth = 1040;

  static const double _wideOuterPad = 28;
  static const double _comfortOuterPad = 18;
  static const double _compactOuterPad = 12;
}

/// Centra la app y acota el ancho para que formas, cards y barras no se estiren
/// en monitores anchos (Flutter Web).
class ConstrainedAppRoot extends StatelessWidget {
  const ConstrainedAppRoot({required this.child, super.key});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final c = child;
    if (c == null) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        if (!w.isFinite || w <= 0) {
          return c;
        }

        if (kIsWeb) {
          final theme = Theme.of(context);
          final outer = theme.scaffoldBackgroundColor;
          const maxInner = 1280.0;
          final inner = w > maxInner ? maxInner : w;
          return ColoredBox(
            color: outer,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: inner),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: RepaintBoundary(child: c),
                ),
              ),
            ),
          );
        }

        final theme = Theme.of(context);
        final outer = theme.scaffoldBackgroundColor;

        final double horizontalPad;
        if (w >= AppLayout.maxContentWidth + 96) {
          horizontalPad = AppLayout._wideOuterPad;
        } else if (w >= 720) {
          horizontalPad = AppLayout._comfortOuterPad;
        } else {
          horizontalPad = AppLayout._compactOuterPad;
        }

        final maxInner = w > AppLayout.maxContentWidth ? AppLayout.maxContentWidth : w;

        return ColoredBox(
          color: outer,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxInner),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPad),
                child: RepaintBoundary(child: c),
              ),
            ),
          ),
        );
      },
    );
  }
}
