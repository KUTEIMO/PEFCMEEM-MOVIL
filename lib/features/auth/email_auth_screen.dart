import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/branding_strings.dart';
import '../../core/models/user_role.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/auth_messages.dart';

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key, this.initialTabRegister = false});

  final bool initialTabRegister;

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _name = TextEditingController();
  final _school = TextEditingController();

  UserRole _regRole = UserRole.student;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabRegister ? 1 : 0,
    );
  }

  @override
  void dispose() {
    _tab.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _name.dispose();
    _school.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    setState(() => _busy = true);
    try {
      await context.app.signInWithEmail(_email.text.trim(), _password.text);
      if (!mounted) return;
      final app = context.app;
      if (app.profileSyncError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Perfil en la nube: ${app.profileSyncError}')),
        );
      }
      if (!app.onboardingDone) {
        context.go(AppRoutes.onboarding);
      } else {
        context.go(AppRoutes.homeForRole(app.userRole == UserRole.teacher));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(formatAuthError(e))));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();
    final email = _email.text.trim();
    final pass = _password.text;
    final pass2 = _confirm.text;
    final name = _name.text.trim();
    final school = _school.text.trim();

    if (email.length < 5 || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce un correo válido')),
      );
      return;
    }
    if (pass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contraseña debe tener al menos 6 caracteres')),
      );
      return;
    }
    if (pass != pass2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Indica tu nombre o apodo')),
      );
      return;
    }
    if (_regRole == UserRole.teacher && school.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe el nombre del colegio o institución (mín. 2 caracteres)')),
      );
      return;
    }

    setState(() => _busy = true);
    try {
      final app = context.app;
      await app.registerAndCreateProfile(
        email: email,
        password: pass,
        displayName: name,
        role: _regRole,
        schoolName: _regRole == UserRole.teacher ? school : null,
      );
      if (!mounted) return;
      if (_regRole == UserRole.teacher) {
        await app.finishTeacherRegistrationBootstrap(name);
        if (!mounted) return;
        context.go(AppRoutes.tGroups);
      } else {
        context.go(AppRoutes.onboarding);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(formatAuthError(e))));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: kIsWeb
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: 'Volver al inicio',
                onPressed: () => context.go(AppRoutes.landing),
              )
            : null,
        title: Row(
          children: [
            SvgPicture.asset(
              BrandingStrings.assetMarkSvg,
              height: 30,
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    BrandingStrings.acronym,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    BrandingStrings.appTagline,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onPrimary.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Entrar'),
            Tab(text: 'Registro'),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _LoginTab(
                  email: _email,
                  password: _password,
                  busy: _busy,
                  onSubmit: _login,
                  onAbout: () => context.push(AppRoutes.about),
                ),
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
              Text(
                'Crea tu cuenta',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Los docentes indican el colegio; los estudiantes podrán unirse con el código del grupo.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              SegmentedButton<UserRole>(
                segments: const [
                  ButtonSegment(value: UserRole.student, label: Text('Estudiante'), icon: Icon(Icons.school_outlined)),
                  ButtonSegment(value: UserRole.teacher, label: Text('Docente'), icon: Icon(Icons.co_present_outlined)),
                ],
                selected: {_regRole},
                onSelectionChanged: (s) => setState(() => _regRole = s.first),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nombre o apodo',
                  border: OutlineInputBorder(),
                ),
              ),
              if (_regRole == UserRole.teacher) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _school,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Colegio o institución',
                    hintText: 'Ej. I.E. Loperena',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña (mín. 6)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirm,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _busy ? null : _register,
                      child: _busy
                          ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Crear cuenta'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginTab extends StatelessWidget {
  const _LoginTab({
    required this.email,
    required this.password,
    required this.busy,
    required this.onSubmit,
    required this.onAbout,
  });

  final TextEditingController email;
  final TextEditingController password;
  final bool busy;
  final VoidCallback onSubmit;
  final VoidCallback onAbout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Accede con tu correo',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: 'Correo',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: password,
          obscureText: true,
          onSubmitted: (_) => onSubmit(),
          decoration: const InputDecoration(
            labelText: 'Contraseña',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: busy ? null : onSubmit,
          child: busy
              ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Entrar'),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: onAbout,
          icon: const Icon(Icons.info_outline_rounded),
          label: const Text('Sobre el proyecto'),
        ),
      ],
    );
  }
}
