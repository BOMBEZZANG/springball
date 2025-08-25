import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game/screens/game_screen.dart';
import 'game/managers/game_state_manager.dart';

void main() {
  runApp(const PhysicsBallDropApp());
}

class PhysicsBallDropApp extends StatelessWidget {
  const PhysicsBallDropApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameStateManager()),
      ],
      child: MaterialApp(
        title: 'Physics Ball Drop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1e3c72),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const GameScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
