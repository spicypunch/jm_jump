import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../jm_jump_game.dart';

class Platform extends RectangleComponent with HasGameReference<JmJumpGame> {
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    paint = Paint()..color = Colors.brown;
    
    add(RectangleHitbox());
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (position.y > game.cameraComponent.viewfinder.position.y + 600) {
      removeFromParent();
    }
  }
}