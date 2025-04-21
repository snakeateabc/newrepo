import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/sound_manager.dart';
import '../components/parallax_stars.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoading = true;
  String _loadingText = 'Loading...';
  
  @override
  void initState() {
    super.initState();
    _initializeGame();
  }
  
  Future<void> _initializeGame() async {
    try {
      // Initialize sound manager
      setState(() => _loadingText = 'Initializing audio...');
      await SoundManager.initialize();
      
      // Add artificial delay for smoother experience
      await Future.delayed(Duration(seconds: 1));
      
      // Start background music
      await SoundManager.playMusic('background_music');
      
      // Navigate to start screen
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      setState(() {
        _loadingText = 'Error loading game assets';
        _isLoading = false;
      });
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
                  SizedBox(height: 24),
                  Text(
                    _loadingText,
                    style: TextStyle(
                      fontSize: 16,
                      color: kSecondaryTextColor,
                    ),
                  ),
                ] else
                  Text(
                    _loadingText,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 