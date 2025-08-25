import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';
import '../physics_ball_game.dart';
import '../managers/game_state_manager.dart';
import '../../widgets/ui_overlay.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late PhysicsBallGame game;

  @override
  void initState() {
    super.initState();
    game = PhysicsBallGame();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    game.gameStateManager = context.read<GameStateManager>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              width: 400,
              height: 600,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1e3c72),
                    Color(0xFF2a5298),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Game Widget
                    GameWidget(game: game),
                    
                    // UI Overlay
                    const UIOverlay(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}