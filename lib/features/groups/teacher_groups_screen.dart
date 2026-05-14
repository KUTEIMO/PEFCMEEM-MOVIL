import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/services/firebase_bootstrap.dart';
import '../../core/services/group_repository.dart';

class TeacherGroupsScreen extends StatefulWidget {
  const TeacherGroupsScreen({super.key});

  @override
  State<TeacherGroupsScreen> createState() => _TeacherGroupsScreenState();
}

class _TeacherGroupsScreenState extends State<TeacherGroupsScreen> {
  final _repo = GroupRepository();
  List<GroupInfo> _groups = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (!FirebaseBootstrap.isReady) {
        throw StateError('Inicia sesión y revisa docs/FIREBASE_SETUP.md.');
      }
      final list = await _repo.groupsWhereTeacher();
      setState(() => _groups = list);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _create() async {
    final app = context.app;
    final schoolDefault = app.remoteSchoolName?.trim() ?? '';
    final nameController = TextEditingController(text: 'Mi grupo');
    final schoolController = TextEditingController(
      text: schoolDefault.isNotEmpty ? schoolDefault : '',
    );
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo grupo'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre del grupo'),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: schoolController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Colegio o institución',
                  hintText: 'Se guarda en el grupo',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Crear')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final school = schoolController.text.trim();
    if (school.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El colegio debe tener al menos 2 caracteres')),
      );
      return;
    }
    try {
      final info = await _repo.createGroup(
        name: nameController.text,
        schoolName: school,
      );
      if (!mounted) return;
      await _load();
      if (!mounted) return;
      context.push('/teacher/group/${info.id}', extra: info);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis grupos'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: FirebaseBootstrap.isReady ? _create : null,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo grupo'),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    children: [
                      Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                      const SizedBox(height: 16),
                      FilledButton(onPressed: _load, child: const Text('Reintentar')),
                    ],
                  )
                : _groups.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(24),
                        children: [
                          Text(
                            'Aún no tienes grupos. Pulsa + para generar un código (con el nombre del colegio) y compartirlo.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                        itemCount: _groups.length,
                        itemBuilder: (context, i) {
                          final g = _groups[i];
                          return Card(
                            child: ListTile(
                              title: Text(g.name),
                              subtitle: Text(
                                g.schoolName.isNotEmpty
                                    ? 'Código: ${g.code} · ${g.schoolName}'
                                    : 'Código: ${g.code}',
                              ),
                              trailing: const Icon(Icons.chevron_right_rounded),
                              onTap: () => context.push('/teacher/group/${g.id}', extra: g),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
