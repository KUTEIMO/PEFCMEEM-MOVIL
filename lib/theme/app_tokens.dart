import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Design tokens (Brilliant/Khan-inspired: calm surfaces, clear rhythm).
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusXl,
    required this.motionFast,
    required this.motionMedium,
    required this.motionSlow,
    required this.courseCardElevation,
    required this.challengeCardBorderWidth,
    required this.heroGradientStart,
    required this.heroGradientEnd,
  });

  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final double radiusXl;
  final Duration motionFast;
  final Duration motionMedium;
  final Duration motionSlow;
  final double courseCardElevation;
  final double challengeCardBorderWidth;
  final Color heroGradientStart;
  final Color heroGradientEnd;

  static const AppTokens light = AppTokens(
    radiusSm: 10,
    radiusMd: 14,
    radiusLg: 20,
    radiusXl: 28,
    motionFast: Duration(milliseconds: 180),
    motionMedium: Duration(milliseconds: 280),
    motionSlow: Duration(milliseconds: 420),
    courseCardElevation: 0.5,
    challengeCardBorderWidth: 1,
    heroGradientStart: Color(0xFFE8EDFF),
    heroGradientEnd: Color(0xFFF4F6FB),
  );

  static const AppTokens dark = AppTokens(
    radiusSm: 10,
    radiusMd: 14,
    radiusLg: 20,
    radiusXl: 28,
    motionFast: Duration(milliseconds: 180),
    motionMedium: Duration(milliseconds: 280),
    motionSlow: Duration(milliseconds: 420),
    courseCardElevation: 0,
    challengeCardBorderWidth: 1,
    heroGradientStart: Color(0xFF1A2344),
    heroGradientEnd: Color(0xFF0F172A),
  );

  @override
  AppTokens copyWith({
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? radiusXl,
    Duration? motionFast,
    Duration? motionMedium,
    Duration? motionSlow,
    double? courseCardElevation,
    double? challengeCardBorderWidth,
    Color? heroGradientStart,
    Color? heroGradientEnd,
  }) {
    return AppTokens(
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      radiusXl: radiusXl ?? this.radiusXl,
      motionFast: motionFast ?? this.motionFast,
      motionMedium: motionMedium ?? this.motionMedium,
      motionSlow: motionSlow ?? this.motionSlow,
      courseCardElevation: courseCardElevation ?? this.courseCardElevation,
      challengeCardBorderWidth: challengeCardBorderWidth ?? this.challengeCardBorderWidth,
      heroGradientStart: heroGradientStart ?? this.heroGradientStart,
      heroGradientEnd: heroGradientEnd ?? this.heroGradientEnd,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      radiusSm: ui.lerpDouble(radiusSm, other.radiusSm, t)!,
      radiusMd: ui.lerpDouble(radiusMd, other.radiusMd, t)!,
      radiusLg: ui.lerpDouble(radiusLg, other.radiusLg, t)!,
      radiusXl: ui.lerpDouble(radiusXl, other.radiusXl, t)!,
      motionFast: t < 0.5 ? motionFast : other.motionFast,
      motionMedium: t < 0.5 ? motionMedium : other.motionMedium,
      motionSlow: t < 0.5 ? motionSlow : other.motionSlow,
      courseCardElevation: ui.lerpDouble(courseCardElevation, other.courseCardElevation, t)!,
      challengeCardBorderWidth:
          ui.lerpDouble(challengeCardBorderWidth, other.challengeCardBorderWidth, t)!,
      heroGradientStart: Color.lerp(heroGradientStart, other.heroGradientStart, t)!,
      heroGradientEnd: Color.lerp(heroGradientEnd, other.heroGradientEnd, t)!,
    );
  }
}

extension AppTokensContext on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>() ?? AppTokens.light;
}
