import 'package:flutter/material.dart';
import 'colors.dart';
import 'dimensions.dart';

class AppTextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.25,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  
  // Button text
  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 1.0,
  );
  
  // Game specific styles
  static const TextStyle hudText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    shadows: [
      Shadow(
        color: Colors.black54,
        offset: Offset(1.0, 1.0),
        blurRadius: 2.0,
      ),
    ],
  );
  
  static const TextStyle scoreText = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    shadows: [
      Shadow(
        color: Colors.black87,
        offset: Offset(1.5, 1.5),
        blurRadius: 3.0,
      ),
    ],
  );
  
  static const TextStyle timerText = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    color: AppColors.warning,
    letterSpacing: 0.5,
    shadows: [
      Shadow(
        color: Colors.black87,
        offset: Offset(1.0, 1.0),
        blurRadius: 2.0,
      ),
    ],
  );
  
  static const TextStyle gameOverText = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.bold,
    color: AppColors.error,
    letterSpacing: 1.0,
    shadows: [
      Shadow(
        color: Colors.black,
        offset: Offset(2.0, 2.0),
        blurRadius: 4.0,
      ),
    ],
  );
} 