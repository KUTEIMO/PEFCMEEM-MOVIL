import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/course_models.dart';
import 'firebase_bootstrap.dart';

typedef CatalogUpdatedCallback = void Function();

class CourseRepository {
  CourseRepository();

  CourseCatalog? _cached;

  /// Notificado cuando Firestore reemplaza el catálogo local (carga en segundo plano).
  CatalogUpdatedCallback? onCatalogUpdated;

  /// Invalida caché para volver a leer assets + Firestore (p. ej. tras publicar catálogo).
  void clearCache() {
    _cached = null;
  }

  CourseCatalog? get cachedCatalog => _cached;

  /// Carga **de inmediato** el JSON embebido; si hay Firestore, intenta mejorar el catálogo en segundo plano.
  Future<CourseCatalog> loadCatalog() async {
    if (_cached != null) return _cached!;

    final raw = await rootBundle.loadString('assets/courses.json');
    final local = CourseCatalog.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    _cached = local;

    if (FirebaseBootstrap.firebaseAppReady) {
      unawaited(_mergeRemoteCatalogWhenReady());
    }
    return _cached!;
  }

  Future<void> _mergeRemoteCatalogWhenReady() async {
    try {
      final timeout = kIsWeb ? const Duration(seconds: 2) : const Duration(seconds: 6);
      final snap = await FirebaseFirestore.instance
          .collection('published')
          .doc('courses')
          .get(const GetOptions(source: Source.serverAndCache))
          .timeout(timeout);
      final data = snap.data();
      final list = data?['courses'];
      if (!snap.exists || list is! List<dynamic> || list.isEmpty) {
        return;
      }
      final remote = CourseCatalog.fromJson({'courses': list});
      _cached = remote;
      onCatalogUpdated?.call();
    } catch (_) {
      // Sin remoto: se mantiene el catálogo local.
    }
  }

  Future<LessonRef?> findLesson(String courseId, String lessonId) async {
    final cat = await loadCatalog();
    return cat.findLessonRef(courseId, lessonId);
  }
}
