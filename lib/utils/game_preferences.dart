import 'package:shared_preferences/shared_preferences.dart';

class GamePreferences {
  static late SharedPreferences _prefs;
  static const String _completedLevelsKey = 'completed_levels';
  static const String _highScoresKey = 'high_scores';

  // Initialize the preferences instance
  static void initialize(SharedPreferences prefs) {
    _prefs = prefs;
  }

  // Get completed levels
  static Set<int> getCompletedLevels() {
    final List<String> completed = _prefs.getStringList(_completedLevelsKey) ?? [];
    return completed.map((level) => int.parse(level)).toSet();
  }

  // Save a completed level
  static Future<bool> completeLevel(int levelId) async {
    final completedLevels = getCompletedLevels();
    completedLevels.add(levelId);
    
    return await _prefs.setStringList(
      _completedLevelsKey,
      completedLevels.map((level) => level.toString()).toList(),
    );
  }

  // Save high score for a level
  static Future<bool> saveHighScore(int levelId, int score) async {
    final key = "${_highScoresKey}_$levelId";
    final currentHighScore = _prefs.getInt(key) ?? 0;
    
    if (score > currentHighScore) {
      return await _prefs.setInt(key, score);
    }
    return false;
  }

  // Get high score for a level
  static int getHighScore(int levelId) {
    final key = "${_highScoresKey}_$levelId";
    return _prefs.getInt(key) ?? 0;
  }

  // Reset all game progress (for testing)
  static Future<void> resetProgress() async {
    await _prefs.remove(_completedLevelsKey);
    
    // Get all keys that start with high_scores
    final keys = _prefs.getKeys();
    final highScoreKeys = keys.where((key) => key.startsWith(_highScoresKey));
    
    // Remove all high score keys
    for (final key in highScoreKeys) {
      await _prefs.remove(key);
    }
  }
} 