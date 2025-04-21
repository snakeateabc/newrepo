import 'dart:async';
import 'package:flame/components.dart';
import '../../models/space_debris.dart';
import '../level.dart';

class LevelThree extends Level {
  // Level-specific properties
  late Timer _debrisSpawnTimer;
  late Timer _asteroidSpawnTimer;
  int _spawnCount = 0;
  final int _maxSpawnCount = 50;
  
  // Asteroid field patterns
  final List<Vector2> _asteroidPattern = [];
  int _patternIndex = 0;

  LevelThree() : super(targetScore: 800);

  @override
  void initializeLevel() {
    // Start spawning debris
    _debrisSpawnTimer = Timer(
      1.0, // Spawn every second
      onTick: _spawnDebris,
      repeat: true,
    );
    
    // Add some initial debris
    for (int i = 0; i < 10; i++) {
      _spawnInitialDebris();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _debrisSpawnTimer.update(dt);
    _asteroidSpawnTimer.update(dt);
    
    // Level-specific update logic
  }

  void _generateAsteroidPattern() {
    // Generate a zigzag pattern for asteroids to follow
    final screenWidth = 500.0; // We'll use a default since we don't have gameRef yet
    
    for (int i = 0; i < 6; i++) {
      // Zigzag across the screen
      final x = i.isEven ? screenWidth * 0.2 : screenWidth * 0.8;
      _asteroidPattern.add(Vector2(x, 0));
    }
  }

  void _spawnDebris() {
    if (_spawnCount >= _maxSpawnCount) {
      _debrisSpawnTimer.stop();
      _asteroidSpawnTimer.stop();
      return;
    }
    
    // In level 3, spawn more large-sized trash and higher value items
    final random = gameRef.random.nextDouble();
    DebrisSize size;
    
    if (random < 0.3) {
      size = DebrisSize.small;
    } else if (random < 0.7) {
      size = DebrisSize.medium;
    } else {
      size = DebrisSize.large;
    }
    
    // Mix of trash and valuable space debris
    final debrisType = random < 0.6 ? DebrisType.trash : DebrisType.satellite;
    final isHazard = debrisType == DebrisType.satellite && random < 0.3;
    
    final debris = spawnDebris(
      type: debrisType,
      size: size,
      isHazard: isHazard,
    );
    
    gameRef.add(debris);
    _spawnCount++;
  }
  
  void _spawnAsteroid() {
    if (_spawnCount >= _maxSpawnCount) {
      return;
    }
    
    // Get x position from pattern
    double x;
    if (_asteroidPattern.isNotEmpty) {
      _patternIndex = (_patternIndex + 1) % _asteroidPattern.length;
      x = _asteroidPattern[_patternIndex].x;
    } else {
      x = gameRef.random.nextDouble() * gameRef.size.x;
    }
    
    // Create a cluster of asteroids
    final clusterSize = gameRef.random.nextInt(3) + 1;
    
    for (int i = 0; i < clusterSize; i++) {
      final offsetX = (gameRef.random.nextDouble() - 0.5) * 100;
      final asteroid = SpaceDebris(
        position: Vector2(x + offsetX, -50 - i * 40),
        debrisSize: DebrisSize.large,
        debrisType: DebrisType.asteroid,
        isHazard: true,
        rotationSpeed: gameRef.random.nextDouble() * 1.0 + 0.5,
      );
      
      gameRef.add(asteroid);
    }
  }

  void _spawnInitialDebris() {
    // In level 3, start with a chaotic field of various debris types
    final x = gameRef.random.nextDouble() * gameRef.size.x;
    final y = gameRef.random.nextDouble() * (gameRef.size.y * 0.6) + 100;
    
    // Random debris type, but weighted towards collectibles
    final random = gameRef.random.nextDouble();
    DebrisType type;
    bool isHazard;
    
    if (random < 0.6) {
      type = DebrisType.trash;
      isHazard = false;
    } else if (random < 0.8) {
      type = DebrisType.satellite;
      isHazard = false; // Some satellites are collectible in level 3
    } else {
      type = DebrisType.asteroid;
      isHazard = true;
    }
    
    // Random size, weighted towards larger debris
    final sizeRoll = gameRef.random.nextDouble();
    DebrisSize size;
    
    if (sizeRoll < 0.3) {
      size = DebrisSize.small;
    } else if (sizeRoll < 0.7) {
      size = DebrisSize.medium;
    } else {
      size = DebrisSize.large;
    }
    
    final debris = SpaceDebris(
      position: Vector2(x, y),
      debrisSize: size,
      debrisType: type,
      isHazard: isHazard,
      rotationSpeed: gameRef.random.nextDouble() * 1.5,
    );
    
    gameRef.add(debris);
  }
} 