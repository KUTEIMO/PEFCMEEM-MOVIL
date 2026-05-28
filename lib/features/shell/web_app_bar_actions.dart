import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_routes.dart';

/// Acciones de cabecera web: Sobre (izq. del engranaje) + Ajustes.
class WebAppBarActions extends StatelessWidget {
  const WebAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Sobre EULER',
          icon: const Icon(Icons.info_outline_rounded),
          onPressed: () => context.push(AppRoutes.about),
        ),
        IconButton(
          tooltip: 'Ajustes',
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.push('/settings'),
        ),
      ],
    );
  }
}

/// Pie del menú lateral web con acceso a Sobre y Ajustes.
class WebDrawerFooter extends StatelessWidget {
  const WebDrawerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.info_outline_rounded),
          title: const Text('Sobre EULER'),
          onTap: () {
            Navigator.of(context).pop();
            context.push(AppRoutes.about);
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Ajustes'),
          onTap: () {
            Navigator.of(context).pop();
            context.push('/settings');
          },
        ),
      ],
    );
  }
}
