import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'jm_jump_game.dart';
import 'overlays/game_over_overlay.dart';

void main() {
  runApp(const JmJumpApp());
}

class JmJumpApp extends StatelessWidget {
  const JmJumpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JM Jump',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late JmJumpGame game;

  @override
  void initState() {
    super.initState();
    game = JmJumpGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<JmJumpGame>.controlled(
        gameFactory: () => game,
        overlayBuilderMap: {
          'GameOver': (context, game) => GameOverOverlay(game: game),
        },
      ),
    );
  }
}