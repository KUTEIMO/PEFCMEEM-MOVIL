import 'package:flutter/material.dart';

import '../../core/branding_strings.dart';
import '../../theme/app_theme.dart';
import '../../widgets/pefcmeem_mark_and_titles.dart';

/// Splash: gradiente en el contenedor (no en el SVG), logo plano y carga sin animaciones extra.
class AppSplashScreen extends StatelessWidget {
  const AppSplashScreen({super.key});

  static const _gradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 0.45, 1.0],
      colors: [
        Color(0xFF051A22),
        Color(0xFF0B3340),
        Color(0xFF1F7A8C),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: _gradient,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight - 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const PefcmeemMarkAndTitles(compact: true, layout: PefcmeemBrandLayout.splash),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: 34,
                        height: 34,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.8,
                          color: AppColors.reward,
                          backgroundColor: const Color(0x22FFFFFF),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Cargando…',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.88),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        BrandingStrings.missionShort,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: 12.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
