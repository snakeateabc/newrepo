import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundManager {
  static late AudioPlayer _effectsPlayer;
  static late AudioPlayer _musicPlayer;
  static bool _isSoundEnabled = true;
  static bool _isMusicEnabled = true;
  static const String _soundKey = 'sound_enabled';
  static const String _musicKey = 'music_enabled';
  
  static Future<void> initialize() async {
    _effectsPlayer = AudioPlayer();
    _musicPlayer = AudioPlayer();
    
    // Load preferences
    final prefs = await SharedPreferences.getInstance();
    _isSoundEnabled = prefs.getBool(_soundKey) ?? true;
    _isMusicEnabled = prefs.getBool(_musicKey) ?? true;
    
    // Set up music player
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(0.5);
  }
  
  static Future<void> playSound(String soundName) async {
    if (!_isSoundEnabled) return;
    
    try {
      await _effectsPlayer.play(AssetSource('audio/$soundName.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
  
  static Future<void> playMusic(String musicName) async {
    if (!_isMusicEnabled) return;
    
    try {
      await _musicPlayer.play(AssetSource('audio/$musicName.mp3'));
    } catch (e) {
      print('Error playing music: $e');
    }
  }
  
  static Future<void> stopMusic() async {
    await _musicPlayer.stop();
  }
  
  static Future<void> pauseMusic() async {
    await _musicPlayer.pause();
  }
  
  static Future<void> resumeMusic() async {
    if (!_isMusicEnabled) return;
    await _musicPlayer.resume();
  }
  
  static Future<void> toggleSound() async {
    _isSoundEnabled = !_isSoundEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, _isSoundEnabled);
  }
  
  static Future<void> toggleMusic() async {
    _isMusicEnabled = !_isMusicEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_musicKey, _isMusicEnabled);
    
    if (_isMusicEnabled) {
      await _musicPlayer.resume();
    } else {
      await _musicPlayer.pause();
    }
  }
  
  static bool get isSoundEnabled => _isSoundEnabled;
  static bool get isMusicEnabled => _isMusicEnabled;
  
  static Future<void> dispose() async {
    await _effectsPlayer.dispose();
    await _musicPlayer.dispose();
  }
} 