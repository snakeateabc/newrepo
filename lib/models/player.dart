import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent {
  Vector2 targetPosition = Vector2.zero();
  bool isMoving = false;
  double moveSpeed = 300.0;

  final Paint _bodyPaint = Paint()..color = Colors.blue.shade600;
  final Paint _engineGlowPaint = Paint()..color = Colors.orange.shade500;

  Player({required Vector2 initialPosition, required Vector2 initialSize}) : super(position: initialPosition, size: initialSize);

  void moveTo(Vector2 newPosition) {
    targetPosition = newPosition;
    isMoving = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isMoving) {
      final Vector2 direction = targetPosition - position;
      final double distance = direction.length;
      
      if (distance > 1.0) {
        direction.normalize();
        position += direction * moveSpeed * dt;
      } else {
        position = targetPosition;
        isMoving = false;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Draw engine glow
    final path = Path()
      ..moveTo(size.x / 2, size.y)
      ..lineTo(size.x / 4, size.y * 0.8)
      ..lineTo(size.x * 3 / 4, size.y * 0.8)
      ..close();
    canvas.drawPath(path, _engineGlowPaint);

    // Draw ship body
    final shipPath = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(0, size.y * 0.8)
      ..lineTo(size.x, size.y * 0.8)
      ..close();
    canvas.drawPath(shipPath, _bodyPaint);

    // Draw cockpit
    canvas.drawCircle(
      Offset(size.x / 2, size.y * 0.4),
      size.x * 0.15,
      Paint()..color = Colors.lightBlue.shade100,
    );
  }
} 