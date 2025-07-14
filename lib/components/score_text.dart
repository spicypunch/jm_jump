import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../jm_jump_game.dart';

class ScoreText extends TextComponent with HasGameReference<JmJumpGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
    
    position = Vector2(20, 50);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    text = 'Score: ${game.score}';
  }
}