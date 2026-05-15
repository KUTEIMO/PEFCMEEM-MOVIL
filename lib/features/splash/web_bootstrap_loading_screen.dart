import 'package:flutter/material.dart';

import 'euler_splash_content.dart';

/// Web: misma marca que el splash móvil (antes solo un spinner genérico).
class WebBootstrapLoadingScreen extends StatelessWidget {
  const WebBootstrapLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EulerSplashContent(
        statusText: 'Cargando…',
        showMission: false,
      ),
    );
  }
}
