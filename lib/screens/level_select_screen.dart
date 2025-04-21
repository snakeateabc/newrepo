import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/game_preferences.dart';
import '../utils/responsive_layout.dart';
import '../components/cosmic_button.dart';
import '../components/parallax_stars.dart';
import '../components/game_instructions.dart';

class LevelSelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          // Animated stars background
          ParallaxStars(),
          
          // Content
          SafeArea(
            child: ResponsiveLayout(
              mobile: _buildMobileLayout(context),
              tablet: _buildTabletLayout(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context, isTablet: false),
        
        // Instructions panel
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GameInstructions(isTablet: false),
        ),
        
        const SizedBox(height: 16),
        
        // Level grid
        Expanded(
          child: MaxWidthContainer(
            child: _buildLevelGrid(context, isTablet: false),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      children: [
        // Left side with header and instructions
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context, isTablet: true),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: GameInstructions(isTablet: true),
              ),
              Spacer(),
            ],
          ),
        ),
        
        // Right side with level grid
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: _buildLevelGrid(context, isTablet: true),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, {required bool isTablet}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24.0 : 16.0,
        vertical: isTablet ? 24.0 : 16.0,
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: Icon(Icons.arrow_back, color: kTextColor),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Center(
              child: Text(
                'SELECT MISSION',
                style: TextStyle(
                  fontSize: isTablet ? 28.0 : 22.0,
                  fontWeight: FontWeight.bold,
                  color: kTextColor,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
          // Empty space to balance the back button
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildLevelGrid(BuildContext context, {required bool isTablet}) {
    final completedLevels = GamePreferences.getCompletedLevels();
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16.0 : 16.0,
        vertical: 16.0,
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet ? 2 : 1,
          childAspectRatio: isTablet ? 1.5 : 1.5,
          crossAxisSpacing: 24.0,
          mainAxisSpacing: 24.0,
        ),
        itemCount: kTotalLevels,
        itemBuilder: (context, index) {
          final levelId = index + 1;
          final isCompleted = completedLevels.contains(levelId);
          final isUnlocked = levelId == 1 || 
                           completedLevels.contains(levelId - 1);
          
          return _buildLevelCard(
            context,
            levelId: levelId,
            isCompleted: isCompleted,
            isUnlocked: isUnlocked,
            isTablet: isTablet,
          );
        },
      ),
    );
  }

  Widget _buildLevelCard(
    BuildContext context, {
    required int levelId,
    required bool isCompleted,
    required bool isUnlocked,
    required bool isTablet,
  }) {
    final levelName = kLevelNames[levelId] ?? 'Level $levelId';
    final levelDescription = kLevelDescriptions[levelId] ?? '';
    final highScore = GamePreferences.getHighScore(levelId);
    
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isCompleted
              ? kAccentColor
              : kPrimaryColor.withOpacity(0.5),
          width: 2.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.0),
        child: Stack(
          children: [
            // Content
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Level name
                    Text(
                      levelName,
                      style: TextStyle(
                        fontSize: isTablet ? 24.0 : 20.0,
                        fontWeight: FontWeight.bold,
                        color: kTextColor,
                      ),
                    ),
                    
                    SizedBox(height: 8.0),
                    
                    // Level description
                    Text(
                      levelDescription,
                      style: TextStyle(
                        fontSize: isTablet ? 16.0 : 14.0,
                        color: kSecondaryTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    Spacer(),
                    
                    // High score
                    if (isCompleted) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: kAccentColor,
                            size: isTablet ? 24.0 : 20.0,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'High Score: $highScore',
                            style: TextStyle(
                              fontSize: isTablet ? 16.0 : 14.0,
                              color: kAccentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.0),
                    ],
                    
                    // Play button
                    CosmicButton(
                      label: isCompleted
                          ? 'PLAY AGAIN'
                          : isUnlocked
                              ? 'START'
                              : 'LOCKED',
                      onPressed: () {
                        if (isUnlocked) {
                          Navigator.pushNamed(
                            context,
                            '/game',
                            arguments: levelId,
                          );
                        }
                      },
                      fontSize: isTablet ? 16.0 : 14.0,
                      isEnabled: isUnlocked,
                      isPrimary: !isCompleted,
                      height: 48.0,
                    ),
                  ],
                ),
              ),
            ),
            
            // Completed badge
            if (isCompleted)
              Positioned(
                top: 12.0,
                right: 12.0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: kAccentColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    'COMPLETED',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 