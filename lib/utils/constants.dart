import 'package:flutter/material.dart';

// Game Constants
const double kMaxGameWidth = 500.0;
const double kMaxContentWidth = 800.0;
const double kTabletBreakpoint = 600.0;

// Level Constants
const int kTotalLevels = 3;
const Map<int, String> kLevelNames = {
  1: 'Low Earth Orbit',
  2: 'Geosynchronous Orbit',
  3: 'Asteroid Field', 
};

const Map<int, String> kLevelDescriptions = {
  1: 'Clean up Low Earth Orbit by collecting space debris and avoiding satellites.',
  2: 'Navigate through Geosynchronous Orbit while collecting high-value debris.',
  3: 'Venture into the Asteroid Field for the ultimate challenge!',
};

// Game Theme Colors
const Color kPrimaryColor = Color(0xFF0B3D91); // NASA blue
const Color kAccentColor = Color(0xFFFF9E1B);  // NASA orange
const Color kBackgroundColor = Color(0xFF0F172A); // Deep space blue
const Color kTextColor = Color(0xFFEEF2FF);
const Color kSecondaryTextColor = Color(0xFFB0B9D0);

// Game Difficulty Settings
const double kEasySpeedFactor = 0.8;
const double kNormalSpeedFactor = 1.0;
const double kHardSpeedFactor = 1.5;

// Timer Constants
const int kLevelTimeLimitSeconds = 90;

// Scoring Constants
const int kSmallDebrisPoints = 10;
const int kMediumDebrisPoints = 30;
const int kLargeDebrisPoints = 50;
const int kBonusPointsPerSecond = 1;
const int kLevelCompletionBonus = 100; 