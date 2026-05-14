import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Panel docente con datos semilla (ponencia).
class TeacherScreen extends StatelessWidget {
  const TeacherScreen({super.key});

  static const _rows = <Map<String, String>>[
    {'est': 'Laura Vega', 'grado': '9', 'prec': '79%', 'debil': 'Álgebra', 'xp': '910'},
    {'est': 'Ana Gómez', 'grado': '11', 'prec': '82%', 'debil': 'Geometría', 'xp': '1240'},
    {'est': 'Carlos Ruiz', 'grado': '10', 'prec': '74%', 'debil': 'Álgebra', 'xp': '980'},
    {'est': 'María López', 'grado': '11', 'prec': '88%', 'debil': 'Estadística', 'xp': '1410'},
    {'est': 'Julián Peña', 'grado': '10', 'prec': '69%', 'debil': 'Aritmética', 'xp': '860'},
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel docente'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.class_outlined),
                        title: const Text('Grupos con código (Firebase)'),
                        subtitle: const Text('Crea códigos y QR; el ranking se actualiza en vivo'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.push('/teacher/groups'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Seguimiento de grupo',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vista orientada a docentes. Datos de ejemplo para demostrar métricas agregadas.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: const [
                        _Kpi(title: 'Asistencia a práctica', value: '78%'),
                        _Kpi(title: 'Precisión media', value: '78%'),
                        _Kpi(title: 'Estudiantes activos', value: '4 / 32'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 0,
                      color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStatePropertyAll(
                            scheme.surfaceContainerHighest.withValues(alpha: 0.6),
                          ),
                          columns: const [
                            DataColumn(label: Text('Estudiante')),
                            DataColumn(label: Text('Grado')),
                            DataColumn(label: Text('Precisión')),
                            DataColumn(label: Text('Tema débil')),
                            DataColumn(label: Text('XP (demo)')),
                          ],
                          rows: _rows
                              .map(
                                (r) => DataRow(
                                  cells: [
                                    DataCell(Text(r['est']!)),
                                    DataCell(Text(r['grado']!)),
                                    DataCell(Text(r['prec']!)),
                                    DataCell(Text(r['debil']!)),
                                    DataCell(Text(r['xp']!)),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  const _Kpi({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 6),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
