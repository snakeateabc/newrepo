import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

enum DebrisSize {
  small,
  medium,
  large,
}

enum DebrisType {
  satellite,
  trash,
  asteroid,
}

class SpaceDebris extends PositionComponent with HasGameRef, TapCallbacks {
  // Debris properties
  final DebrisSize debrisSize;
  final DebrisType debrisType;
  double rotationSpeed;
  
  // Internal state
  final Random _random = Random();
  bool isCollected = false;
  bool isHazard;
  
  // Visuals
  late final Paint _debrisPaint;
  
  SpaceDebris({
    required Vector2 position,
    required this.debrisSize,
    required this.debrisType,
    this.rotationSpeed = 0.5,
    this.isHazard = false,
  }) : super(
         position: position,
         size: Vector2.all(_getSizeValue(debrisSize)),
         anchor: Anchor.center,
       ) {
    angle = _random.nextDouble() * 2 * pi;
    
    // Set paint color based on debris type
    _debrisPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = _getDebrisColor();
  }
  
  static double _getSizeValue(DebrisSize size) {
    switch (size) {
      case DebrisSize.small:
        return 20.0;
      case DebrisSize.medium:
        return 35.0;
      case DebrisSize.large:
        return 50.0;
    }
  }
  
  Color _getDebrisColor() {
    switch (debrisType) {
      case DebrisType.satellite:
        return Colors.grey.shade300;
      case DebrisType.trash:
        return isHazard ? Colors.red.shade400 : Colors.lightGreen.shade400;
      case DebrisType.asteroid:
        return Colors.brown.shade700;
    }
  }
  
  int get pointValue {
    if (isHazard) return 0;
    
    switch (debrisSize) {
      case DebrisSize.small:
        return kSmallDebrisPoints;
      case DebrisSize.medium:
        return kMediumDebrisPoints;
      case DebrisSize.large:
        return kLargeDebrisPoints;
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Rotate the debris
    angle += rotationSpeed * dt;
    
    // Move vertically (simulating orbital movement)
    position.y += 50 * dt;
    
    // Reset if off-screen
    if (position.y > gameRef.size.y + size.y) {
      removeFromParent();
    }
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw different shapes based on debris type
    switch (debrisType) {
      case DebrisType.satellite:
        _renderSatellite(canvas);
        break;
      case DebrisType.trash:
        _renderTrash(canvas);
        break;
      case DebrisType.asteroid:
        _renderAsteroid(canvas);
        break;
    }
  }
  
  void _renderSatellite(Canvas canvas) {
    // Draw satellite body
    final bodyWidth = size.x * 0.8;
    final bodyHeight = size.y * 0.4;
    
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: bodyWidth,
        height: bodyHeight,
      ),
      _debrisPaint,
    );
    
    // Draw solar panels
    final panelWidth = size.x * 0.9;
    final panelHeight = size.y * 0.2;
    
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(0, -bodyHeight),
        width: panelWidth,
        height: panelHeight,
      ),
      Paint()..color = Colors.blue.shade700,
    );
    
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(0, bodyHeight),
        width: panelWidth,
        height: panelHeight,
      ),
      Paint()..color = Colors.blue.shade700,
    );
    
    // Antenna
    canvas.drawLine(
      Offset(0, -bodyHeight * 1.5),
      Offset(0, -bodyHeight * 2.5),
      Paint()
        ..color = Colors.grey.shade600
        ..strokeWidth = 2.0,
    );
  }
  
  void _renderTrash(Canvas canvas) {
    if (isHazard) {
      // Hazardous trash (spiky)
      final path = Path();
      final radius = size.x / 2;
      final spikes = 8;
      
      for (var i = 0; i < spikes * 2; i++) {
        final angle = i * pi / spikes;
        final radiusMultiplier = i.isEven ? 1.0 : 0.6;
        final x = cos(angle) * radius * radiusMultiplier;
        final y = sin(angle) * radius * radiusMultiplier;
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      
      path.close();
      canvas.drawPath(path, _debrisPaint);
    } else {
      // Regular trash (jagged shape)
      final path = Path();
      final points = 6;
      final radius = size.x / 2;
      
      for (var i = 0; i < points; i++) {
        final angle = (i / points) * 2 * pi;
        final jitter = 0.2 + _random.nextDouble() * 0.3;
        final x = cos(angle) * radius * jitter;
        final y = sin(angle) * radius * jitter;
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      
      path.close();
      canvas.drawPath(path, _debrisPaint);
    }
  }
  
  void _renderAsteroid(Canvas canvas) {
    // Irregular rock shape
    final path = Path();
    final points = 10;
    final radius = size.x / 2;
    
    for (var i = 0; i < points; i++) {
      final angle = (i / points) * 2 * pi;
      final jitter = 0.7 + _random.nextDouble() * 0.6;
      final x = cos(angle) * radius * jitter;
      final y = sin(angle) * radius * jitter;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.close();
    canvas.drawPath(path, _debrisPaint);
    
    // Add some crater details
    for (var i = 0; i < 3; i++) {
      final craterAngle = _random.nextDouble() * 2 * pi;
      final craterDist = _random.nextDouble() * (radius * 0.5);
      final craterX = cos(craterAngle) * craterDist;
      final craterY = sin(craterAngle) * craterDist;
      final craterSize = radius * (_random.nextDouble() * 0.2 + 0.1);
      
      canvas.drawCircle(
        Offset(craterX, craterY),
        craterSize,
        Paint()..color = Colors.brown.shade900,
      );
    }
  }
  
  void collect() {
    if (!isHazard) {
      isCollected = true;
      removeFromParent();
    }
  }
} 