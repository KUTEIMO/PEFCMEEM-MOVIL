import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/course_models.dart';

class CourseRepository {
  CourseCatalog? _cached;

  Future<CourseCatalog> loadCatalog() async {
    if (_cached != null) return _cached!;
    final raw = await rootBundle.loadString('assets/courses.json');
    final map = jsonDecode(raw) as Map<String, dynamic>;
    _cached = CourseCatalog.fromJson(map);
    return _cached!;
  }

  Future<LessonRef?> findLesson(String courseId, String lessonId) async {
    final cat = await loadCatalog();
    return cat.findLessonRef(courseId, lessonId);
  }
}
