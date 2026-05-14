import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/firebase_bootstrap.dart';
import '../../core/services/group_repository.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({super.key});

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final _codeController = TextEditingController();
  final _repo = GroupRepository();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _busy = true;
    });
    try {
      if (!FirebaseBootstrap.isReady) {
        throw StateError(
          'Firebase no está configurado. Sigue docs/FIREBASE_SETUP.md',
        );
      }
      final app = context.app;
      final info = await _repo.joinGroupByCode(
        _codeController.text,
        memberDisplayName: app.progress.displayName,
      );
      await app.setCurrentGroup(info.id, info.code);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Te uniste a ${info.name}')),
        );
        context.go(AppRoutes.sHome);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unirse a un grupo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Pide el código a tu profe (6 caracteres). Funciona en web y móvil.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _codeController,
            textCapitalization: TextCapitalization.characters,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Código del grupo',
              hintText: 'Ej. ABC2XY',
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _busy ? null : _submit,
            child: _busy
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Unirse'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _busy
                ? null
                : () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.sHome);
                    }
                  },
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}
