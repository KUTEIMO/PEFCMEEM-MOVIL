import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/branding_strings.dart';

/// Cómo combinar logo SVG (incluye eslogan) con textos largos.
enum EulerBrandLayout {
  /// Solo bloque de marca + línea corta (splash).
  splash,

  /// Logo + nombre largo + audiencia + funciones (about u otras).
  full,
}

/// Marca plana (SVG sin degradados) + textos oficiales.
class EulerMarkAndTitles extends StatelessWidget {
  const EulerMarkAndTitles({
    super.key,
    this.compact = false,
    this.textAlign = TextAlign.center,
    this.layout = EulerBrandLayout.full,
  });

  final bool compact;
  final TextAlign textAlign;
  final EulerBrandLayout layout;

  static const _whiteSoft = Color(0xE6FFFFFF);
  static const _whiteMuted = Color(0xB3FFFFFF);

  @override
  Widget build(BuildContext context) {
    final markH = compact ? 52.0 : 64.0;
    final titleSize = compact ? 14.0 : 16.0;
    final audienceSize = compact ? 13.0 : 14.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SvgPicture.asset(
            BrandingStrings.assetMarkSvg,
            height: markH,
            fit: BoxFit.contain,
            excludeFromSemantics: true,
            placeholderBuilder: (_) => SizedBox(height: markH, width: markH * 5),
          ),
        ),
        if (layout == EulerBrandLayout.full) ...[
          SizedBox(height: compact ? 14 : 18),
          Text(
            BrandingStrings.longName,
            textAlign: textAlign,
            style: TextStyle(
              color: _whiteSoft,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
              height: 1.38,
            ),
          ),
          SizedBox(height: compact ? 8 : 10),
          Text(
            BrandingStrings.audienceGrades,
            textAlign: textAlign,
            style: TextStyle(
              color: _whiteMuted,
              fontSize: audienceSize,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          SizedBox(height: compact ? 6 : 8),
        ] else
          SizedBox(height: compact ? 10 : 12),
        Text(
          BrandingStrings.taglineShort,
          textAlign: textAlign,
          style: TextStyle(
            color: _whiteMuted.withValues(alpha: 0.88),
            fontSize: compact ? 12 : 13,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
