import 'package:flutter/material.dart';
import '../constants/colors.dart';

class GameInstructions extends StatelessWidget {
  final bool isTablet;
  
  const GameInstructions({
    Key? key,
    this.isTablet = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MISSION OBJECTIVES',
            style: TextStyle(
              fontSize: isTablet ? 20.0 : 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 16),
          
          // Collect green debris
          _buildInstructionRow(
            icon: Icons.check_circle,
            iconColor: Colors.green,
            text: 'Collect green debris to score points and complete the level',
          ),
          SizedBox(height: 12),
          
          // Avoid red objects
          _buildInstructionRow(
            icon: Icons.dangerous,
            iconColor: Colors.red,
            text: 'Avoid red asteroids and hazards - collision means game over!',
          ),
          SizedBox(height: 12),
          
          // Complete level
          _buildInstructionRow(
            icon: Icons.emoji_events,
            iconColor: Colors.amber,
            text: 'Reach the target score before time runs out to advance',
          ),
          
          SizedBox(height: 16),
          Divider(color: Colors.white24),
          SizedBox(height: 16),
          
          // Visual legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem(
                color: Colors.lightGreen.shade400,
                shape: BoxShape.circle,
                label: 'Collect',
              ),
              _buildLegendItem(
                color: Colors.red.shade400,
                shape: BoxShape.circle,
                label: 'Avoid',
              ),
              _buildLegendItem(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                label: 'Player',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionRow({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: isTablet ? 24.0 : 20.0,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isTablet ? 16.0 : 14.0,
              color: Colors.white,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required BoxShape shape,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: shape,
            borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(4) : null,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
} 