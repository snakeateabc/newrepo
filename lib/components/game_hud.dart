import 'package:flutter/material.dart';
import '../utils/constants.dart';

class GameHUD extends StatelessWidget {
  final int score;
  final int targetScore;
  final int timeRemaining;
  final int currentLevel;
  final VoidCallback onPausePressed;
  
  const GameHUD({
    Key? key,
    required this.score,
    required this.targetScore,
    required this.timeRemaining,
    required this.currentLevel,
    required this.onPausePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Score and level
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$score / $targetScore',
                style: const TextStyle(
                  color: kTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Level $currentLevel',
                style: const TextStyle(
                  color: kSecondaryTextColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          
          // Timer and pause button
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${timeRemaining}s',
                  style: const TextStyle(
                    color: kTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.pause, color: kTextColor),
                onPressed: onPausePressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
} 