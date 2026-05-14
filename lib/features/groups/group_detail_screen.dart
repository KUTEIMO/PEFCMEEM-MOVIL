import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/routes/app_routes.dart';
import '../../core/services/group_repository.dart';

class GroupDetailScreen extends StatelessWidget {
  const GroupDetailScreen({
    required this.groupId,
    this.initial,
    super.key,
  });

  final String groupId;
  final GroupInfo? initial;

  @override
  Widget build(BuildContext context) {
    final info = initial;
    if (info == null || info.id != groupId) {
      return Scaffold(
        appBar: AppBar(title: const Text('Grupo')),
        body: const Center(child: Text('Abre el grupo desde la lista de grupos.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(info.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Colegio',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Text(
            info.schoolName.isNotEmpty ? info.schoolName : '—',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          Text(
            'Comparte este código con tus estudiantes',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          SelectableText(
            info.code,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  letterSpacing: 4,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 16),
          Center(
            child: QrImageView(
              data: info.code,
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: info.code));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Código copiado')),
                );
              }
            },
            icon: const Icon(Icons.copy_rounded),
            label: const Text('Copiar código'),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => context.push(AppRoutes.groupChat(info.id)),
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: const Text('Abrir chat del grupo'),
          ),
          const SizedBox(height: 32),
          Text('ID interno', style: Theme.of(context).textTheme.labelSmall),
          SelectableText(info.id, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
