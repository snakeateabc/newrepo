import 'package:flutter/material.dart';
import '../utils/constants.dart';

class GameHUD extends StatelessWidget {
  final int score;
  final int targetScore;
  final int timeRemaining;
  final int currentLevel;
  
  const GameHUD({
    Key? key,
    required this.score,
    required this.targetScore,
    required this.timeRemaining,
    required this.currentLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top bar with level and timer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Level indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'LEVEL $currentLevel',
                  style: TextStyle(
                    color: kTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              
              // Timer
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getTimerColor().withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer,
                      color: kTextColor,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      _formatTime(timeRemaining),
                      style: TextStyle(
                        color: kTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 8),
          
          // Score display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SCORE: $score',
                  style: TextStyle(
                    color: kTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'TARGET: $targetScore',
                  style: TextStyle(
                    color: _getScoreColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 8),
          
          // Score progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: score / targetScore,
              backgroundColor: Colors.grey.shade800,
              valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor()),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }
  
  Color _getTimerColor() {
    if (timeRemaining < 10) {
      return Colors.red;
    } else if (timeRemaining < 30) {
      return Colors.orange;
    } else {
      return kPrimaryColor;
    }
  }
  
  Color _getScoreColor() {
    if (score >= targetScore) {
      return Colors.green;
    } else if (score >= targetScore * 0.7) {
      return Colors.yellow;
    } else {
      return kSecondaryTextColor;
    }
  }
  
  Color _getProgressColor() {
    if (score >= targetScore) {
      return Colors.green;
    } else if (score >= targetScore * 0.7) {
      return kAccentColor;
    } else {
      return kPrimaryColor;
    }
  }
} 