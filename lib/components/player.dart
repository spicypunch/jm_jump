import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../jm_jump_game.dart';
import 'platform.dart';

class Player extends RectangleComponent 
    with HasGameReference<JmJumpGame>, CollisionCallbacks {
  
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasStarted = false;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    paint = Paint()..color = Colors.green;
    
    add(RectangleHitbox());
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    position += velocity * dt;
    
    if (position.x < 0) {
      position.x = 400;
    } else if (position.x > 400) {
      position.x = 0;
    }
    
    velocity.x *= 0.95;
    
    // 첫 번째 점프가 일어나면 게임 시작으로 간주
    if (velocity.y < 0) {
      hasStarted = true;
    }
  }
  
  @override
  bool onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Platform && velocity.y >= 0) {
      if (position.y + size.y / 2 <= other.position.y + 10) {
        velocity.y = game.jumpVelocity;
        isOnGround = true;
        hasStarted = true;
        return true;
      }
    }
    return false;
  }
  
  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is Platform) {
      isOnGround = false;
    }
  }
}