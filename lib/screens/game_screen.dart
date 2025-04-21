import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../game/orbital_cleanup_game.dart';
import '../utils/constants.dart';
import '../components/game_hud.dart';
import '../components/pause_menu.dart';
import '../utils/responsive_layout.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late OrbitalCleanupGame _game;
  bool _isPaused = false;
  int _score = 0;
  int _targetScore = 0;
  int _timeRemaining = kLevelTimeLimitSeconds;
  late int _levelId;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_isInitialized) {
      // Get level ID from route arguments
      _levelId = ModalRoute.of(context)?.settings.arguments as int? ?? 1;
      
      // Get device type to adjust game parameters
      final isWideScreen = MediaQuery.of(context).size.width >= kTabletBreakpoint;
      final isDesktop = isWideScreen && MediaQuery.of(context).size.width > 900;
      
      // Initialize game with device-specific settings
      _game = OrbitalCleanupGame(
        levelId: _levelId,
        onGameOver: _handleGameOver,
        isDesktopMode: isDesktop,
      );
      
      _isInitialized = true;
    }
  }

  void _handleGameOver(bool isCompleted, int score, int timeRemaining) {
    Navigator.pushReplacementNamed(
      context,
      '/result',
      arguments: {
        'levelId': _levelId,
        'isCompleted': isCompleted,
        'score': score,
        'timeRemaining': timeRemaining,
      },
    );
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _game.pauseEngine();
      } else {
        _game.resumeEngine();
      }
    });
  }

  void _restartLevel() {
    Navigator.pushReplacementNamed(
      context, 
      '/game',
      arguments: _levelId,
    );
  }

  void _exitToMenu() {
    Navigator.pushReplacementNamed(context, '/level_select');
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final screenSize = MediaQuery.of(context).size;
    final isWideScreen = screenSize.width >= kTabletBreakpoint;
    final isDesktop = isWideScreen && screenSize.width > 900;
    
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: isDesktop
              ? _buildDesktopLayout(screenSize)
              : _buildMobileLayout(screenSize, isWideScreen),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(Size screenSize, bool isWideScreen) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: isWideScreen ? kMaxContentWidth : double.infinity,
      ),
      child: Stack(
        children: [
          // Game view - vertical 2:3 aspect ratio for mobile
          AspectRatio(
            aspectRatio: 2/3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isWideScreen ? 16 : 0),
              child: GameWidget(game: _game),
            ),
          ),
          
          // HUD overlay
          _buildHUD(),
          
          // Pause menu
          if (_isPaused) _buildPauseMenu(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(Size screenSize) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: kMaxContentWidth,
        maxHeight: screenSize.height * 0.9,
      ),
      child: Stack(
        children: [
          // Game view - horizontal 3:2 aspect ratio for desktop
          AspectRatio(
            aspectRatio: 3/2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GameWidget(game: _game),
            ),
          ),
          
          // HUD overlay
          _buildHUD(),
          
          // Pause menu
          if (_isPaused) _buildPauseMenu(),
        ],
      ),
    );
  }

  Widget _buildHUD() {
    return Positioned.fill(
      child: StreamBuilder<Map<String, dynamic>>(
        stream: _game.stream,
        initialData: {
          'score': 0,
          'targetScore': 0,
          'timeRemaining': kLevelTimeLimitSeconds,
        },
        builder: (context, snapshot) {
          _score = snapshot.data?['score'] ?? 0;
          _targetScore = snapshot.data?['targetScore'] ?? 0;
          _timeRemaining = snapshot.data?['timeRemaining'] ?? kLevelTimeLimitSeconds;
          
          return GameHUD(
            score: _score,
            targetScore: _targetScore,
            timeRemaining: _timeRemaining,
            currentLevel: _levelId,
            onPausePressed: _togglePause,
          );
        },
      ),
    );
  }

  Widget _buildPauseMenu() {
    return Positioned.fill(
      child: PauseMenu(
        onResume: _togglePause,
        onRestart: _restartLevel,
        onExit: _exitToMenu,
      ),
    );
  }

  @override
  void dispose() {
    _game.removeFromParent();
    super.dispose();
  }
} 