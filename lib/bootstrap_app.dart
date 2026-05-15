import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'app_state.dart';
import 'core/services/firebase_bootstrap.dart';
import 'features/splash/app_splash_screen.dart';
import 'router/app_router.dart';
import 'theme/bootstrap_theme.dart';

/// Arranque: en **móvil** splash con marca; en **web** solo un indicador mínimo (el color de marca va en `web/index.html`).
class PefcmeemBootstrap extends StatefulWidget {
  const PefcmeemBootstrap({super.key});

  @override
  State<PefcmeemBootstrap> createState() => _PefcmeemBootstrapState();
}

class _PefcmeemBootstrapState extends State<PefcmeemBootstrap> {
  AppState? _app;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    setState(() {
      _error = null;
    });
    try {
      await FirebaseBootstrap.initCore();
      GoogleFonts.dmSans();
      GoogleFonts.sora();
      if (kIsWeb) {
        // Sin espera: el canvas y el router deben levantar ya.
      } else {
        try {
          await GoogleFonts.pendingFonts().timeout(const Duration(seconds: 4));
        } on TimeoutException {
          // Sigue con fuentes del sistema.
        }
      }
      final app = AppState();
      await app.init();
      app.attachRouter(createAppRouter(app));
      if (!mounted) return;
      setState(() => _app = app);
    } catch (e, st) {
      assert(() {
        // ignore: avoid_print
        print('PefcmeemBootstrap: $e\n$st');
        return true;
      }());
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_app != null) {
      return PefcmeemApp(appState: _app!);
    }
    if (_error != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildBootstrapTheme(),
        home: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF051A22), Color(0xFF0B3340), Color(0xFF1F7A8C)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_outlined, color: Colors.white70, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'No se pudo iniciar la app',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _error.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 28),
                    FilledButton.icon(
                      onPressed: _run,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildBootstrapTheme(),
      home: kIsWeb
          ? const ColoredBox(color: Color(0xFF0A2B35))
          : const AppSplashScreen(),
    );
  }
}
