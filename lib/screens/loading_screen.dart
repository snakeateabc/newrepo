import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/sound_manager.dart';
import '../components/parallax_stars.dart';
import 'dart:async';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoading = true;
  String _loadingText = 'Preparing for mission...';
  late Timer _timeoutTimer;
  
  @override
  void initState() {
    super.initState();
    // Set a timeout to prevent getting stuck on loading screen
    _timeoutTimer = Timer(Duration(seconds: 5), () {
      if (mounted) {
        _proceedToNextScreen();
      }
    });
    _initializeGame();
  }
  
  @override
  void dispose() {
    _timeoutTimer.cancel();
    super.dispose();
  }
  
  Future<void> _initializeGame() async {
    try {
      // Initialize sound manager silently without showing messages
      await SoundManager.initialize();
      
      // Brief delay for a smoother experience
      await Future.delayed(Duration(milliseconds: 500));
      
      // Start background music without showing messages
      await SoundManager.playMusic('background_music');
      
      // Navigate to start screen
      _proceedToNextScreen();
    } catch (e) {
      debugPrint('Error during initialization: $e');
      // Still proceed to next screen even if there's an error
      _proceedToNextScreen();
    }
  }
  
  void _proceedToNextScreen() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          // Animated stars background
          ParallaxStars(),
          
          // Loading content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Game title
                Text(
                  'ORBITAL',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: kTextColor,
                    letterSpacing: 4.0,
                  ),
                ),
                Text(
                  'CLEANUP',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: kAccentColor,
                    letterSpacing: 2.0,
                  ),
                ),
                
                SizedBox(height: 48),
                
                // Loading indicator
                if (_isLoading) ...[
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kAccentColor),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
} 