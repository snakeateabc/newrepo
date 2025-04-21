import 'package:flutter/foundation.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  bool _isMusicEnabled = false; // Default to disabled
  static const String _musicEnabledKey = 'music_enabled';

  // Music credit information
  static const String musicTitle = "Dreamcatcher";
  static const String musicArtist = "Onycs";
  static const String musicLicense = "Licensed under Creative Commons";

  // Static wrapper for initialization - now a no-op
  static Future<void> initialize() async {
    // Do nothing, audio is disabled
    debugPrint('Audio system disabled');
  }

  // Static wrapper for playing music - now a no-op
  static Future<void> playMusic(String musicName) async {
    // Do nothing, audio is disabled
    debugPrint('Audio playback disabled');
  }

  // Initialize the sound manager - now a no-op
  Future<void> _initializeInternal() async {
    // Do nothing, audio is disabled
  }

  // Play background music - now a no-op
  Future<void> playBackgroundMusic() async {
    // Do nothing, audio is disabled
  }

  // Stop background music - now a no-op
  Future<void> stopBackgroundMusic() async {
    // Do nothing, audio is disabled
  }

  // Pause background music - now a no-op
  Future<void> pauseBackgroundMusic() async {
    // Do nothing, audio is disabled
  }

  // Resume background music - now a no-op
  Future<void> resumeBackgroundMusic() async {
    // Do nothing, audio is disabled
  }

  // Toggle music on/off - now just updates state
  Future<void> toggleMusic() async {
    _isMusicEnabled = !_isMusicEnabled;
    debugPrint('Music toggled: $_isMusicEnabled (no actual effect)');
  }

  // Get music enabled status
  bool get isMusicEnabled => _isMusicEnabled;

  // Dispose resources - now a no-op
  Future<void> dispose() async {
    // Nothing to dispose
  }

  // Get music credit information
  static String getMusicCredit() {
    return 'Background music: "$musicTitle" by $musicArtist\n$musicLicense\n(Audio currently disabled)';
  }
} 