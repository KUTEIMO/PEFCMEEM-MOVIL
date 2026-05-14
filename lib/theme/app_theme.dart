import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_tokens.dart';

/// Paleta inspirada en apps tipo “card + cabecera fuerte”, pero en **teal + coral**
/// (no copia el azul marino / azul eléctrico del referente).
abstract final class AppColors {
  static const Color primary = Color(0xFF0F4C5C);
  static const Color primaryLight = Color(0xFF1F7A8C);
  static const Color success = Color(0xFF2A9D8F);
  static const Color reward = Color(0xFFE07A5F);
  static const Color lightSurface = Color(0xFFF0F4F5);
  static const Color lightSurfaceCard = Color(0xFFFFFFFF);
  static const Color darkScaffold = Color(0xFF0A1618);
  static const Color darkSurface = Color(0xFF132428);
}

ThemeData buildLightTheme() {
  const tokens = AppTokens.light;
  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFC5E8EE),
    onPrimaryContainer: const Color(0xFF05262E),
    secondary: AppColors.success,
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFC8F0EA),
    onSecondaryContainer: const Color(0xFF003D36),
    tertiary: AppColors.reward,
    onTertiary: const Color(0xFF2A0F08),
    tertiaryContainer: const Color(0xFFFFD7CC),
    onTertiaryContainer: const Color(0xFF4A1E14),
    error: const Color(0xFFB3261E),
    onError: Colors.white,
    surface: AppColors.lightSurface,
    onSurface: const Color(0xFF132328),
    surfaceContainerHighest: const Color(0xFFDDE6E8),
    onSurfaceVariant: const Color(0xFF3D4A4E),
    outline: const Color(0xFFB0BFC3),
    outlineVariant: const Color(0xFFD9E3E6),
    shadow: Colors.black26,
    scrim: Colors.black54,
    inverseSurface: const Color(0xFF1C2A2E),
    onInverseSurface: const Color(0xFFE8F2F4),
    inversePrimary: AppColors.primaryLight,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,
    extensions: const [tokens],
    visualDensity: VisualDensity.standard,
  );

  final textTheme = GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
    displaySmall: GoogleFonts.soraTextTheme(base.textTheme).displaySmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
    headlineMedium: GoogleFonts.soraTextTheme(base.textTheme).headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
    headlineSmall: GoogleFonts.soraTextTheme(base.textTheme).headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
    titleLarge: GoogleFonts.soraTextTheme(base.textTheme).titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
    titleMedium: GoogleFonts.dmSansTextTheme(base.textTheme).titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.lightSurface,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: tokens.courseCardElevation,
      color: AppColors.lightSurfaceCard,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(tokens.radiusLg)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: const StadiumBorder(),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: const StadiumBorder(),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(tokens.radiusMd)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      constraints: const BoxConstraints(minHeight: 48),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 68,
      labelTextStyle: WidgetStatePropertyAll(
        GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),
  );
}

ThemeData buildDarkTheme() {
  const tokens = AppTokens.dark;
  final colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryLight,
    onPrimary: const Color(0xFF051014),
    primaryContainer: const Color(0xFF1A5F6E),
    onPrimaryContainer: const Color(0xFFD4F4FA),
    secondary: const Color(0xFF5EEAD4),
    onSecondary: const Color(0xFF00221C),
    secondaryContainer: const Color(0xFF005347),
    onSecondaryContainer: const Color(0xFFB8FFF3),
    tertiary: const Color(0xFFFFB59A),
    onTertiary: const Color(0xFF3D1308),
    tertiaryContainer: const Color(0xFF6B3020),
    onTertiaryContainer: const Color(0xFFFFDAD0),
    error: const Color(0xFFFFB4AB),
    onError: const Color(0xFF690005),
    surface: AppColors.darkSurface,
    onSurface: const Color(0xFFE2EDEF),
    surfaceContainerHighest: const Color(0xFF243A40),
    onSurfaceVariant: const Color(0xFFB8C9CD),
    outline: const Color(0xFF8FA5AA),
    outlineVariant: const Color(0xFF3A4F55),
    shadow: Colors.black54,
    scrim: Colors.black87,
    inverseSurface: const Color(0xFFE2EDEF),
    onInverseSurface: const Color(0xFF132328),
    inversePrimary: AppColors.primary,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    extensions: const [tokens],
    visualDensity: VisualDensity.standard,
  );

  final textTheme = GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
    displaySmall: GoogleFonts.soraTextTheme(base.textTheme).displaySmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
    headlineMedium: GoogleFonts.soraTextTheme(base.textTheme).headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
    headlineSmall: GoogleFonts.soraTextTheme(base.textTheme).headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
    titleLarge: GoogleFonts.soraTextTheme(base.textTheme).titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
    titleMedium: GoogleFonts.dmSansTextTheme(base.textTheme).titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.darkScaffold,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: AppColors.darkScaffold.withValues(alpha: 0.92),
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: tokens.courseCardElevation,
      color: AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(tokens.radiusLg)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: const StadiumBorder(),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: const StadiumBorder(),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(tokens.radiusMd)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      constraints: const BoxConstraints(minHeight: 48),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 68,
      labelTextStyle: WidgetStatePropertyAll(
        GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),
  );
}
