import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/models/course_models.dart';

class PathScreen extends StatelessWidget {
  const PathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final cat = app.catalog;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruta de aprendizaje'),
      ),
      body: cat == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: cat.courses.length,
              itemBuilder: (context, i) {
                final c = cat.courses[i];
                final progress = app.unitProgressForCourse(c.id);
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: c.area.accentColor.withValues(alpha: 0.15),
                      child: Icon(Icons.route_rounded, color: c.area.accentColor),
                    ),
                    title: Text(
                      c.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text('${c.units.length} unidad · ${c.allLessons.length} micro-lecciones'),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/course/${c.id}'),
                  ),
                );
              },
            ),
    );
  }
}
