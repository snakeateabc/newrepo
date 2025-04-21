import 'dart:async';
import 'dart:math';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/space_debris.dart';
import '../utils/constants.dart';
import '../utils/game_preferences.dart';
import '../utils/sound_manager.dart';
import 'level.dart';
import 'level_factory.dart';

class OrbitalCleanupGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  // Game state
  late int _levelId;
  Level? _currentLevel;
  Player? _player;
  bool _isGameOver = false;
  bool _isLevelCompleted = false;
  
  // Game timer
  late Timer _gameTimer;
  int _timeRemaining = kLevelTimeLimitSeconds;
  
  // Game refs
  final Random random = Random();
  final Function(bool isCompleted, int score, int timeRemaining) onGameOver;
  final int levelTimeLimit = kLevelTimeLimitSeconds;
  
  // Stream controller for game state updates
  final _stateController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _stateController.stream;
  
  OrbitalCleanupGame({
    required int levelId,
    required this.onGameOver,
  }) : _levelId = levelId;
  
  @override
  Future<void> onLoad() async {
    // Set up camera with fixed resolution
    camera.viewport = FixedResolutionViewport(Vector2(kMaxGameWidth, kMaxGameWidth * 1.5));

    // Add player spaceship
    _player = Player(
      position: Vector2(size.x / 2, size.y * 0.8),
      size: 40.0,
    );
    add(_player!);
    
    // Create and add the level
    _currentLevel = LevelFactory.createLevel(_levelId);
    add(_currentLevel!);
    
    // Start game timer
    _gameTimer = Timer(
      1,
      onTick: _updateTimer,
      repeat: true,
    );
    
    // Add background stars
    _addBackground();
    
    // Initial state update
    _updateGameState();
  }
  
  void _addBackground() {
    // Add some background stars
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.x;
      final y = random.nextDouble() * size.y;
      final starSize = random.nextDouble() * 2 + 1;
      
      final star = BackgroundStar(
        position: Vector2(x, y),
        size: starSize,
      );
      add(star);
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (_isGameOver || _isLevelCompleted) return;
    
    // Update game timer
    _gameTimer.update(dt);
    
    // Check for collisions between player and debris
    for (final component in children) {
      if (component is SpaceDebris && !component.isCollected) {
        if (_isColliding(_player!, component)) {
          _handleDebrisCollision(component);
        }
      }
    }
    
    // Update game state
    _updateGameState();
  }
  
  void _updateGameState() {
    if (!_stateController.isClosed) {
      _stateController.add({
        'score': _currentLevel?.currentScore ?? 0,
        'targetScore': _currentLevel?.targetScore ?? 0,
        'timeRemaining': _timeRemaining,
        'isGameOver': _isGameOver,
        'isLevelCompleted': _isLevelCompleted,
      });
    }
  }
  
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    
    if (_isGameOver || _isLevelCompleted) return;
    
    // Move player to tap position
    final worldPosition = event.canvasPosition;
    _player?.moveTo(worldPosition);
  }
  
  bool _isColliding(Player player, SpaceDebris debris) {
    final distance = player.position.distanceTo(debris.position);
    return distance < (player.size.x / 2 + debris.size.x / 2) * 0.8;
  }
  
  void _handleDebrisCollision(SpaceDebris debris) {
    if (debris.isHazard) {
      handleHazardCollision();
    } else {
      debris.collect();
      _currentLevel?.collectDebris(debris);
      SoundManager.playSound('collect');
      _updateGameState();
    }
  }
  
  void handleHazardCollision() {
    // End the game when colliding with a hazard
    _isGameOver = true;
    SoundManager.playSound('explosion');
    _updateGameState();
    _endGame(false);
  }
  
  void completeLevel() {
    // Level completed successfully
    _isLevelCompleted = true;
    
    // Save progress
    GamePreferences.completeLevel(_levelId);
    
    // Calculate final score with time bonus
    final baseScore = _currentLevel?.currentScore ?? 0;
    final timeBonus = _timeRemaining * kBonusPointsPerSecond;
    final completionBonus = kLevelCompletionBonus;
    final totalScore = baseScore + timeBonus + completionBonus;
    
    // Save high score if better than previous
    GamePreferences.saveHighScore(_levelId, totalScore);
    
    // Play completion sound
    SoundManager.playSound('level_complete');
    
    _updateGameState();
    _endGame(true);
  }
  
  void timeUp() {
    // Time ran out, check if player reached target score
    if (_currentLevel != null && 
        _currentLevel!.currentScore >= _currentLevel!.targetScore) {
      completeLevel();
    } else {
      _isGameOver = true;
      SoundManager.playSound('game_over');
      _updateGameState();
      _endGame(false);
    }
  }
  
  void _updateTimer() {
    if (_timeRemaining > 0) {
      _timeRemaining--;
      _currentLevel?.updateTimer(_timeRemaining);
      _updateGameState();
    } else {
      timeUp();
    }
  }
  
  void _endGame(bool isCompleted) {
    // Pause the game
    pauseEngine();
    
    // Pause background music
    SoundManager.pauseMusic();
    
    // Call the callback with the results
    onGameOver(
      isCompleted,
      _currentLevel?.currentScore ?? 0,
      _timeRemaining,
    );
  }
  
  @override
  void onRemove() {
    _stateController.close();
    super.onRemove();
  }
  
  @override
  void onPause() {
    super.onPause();
    SoundManager.pauseMusic();
  }
  
  @override
  void onResume() {
    super.onResume();
    SoundManager.resumeMusic();
  }
}

// Simple background star component
class BackgroundStar extends PositionComponent {
  final Paint _paint = Paint()..color = Colors.white.withOpacity(0.6);
  
  BackgroundStar({
    required Vector2 position,
    required double size,
  }) : super(
          position: position,
          size: Vector2.all(size),
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