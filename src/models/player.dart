import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent with HasGameRef, TapCallbacks {
  // Player properties
  double speed = 300;
  final double size;
  
  // Internal state
  Vector2 targetPosition = Vector2.zero();
  bool isMoving = false;
  
  // Visuals
  final Paint _bodyPaint = Paint()..color = Colors.blue.shade600;
  final Paint _engineGlowPaint = Paint()..color = Colors.orange.shade500;
  
  Player({
    required Vector2 position,
    this.size = 32.0,
  }) : super(
         position: position,
         size: Vector2(size, size),
         anchor: Anchor.center,
       );
  
  @override
  void onMount() {
    super.onMount();
    targetPosition = position.clone();
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Move towards target position
    if (position.distanceTo(targetPosition) > 5) {
      isMoving = true;
      
      final direction = targetPosition - position;
      direction.normalize();
      
      position.add(direction * speed * dt);
    } else {
      isMoving = false;
    }
    
    // Keep player within screen bounds
    position.x = position.x.clamp(size / 2, gameRef.size.x - size / 2);
    position.y = position.y.clamp(size / 2, gameRef.size.y - size / 2);
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Engine glow
    if (isMoving) {
      final engineOffset = size * 0.15;
      canvas.drawCircle(
        Offset(0, size * 0.4),
        size * 0.3,
        _engineGlowPaint,
      );
    }
    
    // Ship body
    final path = Path()
      ..moveTo(0, -size * 0.4)  // Top center
      ..lineTo(size * 0.4, size * 0.4)  // Bottom right
      ..lineTo(0, size * 0.2)  // Middle center
      ..lineTo(-size * 0.4, size * 0.4)  // Bottom left
      ..close();
    
    canvas.drawPath(path, _bodyPaint);
    
    // Cockpit
    canvas.drawCircle(
      Offset(0, -size * 0.1),
      size * 0.15,
      Paint()..color = Colors.lightBlue.shade100,
    );
  }
  
  void moveTo(Vector2 target) {
    targetPosition = target.clone();
  }
} 