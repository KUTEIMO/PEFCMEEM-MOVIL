import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/branding_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../features/splash/euler_splash_background.dart';
import '../../theme/app_theme.dart';
import '../../widgets/apk_download_card.dart';

/// Página de inicio web (landing): presentación, APK y acceso a login/registro.
class WebLandingScreen extends StatelessWidget {
  const WebLandingScreen({super.key});

  static const _features = <_LandingFeature>[
    _LandingFeature(Icons.route_rounded, 'Rutas cortas', 'Micro-lecciones de 5–10 min con un objetivo claro.'),
    _LandingFeature(Icons.groups_2_outlined, 'Grupos', 'Código y QR para que tu clase entre desde web o móvil.'),
    _LandingFeature(Icons.leaderboard_outlined, 'Ranking', 'Progreso visible para motivar en clase.'),
    _LandingFeature(Icons.psychology_alt_outlined, 'Pibo', 'Compañero que guía con tips breves en cada pantalla.'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final w = MediaQuery.sizeOf(context).width;
    final wide = w >= 720;

    return Scaffold(
      body: EulerSplashBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: const Color(0xE60A2B35),
              surfaceTintColor: Colors.transparent,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    BrandingStrings.assetMarkSvg,
                    height: 28,
                    excludeFromSemantics: true,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => context.push(AppRoutes.about),
                  child: const Text('Sobre el proyecto'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => context.go(AppRoutes.auth),
                  child: const Text('Acceder'),
                ),
                const SizedBox(width: 12),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: wide ? 48 : 20,
                  vertical: 24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (wide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _HeroText(scheme: scheme)),
                              const SizedBox(width: 32),
                              Expanded(
                                child: SvgPicture.asset(
                                  BrandingStrings.assetSplashSvg,
                                  height: 240,
                                  fit: BoxFit.contain,
                                  excludeFromSemantics: true,
                                ),
                              ),
                            ],
                          )
                        else ...[
                          Center(
                            child: SvgPicture.asset(
                              BrandingStrings.assetSplashSvg,
                              height: 180,
                              fit: BoxFit.contain,
                              excludeFromSemantics: true,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _HeroText(scheme: scheme),
                        ],
                        const SizedBox(height: 28),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            FilledButton.icon(
                              onPressed: () => context.go(AppRoutes.auth),
                              icon: const Icon(Icons.login_rounded),
                              label: const Text('Iniciar sesión'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.reward,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => context.go('${AppRoutes.auth}?tab=register'),
                              icon: const Icon(Icons.person_add_outlined),
                              label: const Text('Crear cuenta'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const ApkDownloadCard(),
                        const SizedBox(height: 36),
                        Text(
                          '¿Por qué EULER?',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, c) {
                            final cols = c.maxWidth >= 640 ? 2 : 1;
                            return GridView.count(
                              crossAxisCount: cols,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: cols == 2 ? 2.4 : 2.8,
                              children: [
                                for (final f in _features) _FeatureTile(feature: f),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 28),
                        Text(
                          BrandingStrings.audienceGrades,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.65),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
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

class _HeroText extends StatelessWidget {
  const _HeroText({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          BrandingStrings.acronym,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppColors.reward,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          BrandingStrings.appTagline,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          BrandingStrings.longName,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.82),
                height: 1.4,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          BrandingStrings.missionShort,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.58),
                height: 1.4,
              ),
        ),
      ],
    );
  }
}

class _LandingFeature {
  const _LandingFeature(this.icon, this.title, this.body);

  final IconData icon;
  final String title;
  final String body;
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.feature});

  final _LandingFeature feature;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.success.withValues(alpha: 0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(feature.icon, color: AppColors.reward, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature.body,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 12.5,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
