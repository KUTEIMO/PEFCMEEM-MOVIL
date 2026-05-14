import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/branding_strings.dart';
import '../../core/models/user_role.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/learning_companion.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;
  UserRole? _role;
  final _nameController = TextEditingController();
  String _grade = '10';
  String _goal = 'Saber 11';

  int get _pageCount {
    if (_role == null) return 1;
    if (_role == UserRole.teacher) return 3;
    return 5;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _finishStudent({required bool openJoin}) async {
    await context.app.completeOnboarding(
      role: UserRole.student,
      displayName: _nameController.text,
      gradeLabel: _grade,
      goalLabel: _goal,
    );
    if (!mounted) return;
    if (openJoin) {
      context.go('/join-group');
    } else {
      context.go(AppRoutes.sHome);
    }
  }

  Future<void> _finishTeacher() async {
    final name = _nameController.text.trim().isEmpty ? 'Docente' : _nameController.text.trim();
    await context.app.completeOnboarding(
      role: UserRole.teacher,
      displayName: name,
      gradeLabel: '—',
      goalLabel: 'Seguimiento de grupo',
    );
    if (mounted) context.go(AppRoutes.tGroups);
  }

  void _next() {
    if (_page >= _pageCount - 1) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  List<Widget> _pages(ColorScheme scheme) {
    return [
      _rolePage(scheme),
      if (_role == UserRole.student) ...[
        _OnbPage(
          title: 'Rutas cortas + práctica guiada',
          body:
              'Micro-lecciones de 5–10 minutos con un objetivo claro por pantalla. Inspirado en la dinámica de Brilliant: problema, feedback y explicación breve.',
          icon: Icons.route_rounded,
          color: scheme.primary,
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Conoce a Pibo',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              const LearningCompanion(mood: CompanionMood.idle),
            ],
          ),
        ),
        _profileForm(context),
        _joinIntro(context),
      ],
      if (_role == UserRole.teacher) ...[
        _OnbPage(
          title: 'Crea grupos con código',
          body:
              'Generas un código y QR, lo compartes por WhatsApp o proyector, y tus estudiantes entran desde web o celular. El ranking del grupo se sincroniza con Firebase.',
          icon: Icons.groups_2_outlined,
          color: scheme.primary,
        ),
        _teacherNamePage(context),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pages = _pages(scheme);
    final lastStudentJoin = _role == UserRole.student && _page == 4;
    final lastTeacher = _role == UserRole.teacher && _page == 2;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(BrandingStrings.acronym),
            Text(
              BrandingStrings.appTagline,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          if (_role == UserRole.student && _page > 0 && _page < _pageCount - 1)
            TextButton(
              onPressed: () {
                _pageController.animateToPage(
                  _pageCount - 1,
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                );
              },
              child: const Text('Saltar'),
            ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_page + 1) / _pageCount,
            minHeight: 4,
            borderRadius: BorderRadius.circular(4),
          ),
          Expanded(
            child: PageView(
              key: ValueKey(_role?.name ?? 'none'),
              controller: _pageController,
              onPageChanged: (i) => setState(() => _page = i),
              children: pages,
            ),
          ),
          if (_role == null)
            const SizedBox.shrink()
          else if (!lastStudentJoin)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    if (_page > 0)
                      OutlinedButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        child: const Text('Atrás'),
                      ),
                    const Spacer(),
                    if (lastTeacher)
                      FilledButton(
                        onPressed: _finishTeacher,
                        child: const Text('Ir a mis grupos'),
                      )
                    else
                      FilledButton(
                        onPressed: _next,
                        child: const Text('Siguiente'),
                      ),
                  ],
                ),
              ),
            )
          else
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_page > 0)
                      OutlinedButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        child: const Text('Atrás'),
                      ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FilledButton(
                            onPressed: () => _finishStudent(openJoin: true),
                            child: const Text('Sí, tengo código'),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: () => _finishStudent(openJoin: false),
                            child: const Text('Ahora no'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _rolePage(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '¿Cómo vas a usar PEFCMEEM?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Elige un rol para continuar.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 28),
          _RoleCard(
            title: 'Estudiante',
            subtitle: 'Ruta, práctica, XP y opcionalmente un grupo del profe',
            icon: Icons.school_outlined,
            selected: _role == UserRole.student,
            onTap: () {
              setState(() => _role = UserRole.student);
              _next();
            },
          ),
          const SizedBox(height: 12),
          _RoleCard(
            title: 'Profesor',
            subtitle: 'Códigos de grupo, QR y ranking en tiempo real',
            icon: Icons.co_present_outlined,
            selected: _role == UserRole.teacher,
            onTap: () {
              setState(() => _role = UserRole.teacher);
              _next();
            },
          ),
        ],
      ),
    );
  }

  Widget _profileForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          Text(
            'Personaliza tu experiencia',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Indica tu grado (9–11) y tu meta; puedes ajustarlo después en tu perfil.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nombre o apodo',
            ),
          ),
          const SizedBox(height: 8),
          Text('Grado', style: Theme.of(context).textTheme.labelLarge),
          DropdownButton<String>(
            isExpanded: true,
            value: _grade,
            items: const [
              DropdownMenuItem(value: '9', child: Text('Grado 9')),
              DropdownMenuItem(value: '10', child: Text('Grado 10')),
              DropdownMenuItem(value: '11', child: Text('Grado 11')),
            ],
            onChanged: (v) => setState(() => _grade = v ?? _grade),
          ),
          const SizedBox(height: 16),
          Text('Meta principal', style: Theme.of(context).textTheme.labelLarge),
          DropdownButton<String>(
            isExpanded: true,
            value: _goal,
            items: const [
              DropdownMenuItem(value: 'Saber 9', child: Text('Saber 9')),
              DropdownMenuItem(value: 'Saber 10', child: Text('Saber 10')),
              DropdownMenuItem(value: 'Saber 11', child: Text('Saber 11')),
              DropdownMenuItem(
                value: 'Refuerzo general',
                child: Text('Refuerzo general'),
              ),
              DropdownMenuItem(
                value: 'Educación superior',
                child: Text('Educación superior'),
              ),
            ],
            onChanged: (v) => setState(() => _goal = v ?? _goal),
          ),
        ],
      ),
    );
  }

  Widget _joinIntro(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '¿Tienes código de grupo?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            'Si tu profe te pasó un código, pulsa abajo. Si no, podrás unirte más tarde desde Perfil.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _teacherNamePage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          Text(
            'Tu nombre en el ranking',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nombre o apodo (visible para estudiantes)',
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? scheme.primaryContainer.withValues(alpha: 0.5) : scheme.surfaceContainerHighest.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 40, color: scheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnbPage extends StatelessWidget {
  const _OnbPage({
    required this.title,
    required this.body,
    required this.icon,
    required this.color,
  });

  final String title;
  final String body;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                body,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.45,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
