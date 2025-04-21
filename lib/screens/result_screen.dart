import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/responsive_layout.dart';
import '../components/cosmic_button.dart';
import '../components/parallax_stars.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the results from the arguments
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int levelId = args['levelId'] ?? 1;
    final int score = args['score'] ?? 0;
    final bool isLevelCompleted = args['isCompleted'] ?? false;
    final int timeRemaining = args['timeRemaining'] ?? 0;
    
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          // Animated stars background
          ParallaxStars(),
          
          // Content
          SafeArea(
            child: ResponsiveLayout(
              mobile: _buildMobileLayout(
                context, 
                levelId: levelId,
                score: score,
                isLevelCompleted: isLevelCompleted,
                timeRemaining: timeRemaining,
              ),
              tablet: _buildTabletLayout(
                context,
                levelId: levelId,
                score: score,
                isLevelCompleted: isLevelCompleted,
                timeRemaining: timeRemaining,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context, {
    required int levelId,
    required int score,
    required bool isLevelCompleted,
    required int timeRemaining,
  }) {
    return MaxWidthContainer(
      child: _buildContent(
        context,
        levelId: levelId,
        score: score,
        isLevelCompleted: isLevelCompleted,
        timeRemaining: timeRemaining,
        isTablet: false,
      ),
    );
  }

  Widget _buildTabletLayout(
    BuildContext context, {
    required int levelId,
    required int score,
    required bool isLevelCompleted,
    required int timeRemaining,
  }) {
    return MaxWidthContainer(
      child: _buildContent(
        context,
        levelId: levelId,
        score: score,
        isLevelCompleted: isLevelCompleted,
        timeRemaining: timeRemaining,
        isTablet: true,
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required int levelId,
    required int score,
    required bool isLevelCompleted,
    required int timeRemaining,
    required bool isTablet,
  }) {
    final headerSize = isTablet ? 32.0 : 28.0;
    final textSize = isTablet ? 18.0 : 16.0;
    final levelName = kLevelNames[levelId] ?? 'Level $levelId';
    
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 48.0 : 24.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Result header
            Text(
              isLevelCompleted ? 'MISSION COMPLETE' : 'MISSION FAILED',
              style: TextStyle(
                fontSize: headerSize,
                fontWeight: FontWeight.bold,
                color: isLevelCompleted ? kAccentColor : Colors.red,
                letterSpacing: 2.0,
              ),
            ),
            
            SizedBox(height: 16.0),
            
            // Level name
            Text(
              levelName,
              style: TextStyle(
                fontSize: textSize,
                color: kTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            SizedBox(height: 48.0),
            
            // Score card
            Container(
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: kPrimaryColor,
                  width: 2.0,
                ),
              ),
              child: Column(
                children: [
                  // Score row
                  _buildStatRow(
                    'Total Score',
                    '$score',
                    isTablet: isTablet,
                    highlight: true,
                  ),
                  
                  SizedBox(height: 16.0),
                  
                  // Time bonus row (if level completed)
                  if (isLevelCompleted) ...[
                    _buildStatRow(
                      'Time Remaining',
                      '$timeRemaining seconds',
                      isTablet: isTablet,
                    ),
                    SizedBox(height: 16.0),
                    _buildStatRow(
                      'Time Bonus',
                      '+${timeRemaining * kBonusPointsPerSecond}',
                      isTablet: isTablet,
                    ),
                    SizedBox(height: 16.0),
                    _buildStatRow(
                      'Completion Bonus',
                      '+$kLevelCompletionBonus',
                      isTablet: isTablet,
                    ),
                    SizedBox(height: 24.0),
                    Divider(color: kPrimaryColor),
                    SizedBox(height: 24.0),
                    _buildStatRow(
                      'Final Score',
                      '${score + (timeRemaining * kBonusPointsPerSecond) + kLevelCompletionBonus}',
                      isTablet: isTablet,
                      highlight: true,
                      large: true,
                    ),
                  ],
                ],
              ),
            ),
            
            SizedBox(height: 48.0),
            
            // Action buttons
            Row(
              children: [
                // Replay button
                Expanded(
                  child: CosmicButton(
                    label: 'REPLAY',
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/game',
                        arguments: levelId,
                      );
                    },
                    isPrimary: false,
                  ),
                ),
                
                SizedBox(width: 16.0),
                
                // Continue button
                Expanded(
                  child: CosmicButton(
                    label: 'CONTINUE',
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/level_select',
                        (route) => route.isFirst,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    String label,
    String value, {
    required bool isTablet,
    bool highlight = false,
    bool large = false,
  }) {
    final textSize = isTablet ? 18.0 : 16.0;
    final valueSize = large ? textSize * 1.5 : textSize;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: textSize,
            color: kSecondaryTextColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: valueSize,
            fontWeight: FontWeight.bold,
            color: highlight ? kAccentColor : kTextColor,
          ),
        ),
      ],
    );
  }
} 