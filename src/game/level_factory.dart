import 'level.dart';
import 'levels/level_one.dart';
import 'levels/level_two.dart';
import 'levels/level_three.dart';

class LevelFactory {
  static Level createLevel(int levelId) {
    switch (levelId) {
      case 1:
        return LevelOne();
      case 2:
        return LevelTwo();
      case 3:
        return LevelThree();
      default:
        throw ArgumentError('Invalid level ID: $levelId');
    }
  }
} 