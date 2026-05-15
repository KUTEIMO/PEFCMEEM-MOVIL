import 'package:flutter/material.dart';

import 'euler_splash_content.dart';

/// Splash de arranque (móvil): marca EULER, fondo matemático y carga.
class AppSplashScreen extends StatelessWidget {
  const AppSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EulerSplashContent(
        statusText: 'Preparando EULER…',
      ),
    );
  }
}
