import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
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
            leading: const Icon(Icons.supervisor_account_outlined),
            title: const Text('Vista docente'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => context.push('/teacher'),
          ),
          const Divider(height: 1),
          const ListTile(
            leading: Icon(Icons.shield_outlined),
            title: Text('Privacidad'),
            subtitle: Text(
              'Este MVP guarda progreso solo en el dispositivo (SharedPreferences). No hay cuenta en la nube.',
            ),
          ),
        ],
      ),
    );
  }
}
