import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/responsive_layout.dart';
import '../components/cosmic_button.dart';
import '../components/parallax_stars.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          // Animated stars background
          ParallaxStars(),
          
          // Content
          ResponsiveLayout(
            mobile: _buildMobileLayout(context),
            tablet: _buildTabletLayout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return MaxWidthContainer(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildContent(context, isTablet: false),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return MaxWidthContainer(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildContent(context, isTablet: true),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context, {required bool isTablet}) {
    final titleSize = isTablet ? 48.0 : 36.0;
    final subtitleSize = isTablet ? 20.0 : 16.0;
    final buttonSize = isTablet ? 20.0 : 16.0;
    
    return [
      const Spacer(),
      
      // Title
      Text(
        'ORBITAL',
        style: TextStyle(
          fontSize: titleSize * 1.5,
          fontWeight: FontWeight.bold,
          color: kTextColor,
          letterSpacing: 4.0,
        ),
      ),
      Text(
        'CLEANUP',
        style: TextStyle(
          fontSize: titleSize,
          fontWeight: FontWeight.bold,
          color: kAccentColor,
          letterSpacing: 2.0,
        ),
      ),
      SizedBox(height: 32),
      
      // Description
      Text(
        'Save Earth\'s orbit from space debris',
        style: TextStyle(
          fontSize: subtitleSize,
          color: kSecondaryTextColor,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      
      const Spacer(),
      
      // Start button
      CosmicButton(
        label: 'START MISSION',
        onPressed: () {
          Navigator.pushNamed(context, '/level_select');
        },
        fontSize: buttonSize,
      ),
      
      SizedBox(height: 20),
      
      // Footer
      Text(
        'Tap to navigate and collect debris',
        style: TextStyle(
          fontSize: 14,
          color: kSecondaryTextColor,
        ),
      ),
      
      SizedBox(height: 40),
    ];
  }
} 