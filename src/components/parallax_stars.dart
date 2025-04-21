import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ParallaxStars extends StatefulWidget {
  final int starCount;
  final bool animate;

  const ParallaxStars({
    Key? key,
    this.starCount = 100,
    this.animate = true,
  }) : super(key: key);

  @override
  _ParallaxStarsState createState() => _ParallaxStarsState();
}

class _ParallaxStarsState extends State<ParallaxStars> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Star> _stars;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    
    // Create random stars
    _stars = List.generate(
      widget.starCount,
      (_) => Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2 + 0.5,
        speed: _random.nextDouble() * 0.4 + 0.1,
      ),
    );
    
    // Animation controller for star movement
    _controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: 10), // Long animation
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: StarFieldPainter(
            stars: _stars,
            animationValue: widget.animate ? _controller.value : 0.0,
          ),
          child: Container(),
        );
      },
    );
  }
}

class Star {
  double x; // 0.0 to 1.0
  double y; // 0.0 to 1.0
  final double size;
  final double speed;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}

class StarFieldPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;
  
  StarFieldPainter({
    required this.stars,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    
    for (final star in stars) {
      // Calculate the star's y position with parallax effect
      final y = (star.y + (animationValue * star.speed)) % 1.0;
      
      // Calculate actual position on the canvas
      final position = Offset(
        star.x * size.width,
        y * size.height,
      );
      
      // Draw the star
      canvas.drawCircle(position, star.size, paint);
      
      // Add a glow effect to larger stars
      if (star.size > 1.0) {
        final glowPaint = Paint()
          ..color = Colors.white.withOpacity(0.5)
          ..style = PaintingStyle.fill
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, star.size * 2);
        
        canvas.drawCircle(position, star.size * 1.5, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant StarFieldPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
} 