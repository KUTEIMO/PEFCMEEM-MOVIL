import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _avatarColors = <Color>[
    Color(0xFF2D3A8C),
    Color(0xFF22C55E),
    Color(0xFF7C3AED),
    Color(0xFFF97316),
    Color(0xFF0EA5E9),
    Color(0xFF64748B),
  ];

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final p = app.progress;
    final idx = p.avatarColorIndex.clamp(0, _avatarColors.length - 1);
    final color = _avatarColors[idx];
    final parts = p.displayName.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    final initials = parts.isEmpty
        ? 'ES'
        : parts.take(2).map((e) => e.substring(0, 1)).join().toUpperCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
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
          Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: color.withValues(alpha: 0.2),
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.displayName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text('Grado ${p.gradeLabel}'),
                    Text('Meta: ${p.goalLabel}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Color del avatar',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(_avatarColors.length, (i) {
              final selected = i == idx;
              return InkWell(
                onTap: () => app.setAvatarColorIndex(i),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _avatarColors[i],
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: selected ? 3 : 1,
                      color: selected ? Theme.of(context).colorScheme.onSurface : Colors.transparent,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 28),
          if (app.currentGroupId != null) ...[
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline_rounded),
              title: const Text('Chat con mi grupo'),
              subtitle: const Text('Mensajes con tu docente y compañeros'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(AppRoutes.groupChat(app.currentGroupId!)),
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events_outlined),
              title: const Text('Grupo activo'),
              subtitle: Text('Código: ${app.currentGroupCode ?? "—"}'),
              trailing: TextButton(
                onPressed: () async {
                  await app.clearCurrentGroup();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saliste del grupo en este dispositivo')),
                    );
                  }
                },
                child: const Text('Salir'),
              ),
            ),
          ] else
            ListTile(
              leading: const Icon(Icons.qr_code_2_outlined),
              title: const Text('Unirse a un grupo'),
              subtitle: const Text('Ranking en vivo con tu clase'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/join-group'),
            ),
        ],
      ),
    );
  }
}
