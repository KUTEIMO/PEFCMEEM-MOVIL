import 'package:flutter/material.dart';

/// Pantalla mínima solo para web: el “splash” de marca queda en [web/index.html];
/// aquí solo un indicador ligero hasta que el router esté listo.
class WebBootstrapLoadingScreen extends StatelessWidget {
  const WebBootstrapLoadingScreen({super.key});

  static const _bg = Color(0xFF0B3340);

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: _bg,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFFE07A5F),
                backgroundColor: Color(0x22FFFFFF),
              ),
            ),
            SizedBox(height: 14),
            Text(
              'Cargando…',
              style: TextStyle(
                color: Color(0xE0FFFFFF),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
