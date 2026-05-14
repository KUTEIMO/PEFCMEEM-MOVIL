import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;
  final _nameController = TextEditingController();
  String _grade = '10';
  String _goal = 'Saber 11';

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await context.app.completeOnboarding(
      displayName: _nameController.text,
      gradeLabel: _grade,
      goalLabel: _goal,
    );
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('PEFCMEEM'),
        actions: [
          if (_page < 4)
            TextButton(
              onPressed: () {
                _pageController.animateToPage(
                  4,
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
            value: (_page + 1) / 5,
            minHeight: 4,
            borderRadius: BorderRadius.circular(4),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _page = i),
              children: [
                _OnbPage(
                  title: 'Mejora matemáticas sin estudiar horas',
                  body:
                      'PEFCMEEM te guía con rutas cortas y claras, pensadas para estudiantes de educación media en Colombia.',
                  icon: Icons.school_outlined,
                  color: scheme.primary,
                ),
                _OnbPage(
                  title: 'Lecciones rápidas de 5 a 10 minutos',
                  body:
                      'Micro-aprendizaje para reducir carga cognitiva: un objetivo por lección y espacio visual amplio.',
                  icon: Icons.timer_outlined,
                  color: scheme.secondary,
                ),
                _OnbPage(
                  title: 'Progreso visible, sin sensación de examen',
                  body:
                      'XP, rachas y desbloqueo progresivo para motivar el retorno diario, con retroalimentación inmediata.',
                  icon: Icons.trending_up_rounded,
                  color: scheme.tertiary,
                ),
                _OnbPage(
                  title: 'Preparación alineada con Saber 11',
                  body:
                      'Contenidos semilla en álgebra, estadística, geometría y aritmética, listos para ampliarse con validación académica.',
                  icon: Icons.menu_book_outlined,
                  color: scheme.primary,
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: ListView(
                    children: [
                      Text(
                        'Personaliza tu experiencia',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Puedes cambiar esto después en tu perfil.',
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
                ),
              ],
            ),
          ),
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
                  FilledButton(
                    onPressed: () {
                      if (_page < 4) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                        );
                      } else {
                        _finish();
                      }
                    },
                    child: Text(_page < 4 ? 'Siguiente' : 'Comenzar'),
                  ),
                ],
              ),
            ),
          ),
        ],
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
