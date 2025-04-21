import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class GamePreferences {
  static late SharedPreferences _prefs;
  
  static Future<void> initialize(SharedPreferences prefs) async {
    _prefs = prefs;
  }
  
  static bool isLevelCompleted(int levelId) {
    return _prefs.getBool('level_$levelId\_completed') ?? false;
  }
  
  static Future<void> completeLevel(int levelId) async {
    await _prefs.setBool('level_$levelId\_completed', true);
  }
  
  static int getHighScore(int levelId) {
    return _prefs.getInt('level_$levelId\_highscore') ?? 0;
  }
  
  static Future<void> saveHighScore(int levelId, int score) async {
    final currentHighScore = getHighScore(levelId);
    if (score > currentHighScore) {
      await _prefs.setInt('level_$levelId\_highscore', score);
    }
  }
  
  static bool isSoundEnabled() {
    return _prefs.getBool('sound_enabled') ?? true;
  }
  
  static Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool('sound_enabled', enabled);
  }
  
  static bool isMusicEnabled() {
    return _prefs.getBool('music_enabled') ?? true;
  }
  
  static Future<void> setMusicEnabled(bool enabled) async {
    await _prefs.setBool('music_enabled', enabled);
  }
  
  static List<int> getCompletedLevels() {
    final completedLevels = <int>[];
    for (int i = 1; i <= kTotalLevels; i++) {
      if (isLevelCompleted(i)) {
        completedLevels.add(i);
      }
    }
    return completedLevels;
  }
} 