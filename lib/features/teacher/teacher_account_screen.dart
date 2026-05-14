import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/firebase_bootstrap.dart';

/// Cuenta docente: correo, colegio (desde perfil remoto) y cierre de sesión.
class TeacherAccountScreen extends StatelessWidget {
  const TeacherAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final u = FirebaseAuth.instance.currentUser;
    final school = app.remoteSchoolName;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta'),
        actions: [
          IconButton(
            tooltip: 'Ajustes',
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Correo'),
            subtitle: Text(u?.email ?? '—'),
          ),
          ListTile(
            leading: const Icon(Icons.apartment_outlined),
            title: const Text('Colegio / institución'),
            subtitle: Text(
              (school != null && school.isNotEmpty) ? school : 'Edita en registro o contacta soporte',
            ),
          ),
          ListTile(
            leading: Icon(
              FirebaseBootstrap.isReady ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
            ),
            title: const Text('Firebase'),
            subtitle: Text(
              FirebaseBootstrap.isReady
                  ? (FirebaseBootstrap.metaSeedError != null
                      ? 'Aviso: ${FirebaseBootstrap.metaSeedError}'
                      : 'Conectado')
                  : (FirebaseBootstrap.lastError ?? 'Sin inicializar'),
            ),
          ),
          const Divider(height: 32),
          FilledButton.tonalIcon(
            onPressed: () async {
              await app.signOut();
              if (context.mounted) context.go(AppRoutes.auth);
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Cerrar sesión'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.go(AppRoutes.tGroups),
            child: const Text('Volver a mis grupos'),
          ),
        ],
      ),
    );
  }
}
