import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CosmicButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final double fontSize;
  final bool isEnabled;
  final bool isPrimary;

  const CosmicButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.fontSize = 16.0,
    this.isEnabled = true,
    this.isPrimary = true,
  }) : super(key: key);

  @override
  _CosmicButtonState createState() => _CosmicButtonState();
}

class _CosmicButtonState extends State<CosmicButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isEnabled) {
      setState(() {
        _isPressed = true;
      });
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isEnabled) {
      setState(() {
        _isPressed = false;
      });
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.isEnabled) {
      setState(() {
        _isPressed = false;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.isPrimary ? kAccentColor : kPrimaryColor;
    final disabledColor = Colors.grey.shade700;
    final activeColor = widget.isEnabled ? buttonColor : disabledColor;
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.isEnabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: double.infinity,
          height: 56.0,
          decoration: BoxDecoration(
            color: activeColor,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: _isPressed && widget.isEnabled
                ? []
                : [
                    BoxShadow(
                      color: buttonColor.withOpacity(0.5),
                      blurRadius: 10.0,
                      offset: Offset(0, 4),
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: kTextColor,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 