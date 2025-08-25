import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game/managers/game_state_manager.dart';
import 'custom_buttons.dart';

class UIOverlay extends StatelessWidget {
  const UIOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateManager>(
      builder: (context, gameState, child) {
        return Stack(
          children: [
            // Top Bar
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Level Display
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Level ${gameState.progress.currentLevel}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Score: ${gameState.progress.totalScore}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Reset Button
                  CustomIconButton(
                    icon: Icons.refresh,
                    onPressed: () {
                      // Reset level logic
                    },
                    backgroundColor: Colors.white.withOpacity(0.2),
                    iconColor: Colors.white,
                  ),
                ],
              ),
            ),
            
            // Bottom Controls
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Legend
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        LegendItem(icon: '🌀', label: 'Auto-Rotate'),
                        LegendItem(icon: '🧲', label: 'Magnet'),
                        LegendItem(icon: '🌊', label: 'Trampoline'),
                        LegendItem(icon: '❄️', label: 'Ice'),
                        LegendItem(icon: '🔥', label: 'Lava'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Instructions
                  Text(
                    'Tap green obstacles to rotate',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Drop Button
                  CustomButton(
                    text: 'DROP!',
                    onPressed: gameState.currentState == GameState.playing
                        ? () {
                            // Drop ball logic
                          }
                        : null,
                    width: 160,
                    height: 50,
                  ),
                ],
              ),
            ),
            
            // Game State Overlays
            if (gameState.currentState == GameState.levelComplete)
              _buildLevelCompleteOverlay(context, gameState),
            
            if (gameState.currentState == GameState.gameOver)
              _buildGameOverOverlay(context, gameState),
            
            if (gameState.currentState == GameState.paused)
              _buildPauseOverlay(context, gameState),
          ],
        );
      },
    );
  }

  Widget _buildLevelCompleteOverlay(
    BuildContext context,
    GameStateManager gameState,
  ) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎉',
                style: TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                'PERFECT!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Level ${gameState.progress.currentLevel - 1} Complete',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    text: 'Menu',
                    onPressed: () => gameState.goToMenu(),
                    backgroundColor: Colors.grey[300],
                    textColor: Colors.black87,
                    width: 100,
                  ),
                  CustomButton(
                    text: 'Next Level',
                    onPressed: () => gameState.nextLevel(),
                    width: 120,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverOverlay(
    BuildContext context,
    GameStateManager gameState,
  ) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '💥',
                style: TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                'FAILED!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF5252),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Attempts: ${gameState.currentAttempts}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    text: 'Menu',
                    onPressed: () => gameState.goToMenu(),
                    backgroundColor: Colors.grey[300],
                    textColor: Colors.black87,
                    width: 100,
                  ),
                  CustomButton(
                    text: 'Retry',
                    onPressed: () => gameState.restartLevel(),
                    width: 100,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPauseOverlay(
    BuildContext context,
    GameStateManager gameState,
  ) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '⏸️',
                style: TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                'PAUSED',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    text: 'Menu',
                    onPressed: () => gameState.goToMenu(),
                    backgroundColor: Colors.grey[300],
                    textColor: Colors.black87,
                    width: 100,
                  ),
                  CustomButton(
                    text: 'Resume',
                    onPressed: () => gameState.resumeGame(),
                    width: 100,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final String icon;
  final String label;

  const LegendItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}