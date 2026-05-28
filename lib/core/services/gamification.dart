/// Reglas de gamificación del MVP (sin economía de monedas).
class Gamification {
  static int xpPerCorrectAnswer() => 10;

  /// Bonificación cuando todos los ejercicios de la lección son correctos.
  static int perfectLessonBonus() => 15;

  static int levelFromTotalXp(int totalXp) {
    if (totalXp <= 0) return 1;
    return (totalXp / 100).floor() + 1;
  }

  static int xpIntoCurrentLevel(int totalXp) {
    final level = levelFromTotalXp(totalXp);
    final start = (level - 1) * 100;
    return totalXp - start;
  }

  static int xpForNextLevel(int totalXp) {
    final level = levelFromTotalXp(totalXp);
    return level * 100 - totalXp;
  }
}
