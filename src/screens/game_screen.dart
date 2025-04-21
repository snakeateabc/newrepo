import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../components/game_hud.dart';
import '../components/pause_menu.dart';
import '../game/orbital_cleanup_game.dart';
import '../utils/constants.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late OrbitalCleanupGame _game;
  bool _isPaused = false;
  bool _isGameOver = false;
  int _score = 0;
  int _targetScore = 0;
  int _timeRemaining = kLevelTimeLimitSeconds;
  int _levelId = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get level ID from arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is int) {
      _levelId = args;
    }
    
    // Create game instance
    _game = OrbitalCleanupGame(
      levelId: _levelId,
      onGameOver: _handleGameOver,
    );
  }

  void _handleGameOver(bool isCompleted, int score, int timeRemaining) {
    setState(() {
      _isGameOver = true;
    });
    
    // Navigate to result screen
    Navigator.pushReplacementNamed(
      context,
      '/result',
      arguments: {
        'levelId': _levelId,
        'score': score,
        'isCompleted': isCompleted,
        'timeRemaining': timeRemaining,
      },
    );
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    
    if (_isPaused) {
      _game.pauseEngine();
    } else {
      _game.resumeEngine();
    }
  }

  void _restartLevel() {
    Navigator.pushReplacementNamed(
      context,
      '/game',
      arguments: _levelId,
    );
  }

  void _exitToMenu() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: WillPopScope(
        onWillPop: () async {
          if (!_isGameOver) {
            _togglePause();
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: Stack(
            children: [
              // Game canvas
              GameWidget(game: _game),
              
              // HUD
              Positioned(
                top: 0,
                left: 0,
                right: 0,
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
                    );
                  },
                ),
              ),
              
              // Pause button
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: kPrimaryColor.withOpacity(0.7),
                  child: Icon(
                    _isPaused ? Icons.play_arrow : Icons.pause,
                    color: kTextColor,
                  ),
                  onPressed: _togglePause,
                ),
              ),
              
              // Pause menu
              if (_isPaused)
                PauseMenu(
                  onResume: _togglePause,
                  onRestart: _restartLevel,
                  onExit: _exitToMenu,
                ),
            ],
          ),
        ),
      ),
    );
  }
} 