import 'dart:async';
import 'package:flame/components.dart';
import '../../models/space_debris.dart';
import '../level.dart';

class LevelOne extends Level {
  // Level-specific properties
  late Timer _debrisSpawnTimer;
  int _spawnCount = 0;
  final int _maxSpawnCount = 30;

  LevelOne() : super(targetScore: 300);

  @override
  void initializeLevel() {
    // Start spawning debris
    _debrisSpawnTimer = Timer(
      2.0, // Spawn every 2 seconds
      onTick: _spawnDebris,
      repeat: true,
    );
    
    // Add some initial debris
    for (int i = 0; i < 5; i++) {
      _spawnInitialDebris();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _debrisSpawnTimer.update(dt);
  }

  void _spawnDebris() {
    if (_spawnCount >= _maxSpawnCount) {
      _debrisSpawnTimer.stop();
      return;
    }
    
    // Spawn a mix of trash and satellites for level 1
    final random = gameRef.random.nextDouble();
    
    if (random < 0.7) {
      // 70% chance of spawning trash
      final debris = spawnDebris(
        type: DebrisType.trash,
        isHazard: random < 0.15, // 15% of total spawns are hazards
      );
      gameRef.add(debris);
    } else {
      // 30% chance of spawning a satellite
      final debris = spawnDebris(
        type: DebrisType.satellite,
        size: DebrisSize.medium,
        isHazard: true, // All satellites are hazards in level 1
      );
      gameRef.add(debris);
    }
    
    _spawnCount++;
  }

  void _spawnInitialDebris() {
    // Spawn some initial collectible trash
    final x = gameRef.random.nextDouble() * gameRef.size.x;
    final y = gameRef.random.nextDouble() * (gameRef.size.y * 0.7) + 100;
    
    final debris = SpaceDebris(
      position: Vector2(x, y),
      debrisSize: DebrisSize.small,
      debrisType: DebrisType.trash,
      isHazard: false,
    );
    
    addDebris(debris);
    gameRef.add(debris);
  }
} 