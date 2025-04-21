import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'cosmic_button.dart';

class PauseMenu extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onExit;
  
  const PauseMenu({
    Key? key,
    required this.onResume,
    required this.onRestart,
    required this.onExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: kPrimaryColor,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: kPrimaryColor.withOpacity(0.5),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PAUSED',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kTextColor,
                  letterSpacing: 2,
                ),
              ),
              
              SizedBox(height: 32),
              
              // Resume button
              CosmicButton(
                label: 'RESUME',
                onPressed: onResume,
                isPrimary: true,
              ),
              
              SizedBox(height: 16),
              
              // Restart button
              CosmicButton(
                label: 'RESTART LEVEL',
                onPressed: onRestart,
                isPrimary: false,
              ),
              
              SizedBox(height: 16),
              
              // Exit button
              CosmicButton(
                label: 'EXIT TO MENU',
                onPressed: onExit,
                isPrimary: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 