import 'dart:async';
import 'package:flame/components.dart';
import '../../models/space_debris.dart';
import '../level.dart';

class LevelTwo extends Level {
  // Level-specific properties
  late Timer _debrisSpawnTimer;
  late Timer _satelliteSpawnTimer;
  int _spawnCount = 0;
  final int _maxSpawnCount = 40;

  LevelTwo() : super(2);

  @override
  void initializeLevel() {
    targetScore = 500; // Target score to complete the level
    
    // Start spawning debris
    _debrisSpawnTimer = Timer(
      1.5, // Spawn every 1.5 seconds (faster than level 1)
      onTick: _spawnDebris,
      repeat: true,
    );
    
    // Spawn satellites on a separate timer
    _satelliteSpawnTimer = Timer(
      4.0, // Spawn satellites every 4 seconds
      onTick: _spawnSatellite,
      repeat: true,
    );
    
    // Add some initial debris
    for (int i = 0; i < 7; i++) {
      _spawnInitialDebris();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _debrisSpawnTimer.update(dt);
    _satelliteSpawnTimer.update(dt);
    
    // Level-specific update logic
  }

  void _spawnDebris() {
    if (_spawnCount >= _maxSpawnCount) {
      _debrisSpawnTimer.stop();
      _satelliteSpawnTimer.stop();
      return;
    }
    
    // In level 2, spawn more medium-sized trash and more hazards
    final random = gameRef.random.nextDouble();
    DebrisSize size;
    
    if (random < 0.4) {
      size = DebrisSize.small;
    } else if (random < 0.8) {
      size = DebrisSize.medium;
    } else {
      size = DebrisSize.large;
    }
    
    final debris = spawnDebris(
      type: DebrisType.trash,
      size: size,
      isHazard: random < 0.25, // 25% chance of being a hazard
    );
    
    gameRef.add(debris);
    _spawnCount++;
  }
  
  void _spawnSatellite() {
    if (_spawnCount >= _maxSpawnCount) {
      return;
    }
    
    // Satellites move in patterns in level 2
    final x = gameRef.random.nextDouble() * gameRef.size.x;
    
    final satellite = SpaceDebris(
      position: Vector2(x, -50),
      debrisSize: DebrisSize.medium,
      debrisType: DebrisType.satellite,
      isHazard: true,
      rotationSpeed: 0.3,
    );
    
    gameRef.add(satellite);
  }

  void _spawnInitialDebris() {
    // In level 2, spawn both trash and asteroids as initial debris
    final x = gameRef.random.nextDouble() * gameRef.size.x;
    final y = gameRef.random.nextDouble() * (gameRef.size.y * 0.7) + 100;
    
    final type = gameRef.random.nextBool() 
        ? DebrisType.trash 
        : DebrisType.asteroid;
    
    final size = gameRef.random.nextBool()
        ? DebrisSize.small
        : DebrisSize.medium;
    
    final debris = SpaceDebris(
      position: Vector2(x, y),
      debrisSize: size,
      debrisType: type,
      isHazard: type == DebrisType.asteroid, // Asteroids are hazards
    );
    
    gameRef.add(debris);
  }
} 