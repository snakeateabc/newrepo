import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/loading_screen.dart';
import 'screens/start_screen.dart';
import 'screens/level_select_screen.dart';
import 'screens/game_screen.dart';
import 'screens/result_screen.dart';
import 'utils/game_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize preferences
  final prefs = await SharedPreferences.getInstance();
  GamePreferences.initialize(prefs);
  
  runApp(OrbitalCleanupApp());
}

class OrbitalCleanupApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orbital Cleanup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Exo2',
      ),
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => LoadingScreen(),
        '/': (context) => StartScreen(),
        '/level_select': (context) => LevelSelectScreen(),
        '/game': (context) => GameScreen(),
        '/result': (context) => ResultScreen(),
      },
    );
  }
} 