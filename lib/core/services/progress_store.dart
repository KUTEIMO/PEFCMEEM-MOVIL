import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_progress.dart';

/// Persistencia local compatible con Web y móvil.
class ProgressStore {
  static const _keyProgress = 'pefcmeem_user_progress_v1';
  static const _keyOnboarding = 'pefcmeem_onboarding_done_v1';
  static const _keyTheme = 'pefcmeem_theme_mode_v1';
  static const _keyUserRole = 'pefcmeem_user_role_v1';
  static const _keyGroupId = 'pefcmeem_current_group_id_v1';
  static const _keyGroupCode = 'pefcmeem_current_group_code_v1';

  static Future<UserProgress> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyProgress);
    if (raw == null || raw.isEmpty) {
      return UserProgress.initial();
    }
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserProgress.fromJson(map);
    } catch (_) {
      return UserProgress.initial();
    }
  }

  static Future<void> saveProgress(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProgress, jsonEncode(progress.toJson()));
  }

  static Future<bool> loadOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboarding) ?? false;
  }

  static Future<void> setOnboardingDone(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboarding, value);
  }

  static Future<String?> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTheme);
  }

  static Future<void> saveThemeMode(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTheme, value);
  }

  static Future<String?> loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserRole);
  }

  static Future<void> saveUserRole(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserRole, value);
  }

  static Future<String?> loadCurrentGroupId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyGroupId);
  }

  static Future<void> saveCurrentGroupId(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null || id.isEmpty) {
      await prefs.remove(_keyGroupId);
    } else {
      await prefs.setString(_keyGroupId, id);
    }
  }

  static Future<String?> loadCurrentGroupCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyGroupCode);
  }

  static Future<void> saveCurrentGroupCode(String? code) async {
    final prefs = await SharedPreferences.getInstance();
    if (code == null || code.isEmpty) {
      await prefs.remove(_keyGroupCode);
    } else {
      await prefs.setString(_keyGroupCode, code);
    }
  }

  static Future<void> clearGroup() async {
    await saveCurrentGroupId(null);
    await saveCurrentGroupCode(null);
  }
}
