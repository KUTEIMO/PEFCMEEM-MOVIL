import 'package:flutter/material.dart';

import 'app_theme.dart';

/// Tema ligero sin Google Fonts (arranque / splash): menos trabajo en el primer frame.
ThemeData buildBootstrapTheme() {
  const seed = AppColors.primaryLight;
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
      primary: AppColors.reward,
      surface: const Color(0xFF0B3340),
    ),
    scaffoldBackgroundColor: Colors.transparent,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.reward,
      circularTrackColor: Color(0x33FFFFFF),
    ),
  );
}
