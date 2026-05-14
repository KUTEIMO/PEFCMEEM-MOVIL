import 'package:flutter/material.dart';

enum MathArea { algebra, statistics, geometry, arithmetic }

class Exercise {
  const Exercise({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String id;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      prompt: json['prompt'] as String,
      options: (json['options'] as List<dynamic>).cast<String>(),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
    );
  }
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.estimatedMinutes,
    required this.theoryPlain,
    required this.exercises,
  });

  final String id;
  final String title;
  final int estimatedMinutes;
  final String theoryPlain;
  final List<Exercise> exercises;

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      estimatedMinutes: json['estimatedMinutes'] as int,
      theoryPlain: json['theoryPlain'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Unit {
  const Unit({
    required this.id,
    required this.title,
    required this.lessons,
  });

  final String id;
  final String title;
  final List<Lesson> lessons;

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'] as String,
      title: json['title'] as String,
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Course {
  const Course({
    required this.id,
    required this.title,
    required this.area,
    required this.accentColorKey,
    required this.units,
  });

  final String id;
  final String title;
  final MathArea area;
  final String accentColorKey;
  final List<Unit> units;

  Iterable<Lesson> get allLessons sync* {
    for (final u in units) {
      for (final l in u.lessons) {
        yield l;
      }
    }
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      area: MathArea.values.firstWhere(
        (a) => a.name == json['area'],
        orElse: () => MathArea.algebra,
      ),
      accentColorKey: json['accentColorKey'] as String,
      units: (json['units'] as List<dynamic>)
          .map((e) => Unit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CourseCatalog {
  const CourseCatalog({required this.courses});

  final List<Course> courses;

  factory CourseCatalog.fromJson(Map<String, dynamic> json) {
    final list = (json['courses'] as List<dynamic>)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
    return CourseCatalog(courses: list);
  }

  /// Global lesson order for unlock rules within each course.
  List<LessonRef> orderedLessonRefs() {
    final refs = <LessonRef>[];
    for (final c in courses) {
      for (final u in c.units) {
        for (final l in u.lessons) {
          refs.add(LessonRef(course: c, unit: u, lesson: l));
        }
      }
    }
    return refs;
  }

  List<LessonRef> orderedLessonRefsForCourse(String courseId) {
    final c = courses.firstWhere((x) => x.id == courseId);
    final refs = <LessonRef>[];
    for (final u in c.units) {
      for (final l in u.lessons) {
        refs.add(LessonRef(course: c, unit: u, lesson: l));
      }
    }
    return refs;
  }

  LessonRef? findLessonRef(String courseId, String lessonId) {
    for (final c in courses) {
      if (c.id != courseId) continue;
      for (final u in c.units) {
        for (final l in u.lessons) {
          if (l.id == lessonId) {
            return LessonRef(course: c, unit: u, lesson: l);
          }
        }
      }
    }
    return null;
  }
}

class LessonRef {
  const LessonRef({
    required this.course,
    required this.unit,
    required this.lesson,
  });

  final Course course;
  final Unit unit;
  final Lesson lesson;
}

extension AreaColors on MathArea {
  Color get accentColor {
    switch (this) {
      case MathArea.algebra:
        return const Color(0xFF2D3A8C);
      case MathArea.statistics:
        return const Color(0xFF22C55E);
      case MathArea.geometry:
        return const Color(0xFF7C3AED);
      case MathArea.arithmetic:
        return const Color(0xFFF97316);
    }
  }
}
