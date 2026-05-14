import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_tokens.dart';

/// Brand palette: deep indigo primary, calm neutrals (less generic than seed-only blue).
abstract final class AppColors {
  static const Color primary = Color(0xFF2D3A8C);
  static const Color primaryLight = Color(0xFF4A5FCF);
  static const Color success = Color(0xFF0D9F6E);
  static const Color reward = Color(0xFFE8A317);
  static const Color lightSurface = Color(0xFFF3F5FA);
  static const Color lightSurfaceCard = Color(0xFFFFFFFF);
  static const Color darkScaffold = Color(0xFF0C1224);
  static const Color darkSurface = Color(0xFF151C2E);
}

ThemeData buildLightTheme() {
  const tokens = AppTokens.light;
  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFDDE2FF),
    onPrimaryContainer: const Color(0xFF12183A),
    secondary: AppColors.success,
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFC8F5E3),
    onSecondaryContainer: const Color(0xFF003828),
    tertiary: AppColors.reward,
    onTertiary: const Color(0xFF1A1200),
    tertiaryContainer: const Color(0xFFFFE7B8),
    onTertiaryContainer: const Color(0xFF3D2E00),
    error: const Color(0xFFB3261E),
    onError: Colors.white,
    surface: AppColors.lightSurface,
    onSurface: const Color(0xFF1B2233),
    surfaceContainerHighest: const Color(0xFFE2E6EF),
    onSurfaceVariant: const Color(0xFF454B5C),
    outline: const Color(0xFFC5CAD8),
    outlineVariant: const Color(0xFFE0E4EE),
    shadow: Colors.black26,
    scrim: Colors.black54,
    inverseSurface: const Color(0xFF2A3142),
    onInverseSurface: const Color(0xFFF0F2F8),
    inversePrimary: AppColors.primaryLight,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,
    extensions: const [tokens],
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
      backgroundColor: AppColors.lightSurface.withValues(alpha: 0.92),
      foregroundColor: colorScheme.onSurface,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(tokens.radiusMd)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(tokens.radiusMd)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(tokens.radiusMd)),
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
    onPrimary: const Color(0xFF0A1028),
    primaryContainer: const Color(0xFF3D4FA3),
    onPrimaryContainer: const Color(0xFFE8EBFF),
    secondary: const Color(0xFF3DDBA8),
    onSecondary: const Color(0xFF002116),
    secondaryContainer: const Color(0xFF00513A),
    onSecondaryContainer: const Color(0xFFB8F5DE),
    tertiary: const Color(0xFFFFD478),
    onTertiary: const Color(0xFF221800),
    tertiaryContainer: const Color(0xFF5C4300),
    onTertiaryContainer: const Color(0xFFFFEEC7),
    error: const Color(0xFFFFB4AB),
    onError: const Color(0xFF690005),
    surface: AppColors.darkSurface,
    onSurface: const Color(0xFFE6E9F2),
    surfaceContainerHighest: const Color(0xFF2A3348),
    onSurfaceVariant: const Color(0xFFC2C8D8),
    outline: const Color(0xFF8E95A8),
    outlineVariant: const Color(0xFF3E4659),
    shadow: Colors.black54,
    scrim: Colors.black87,
    inverseSurface: const Color(0xFFE6E9F2),
    onInverseSurface: const Color(0xFF1B2233),
    inversePrimary: AppColors.primary,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    extensions: const [tokens],
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(tokens.radiusMd)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(tokens.radiusMd)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(tokens.radiusMd)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 68,
      labelTextStyle: WidgetStatePropertyAll(
        GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),
  );
}
