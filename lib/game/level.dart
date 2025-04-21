import 'dart:math';
import 'package:flame/components.dart';
import '../models/space_debris.dart';
import 'orbital_cleanup_game.dart';

abstract class Level extends Component with HasGameRef<OrbitalCleanupGame> {
  final Random _random = Random();
  final int levelId;
  int targetScore = 0;
  int currentScore = 0;
  int debrisCollected = 0;
  int timeRemaining = 0;
  bool isCompleted = false;
  
  Level(this.levelId);
  
  @override
  void onMount() {
    super.onMount();
    timeRemaining = gameRef.levelTimeLimit;
    initializeLevel();
  }
  
  // Initialize level-specific settings and spawn patterns
  void initializeLevel();
  
  // Spawn debris based on level settings
  SpaceDebris spawnDebris({
    required DebrisType type,
    DebrisSize? size,
    bool isHazard = false,
  }) {
    final screenWidth = gameRef.size.x;
    final screenHeight = gameRef.size.y;
    
    // Determine size if not provided
    size ??= _getRandomDebrisSize();
    
    // Create random position at top of screen
    final x = _random.nextDouble() * screenWidth;
    final y = -50.0; // Start above screen
    
    // Create and return the debris
    return SpaceDebris(
      position: Vector2(x, y),
      debrisSize: size,
      debrisType: type,
      isHazard: isHazard,
      rotationSpeed: _random.nextDouble() * 2.0,
    );
  }
  
  // Handle debris collection
  void collectDebris(SpaceDebris debris) {
    if (!debris.isHazard) {
      currentScore += debris.pointValue;
      debrisCollected++;
      checkLevelCompletion();
    } else {
      // Handle hazard collision
      gameRef.handleHazardCollision();
    }
  }
  
  // Check if level is completed
  void checkLevelCompletion() {
    if (currentScore >= targetScore) {
      isCompleted = true;
      gameRef.completeLevel();
    }
  }
  
  // Timer callback
  void updateTimer(int secondsLeft) {
    timeRemaining = secondsLeft;
    if (timeRemaining <= 0 && !isCompleted) {
      gameRef.timeUp();
    }
  }
  
  DebrisSize _getRandomDebrisSize() {
    final roll = _random.nextDouble();
    if (roll < 0.5) {
      return DebrisSize.small;
    } else if (roll < 0.8) {
      return DebrisSize.medium;
    } else {
      return DebrisSize.large;
    }
  }
} 