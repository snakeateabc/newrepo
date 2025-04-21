import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/space_debris.dart';
import '../utils/constants.dart';
import '../utils/game_preferences.dart';

class Obstacle extends PositionComponent {
  final Paint _paint = Paint()..color = Colors.red.withOpacity(0.8);
  
  Obstacle({
    required Vector2 position,
    required Vector2 size,
  }) : super(
        position: position,
        size: size,
        anchor: Anchor.center,
      );
  
  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset.zero,
      size.x / 2,
      _paint,
    );
  }
}

class OrbitalCleanupGame extends FlameGame with TapCallbacks {
  // Game state
  late int _levelId;
  int _score = 0;
  int _targetScore = 100;
  bool _isGameOver = false;
  final bool isDesktopMode;
  
  // Game timer
  late Timer _gameTimer;
  late Timer _debrisSpawnTimer;
  late Timer _obstacleSpawnTimer;
  int _timeRemaining = kLevelTimeLimitSeconds;
  
  // Game components
  Player? _player;
  final List<SpaceDebris> _debris = [];
  final List<Obstacle> _obstacles = [];
  final Random random = Random();
  
  // Difficulty modifiers based on level
  late double _obstacleSpeedMultiplier;
  late double _debrisSpeedMultiplier;
  late double _obstacleFrequencyMultiplier; 
  
  // Callback
  final Function(bool isCompleted, int score, int timeRemaining) onGameOver;
  
  // Stream for UI updates
  final _stateController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _stateController.stream;
  
  OrbitalCleanupGame({
    required int levelId,
    required this.onGameOver,
    this.isDesktopMode = false,
  }) : _levelId = levelId;
  
  @override
  Future<void> onLoad() async {
    // Set difficulty based on level
    _setDifficultyForLevel();
    
    // Set target score based on level
    _targetScore = 100 * _levelId;
    
    // Set up player with adjusted size for desktop
    final playerSizeMultiplier = isDesktopMode ? 0.06 : 0.08;
    _player = Player(
      initialPosition: Vector2(size.x / 2, size.y * (isDesktopMode ? 0.75 : 0.8)),
      initialSize: Vector2.all(size.x * playerSizeMultiplier),
    );
    add(_player!);
    
    // Add initial debris
    _addDebris();
    
    // Start game timer
    _gameTimer = Timer(1, onTick: _updateTimer, repeat: true);
    
    // Set up debris spawn timer (adjusted by level)
    final debrisSpawnRate = isDesktopMode ? 1.5 : 2.0; // Faster spawn on desktop
    _debrisSpawnTimer = Timer(debrisSpawnRate, onTick: _spawnDebris, repeat: true);
    
    // Set up obstacle spawn timer (adjusted by level and device)
    final baseObstacleRate = isDesktopMode ? 4.0 : 5.0; // Faster spawn on desktop
    _obstacleSpawnTimer = Timer(baseObstacleRate / _obstacleFrequencyMultiplier, onTick: _spawnObstacle, repeat: true);
    
    // Initial state update
    _updateGameState();
  }
  
  void _setDifficultyForLevel() {
    // Level 1: Base difficulty
    // Level 2: 1.5x obstacles, 1.2x speed
    // Level 3: 2.25x obstacles (1.5^2), 1.4x speed
    
    // Speed multipliers
    _obstacleSpeedMultiplier = 1.0 + ((_levelId - 1) * 0.2);  
    _debrisSpeedMultiplier = 1.0 + ((_levelId - 1) * 0.1);
    
    // Frequency multiplier (how often obstacles spawn)
    _obstacleFrequencyMultiplier = pow(1.5, _levelId - 1).toDouble();
  }
  
  void _addDebris() {
    // More debris in higher levels, even more for desktop mode
    final debrisCount = 5 + (_levelId * 2) + (isDesktopMode ? 5 : 0);
    
    for (var i = 0; i < debrisCount; i++) {
      final debris = SpaceDebris(
        position: Vector2(
          random.nextDouble() * size.x,
          random.nextDouble() * size.y * 0.5,
        ),
        debrisSize: DebrisSize.small,
        debrisType: DebrisType.trash,
      );
      add(debris);
      _debris.add(debris);
    }
  }
  
  void _spawnDebris() {
    // Don't spawn if game is over
    if (_isGameOver) return;
    
    // Create new debris at top of screen
    final debris = SpaceDebris(
      position: Vector2(
        random.nextDouble() * size.x,
        -20, // Start above screen
      ),
      debrisSize: random.nextDouble() < 0.7 ? DebrisSize.small : DebrisSize.medium,
      debrisType: DebrisType.trash,
      // Random chance to make debris hazardous based on level
      isHazard: random.nextDouble() < (0.1 * _levelId),
    );
    
    add(debris);
    _debris.add(debris);
  }
  
  void _spawnObstacle() {
    // Don't spawn if game is over
    if (_isGameOver) return;
    
    // Larger obstacles for desktop mode to maintain visual balance
    final obstacleSize = isDesktopMode ? 30.0 : 25.0;
    
    // Create new obstacle
    final obstacle = Obstacle(
      position: Vector2(
        random.nextDouble() * size.x,
        -20, // Start above screen
      ),
      size: Vector2.all(obstacleSize),
    );
    
    add(obstacle);
    _obstacles.add(obstacle);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (_isGameOver) return;
    
    _gameTimer.update(dt);
    _debrisSpawnTimer.update(dt);
    _obstacleSpawnTimer.update(dt);
    
    // Calculate base speeds based on device mode
    final baseObstacleSpeed = isDesktopMode ? 120.0 : 100.0;
    final baseDebrisSpeed = isDesktopMode ? 60.0 : 50.0;
    
    // Move obstacles down
    for (final obstacle in List.from(_obstacles)) {
      obstacle.position.y += baseObstacleSpeed * _obstacleSpeedMultiplier * dt;
      
      // Remove if off screen
      if (obstacle.position.y > size.y + obstacle.size.y) {
        _obstacles.remove(obstacle);
        obstacle.removeFromParent();
      }
      
      // Check collision with player
      if (_player != null && _checkCollisionWithObstacle(_player!, obstacle)) {
        endGame(false); // Game over if player hits obstacle
        return;
      }
    }
    
    // Check collisions with debris
    if (_player != null) {
      for (final debris in List.from(_debris)) {
        // Move debris down if it's not moving (for continuous motion)
        debris.position.y += baseDebrisSpeed * _debrisSpeedMultiplier * dt;
        
        // Remove if off screen
        if (debris.position.y > size.y + debris.size.y) {
          _debris.remove(debris);
          debris.removeFromParent();
        }
        
        // Check collection
        if (_checkCollision(_player!, debris)) {
          if (debris.isHazard) {
            // End game immediately if player hits hazardous debris
            endGame(false);
            return;
          } else {
            _collectDebris(debris);
          }
        }
      }
    }
  }
  
  bool _checkCollision(Player player, SpaceDebris debris) {
    final distance = (player.position - debris.position).length;
    // Use a larger collision radius for hazardous debris to ensure they're hard to avoid
    final collisionFactor = debris.isHazard ? 0.9 : 0.8;
    return distance < (player.size.x / 2 + debris.size.x / 2) * collisionFactor;
  }
  
  bool _checkCollisionWithObstacle(Player player, Obstacle obstacle) {
    final distance = (player.position - obstacle.position).length;
    // Make obstacle collision more precise to make sure any touch causes game over
    return distance < (player.size.x / 2 + obstacle.size.x / 2) * 0.8;
  }
  
  void _collectDebris(SpaceDebris debris) {
    // This should only be called for non-hazardous debris now
    _score += debris.pointValue;
    _debris.remove(debris);
    debris.removeFromParent();
    
    _updateGameState();
    
    // Check win condition
    if (_score >= _targetScore) {
      endGame(true);
    }
  }
  
  void _updateGameState() {
    _stateController.add({
      'score': _score,
      'targetScore': _targetScore,
      'timeRemaining': _timeRemaining,
    });
  }
  
  void _updateTimer() {
    _timeRemaining--;
    _updateGameState();
    
    // End game if timer runs out
    if (_timeRemaining <= 0) {
      endGame(false);
    }
  }
  
  void endGame(bool isCompleted) {
    if (_isGameOver) return; // Prevent multiple calls
    
    _isGameOver = true;
    
    // Store high score if level completed
    if (isCompleted) {
      GamePreferences.completeLevel(_levelId);
      
      final currentHighScore = GamePreferences.getHighScore(_levelId);
      if (_score > currentHighScore) {
        GamePreferences.saveHighScore(_levelId, _score);
      }
    }
    
    // Call callback
    onGameOver(isCompleted, _score, _timeRemaining);
  }
  
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (_isGameOver) return;
    _player?.moveTo(event.canvasPosition);
  }
  
  @override
  void onRemove() {
    _stateController.close();
    super.onRemove();
  }
}