import 'package:flutter/material.dart';
import '../utils/sound_manager.dart';
import '../components/cosmic_button.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const SettingsScreen({
    Key? key,
    required this.onBack,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SoundManager _soundManager;
  late bool _isMusicEnabled;

  @override
  void initState() {
    super.initState();
    _soundManager = SoundManager();
    _isMusicEnabled = _soundManager.isMusicEnabled;
  }

  void _toggleMusic() async {
    await _soundManager.toggleMusic();
    setState(() {
      _isMusicEnabled = _soundManager.isMusicEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Back button
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
                onPressed: widget.onBack,
              ),
            ),
            
            // Settings content
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    const Text(
                      'SETTINGS',
                      style: TextStyle(
                        fontSize: 28, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    
                    // Music toggle
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.darkGrey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Background Music',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Switch(
                            value: _isMusicEnabled,
                            onChanged: (_) => _toggleMusic(),
                            activeColor: AppColors.accent,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Credit section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.darkGrey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Music Credits',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            SoundManager.getMusicCredit(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Back button
                    CosmicButton(
                      label: 'BACK',
                      onPressed: widget.onBack,
                      height: 56.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 