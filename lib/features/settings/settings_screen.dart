import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/models/user_role.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/firebase_bootstrap.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final authUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Apariencia'),
            subtitle: Text('Modo oscuro recomendado para estudio nocturno'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text('Auto'),
                    icon: Icon(Icons.brightness_auto_outlined),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text('Claro'),
                    icon: Icon(Icons.light_mode_outlined),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text('Oscuro'),
                    icon: Icon(Icons.dark_mode_outlined),
                  ),
                ],
                selected: {app.themeMode},
                onSelectionChanged: (next) {
                  if (next.isNotEmpty) app.setThemeMode(next.first);
                },
              ),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              FirebaseBootstrap.firebaseAppReady ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
            ),
            title: const Text('Firebase'),
            subtitle: Text(
              !FirebaseBootstrap.firebaseAppReady
                  ? 'Sin conectar: ${FirebaseBootstrap.lastError ?? "revisa firebase_options / google-services"}'
                  : authUser == null
                      ? 'Inicia sesión para sincronizar perfil y grupos.'
                      : FirebaseBootstrap.metaSeedError != null
                          ? 'Conectado. Aviso meta: ${FirebaseBootstrap.metaSeedError}'
                          : 'Conectado (${authUser.email ?? "usuario"}).',
            ),
          ),
          if (app.profileSyncError != null)
            ListTile(
              leading: Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error),
              title: const Text('Perfil en la nube'),
              subtitle: Text(app.profileSyncError!),
            ),
          if (app.catalogLoadError != null)
            ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: const Text('Catálogo local'),
              subtitle: Text('Fallo al cargar cursos: ${app.catalogLoadError}'),
            ),
          ListTile(
            leading: const Icon(Icons.refresh_rounded),
            title: const Text('Actualizar catálogo remoto'),
            subtitle: const Text('Si publicaste ejercicios en Firestore (`published/courses`)'),
            onTap: () async {
              await app.refreshCatalog();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      app.catalogLoadError ?? 'Catálogo: ${app.catalog?.courses.length ?? 0} cursos',
                    ),
                  ),
                );
              }
            },
          ),
          if (app.userRole == UserRole.student) ...[
            ListTile(
              leading: const Icon(Icons.qr_code_2_outlined),
              title: const Text('Unirse a grupo'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/join-group'),
            ),
          ],
          if (app.currentGroupId != null)
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Salir del grupo local'),
              subtitle: Text('Código: ${app.currentGroupCode ?? "—"}'),
              onTap: () async {
                await app.clearCurrentGroup();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Grupo desvinculado en este dispositivo')),
                  );
                }
              },
            ),
          if (authUser != null) ...[
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Cerrar sesión'),
              subtitle: const Text('Vuelve a la pantalla de acceso'),
              onTap: () async {
                await app.signOut();
                if (context.mounted) context.go(AppRoutes.auth);
              },
            ),
          ],
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('Sobre EULER'),
            subtitle: const Text(
              'Domina las matemáticas. · Documento del proyecto, créditos y marca',
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              if (!context.mounted) return;
              context.push(AppRoutes.about);
            },
          ),
          const Divider(height: 1),
          const ListTile(
            leading: Icon(Icons.shield_outlined),
            title: Text('Privacidad'),
            subtitle: Text(
              'El progreso de lecciones se guarda en el dispositivo. Con cuenta, el perfil y grupos van a Cloud Firestore según las reglas del proyecto.',
            ),
          ),
        ],
      ),
    );
  }
}
