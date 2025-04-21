import 'dart:math';
import 'package:flame/components.dart';
import '../models/space_debris.dart';
import 'orbital_cleanup_game.dart';

abstract class Level extends Component with HasGameRef<OrbitalCleanupGame> {
  final Random random = Random();
  final int targetScore;
  int currentScore = 0;
  int debrisCollected = 0;
  int timeRemaining = 0;
  bool isCompleted = false;
  final List<SpaceDebris> _debris = [];
  
  Level({required this.targetScore});
  
  List<SpaceDebris> get debris => _debris;
  
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
    final x = random.nextDouble() * screenWidth;
    final y = -50.0; // Start above screen
    
    // Create and return the debris
    final debris = SpaceDebris(
      position: Vector2(x, y),
      debrisSize: size,
      debrisType: type,
      isHazard: isHazard,
      rotationSpeed: random.nextDouble() * 2.0,
    );
    
    addDebris(debris);
    return debris;
  }
  
  // Handle debris collection
  void collectDebris(SpaceDebris debris) {
    if (!debris.isCollected) {
      debris.collect();
      currentScore += debris.pointValue;
      _debris.remove(debris);
      
      // Check if level is completed
      if (currentScore >= targetScore) {
        isCompleted = true;
        gameRef.endGame(true);
      }
    }
  }
  
  // Timer callback
  void updateTimer(int secondsLeft) {
    timeRemaining = secondsLeft;
    if (timeRemaining <= 0 && !isCompleted) {
      gameRef.endGame(false);
    }
  }
  
  void addDebris(SpaceDebris debris) {
    _debris.add(debris);
  }
  
  DebrisSize _getRandomDebrisSize() {
    final roll = random.nextDouble();
    if (roll < 0.5) {
      return DebrisSize.small;
    } else if (roll < 0.8) {
      return DebrisSize.medium;
    } else {
      return DebrisSize.large;
    }
  }
} 