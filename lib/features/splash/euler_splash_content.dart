import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/branding_strings.dart';
import '../../theme/app_theme.dart';
import 'euler_splash_background.dart';

/// Contenido de marca compartido (móvil y web) durante el arranque.
class EulerSplashContent extends StatefulWidget {
  const EulerSplashContent({
    super.key,
    this.statusText = 'Cargando…',
    this.showMission = true,
  });

  final String statusText;
  final bool showMission;

  @override
  State<EulerSplashContent> createState() => _EulerSplashContentState();
}

class _EulerSplashContentState extends State<EulerSplashContent>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _pulse;

  static const _chips = ['Rutas', 'Grupos', 'Ranking'];

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EulerSplashBackground(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _entrance,
                        curve: Curves.easeOut,
                      ),
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.9, end: 1).animate(
                          CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic),
                        ),
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.98, end: 1.02).animate(
                            CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                          ),
                          child: SvgPicture.asset(
                          BrandingStrings.assetSplashSvg,
                          height: 200,
                          fit: BoxFit.contain,
                          excludeFromSemantics: true,
                        ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final label in _chips)
                          _FeatureChip(label: label),
                      ],
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.6,
                        color: AppColors.reward,
                        backgroundColor: const Color(0x28FFFFFF),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      widget.statusText,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (widget.showMission) ...[
                      const SizedBox(height: 10),
                      Text(
                        BrandingStrings.missionShort,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.52),
                          fontSize: 12.5,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.82),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}
